require 'net/http'
require 'uri'
require 'json'

namespace :shop do
  desc 'Import record shops from Google Places API'
  task import: :environment do
    api_base_url = 'https://maps.googleapis.com/maps/api/place'
    api_key = ENV['API_KEY']

    search_uri = URI("#{api_base_url}/textsearch/json")
    search_params = {
      query: 'record shops in Ikebukuro',
      language: 'ja',
      type: 'store',
      key: api_key
    }
    search_uri.query = URI.encode_www_form(search_params)

    search_response = Net::HTTP.get_response(search_uri)
    if search_response.is_a?(Net::HTTPSuccess)
      search_results = JSON.parse(search_response.body)['results']

      search_results.each do |result|
        place_id = result['place_id']
        details_uri = URI("#{api_base_url}/details/json")
        details_params = {
          place_id:,
          key: api_key,
          language: 'ja',
          fields: 'formatted_address,name,formatted_phone_number,opening_hours,website,geometry,photo'
        }
        details_uri.query = URI.encode_www_form(details_params)

        begin
          details_response = Net::HTTP.get_response(details_uri)
          details = JSON.parse(details_response.body)['result']

          Shop.find_or_create_by(place_id:) do |shop|
            shop.name = details['name']
            shop.address = details['formatted_address'].sub(/^日本、\s*〒\d{3}-\d{4}\s*/, '')
            shop.phone_number = details['formatted_phone_number']
            shop.opening_hours = details['opening_hours']['weekday_text'].join(', ') if details['opening_hours']
            shop.web_site = details['website']
            shop.shop_image = fetch_photo_url(details.dig('photos', 0, 'photo_reference'), api_key, api_base_url) if details['photos']&.any?
            shop.latitude = details.dig('geometry', 'location', 'lat')
            shop.longitude = details.dig('geometry', 'location', 'lng')
            shop.postal_code = extract_postal_code(details['formatted_address'])
          end
          puts "#{details['name']}の保存が完了しました。"
        rescue StandardError => e
          puts "#{details['name']}の保存に失敗しました。#{e.message}"
        end
      end
    else
      puts "APIリクエストに失敗しました。#{search_response.body}"
    end
  end

  def self.extract_postal_code(address)
    match = address.match(/〒(\d{3}-\d{4})/)
    match ? match[1] : nil
  end

  def self.fetch_photo_url(photo_reference, api_key, api_base_url)
    uri = URI("#{api_base_url}/photo")
    params = {
      maxwidth: 400,
      photoreference: photo_reference,
      key: api_key
    }
    uri.query = URI.encode_www_form(params)
    uri.to_s
  end
end
