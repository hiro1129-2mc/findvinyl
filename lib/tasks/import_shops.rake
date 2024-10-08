require 'net/http'
require 'uri'
require 'json'

namespace :shop do
  desc 'Import record shops from Google Places API'
  task import: :environment do
    api_base_url = 'https://maps.googleapis.com/maps/api/place'
    api_key = ENV['API_KEY']

    search_results = search_shops(api_base_url, api_key)
    if search_results
      search_results.each do |result|
        details = fetch_shop_details(api_base_url, api_key, result['place_id'])
        save_shop(details) if details
      end
    else
      puts 'APIリクエストに失敗しました。'
    end
  end

  # レコードショップをテキスト検索するリクエストを送信
  def search_shops(api_base_url, api_key)
    search_uri = URI("#{api_base_url}/textsearch/json")
    search_params = {
      query: 'record shops in 横須賀',
      language: 'ja',
      type: 'store',
      key: api_key
    }
    search_uri.query = URI.encode_www_form(search_params)

    search_response = Net::HTTP.get_response(search_uri)
    if search_response.is_a?(Net::HTTPSuccess)
      JSON.parse(search_response.body)['results']
    else
      puts "検索APIリクエストに失敗しました。#{search_response.body}"
      nil
    end
  end

  # 検索結果のショップのplace_idを使用して、各ショップの詳細情報を取得するリクエストを送信
  def fetch_shop_details(api_base_url, api_key, place_id)
    details_uri = URI("#{api_base_url}/details/json")
    details_params = {
      place_id:,
      key: api_key,
      language: 'ja',
      fields: 'place_id,formatted_address,name,formatted_phone_number,opening_hours,website,geometry,photo'
    }
    details_uri.query = URI.encode_www_form(details_params)

    details_response = Net::HTTP.get_response(details_uri)
    if details_response.is_a?(Net::HTTPSuccess)
      JSON.parse(details_response.body)['result']
    else
      puts "詳細APIリクエストに失敗しました。#{details_response.body}"
      nil
    end
  end

  # 詳細情報のレスポンスをShopテーブルに保存
  def save_shop(details)
    shop = Shop.find_or_initialize_by(place_id: details['place_id'])
    shop.assign_attributes(
      name: details['name'],
      address: details['formatted_address'].sub(/^日本、\s*〒\d{3}-\d{4}\s*/, ''),
      phone_number: details['formatted_phone_number'],
      opening_hours: details['opening_hours'] ? details['opening_hours']['weekday_text'].join(', ') : nil,
      web_site: details['website'],
      shop_image: details.dig('photos', 0, 'photo_reference'),
      latitude: details.dig('geometry', 'location', 'lat'),
      longitude: details.dig('geometry', 'location', 'lng'),
      postal_code: extract_postal_code(details['formatted_address'])
    )

    if shop.save
      puts "#{shop.name}の保存が完了しました。"
    else
      puts "#{shop.name}の保存に失敗しました。error: #{shop.errors.full_messages.join(', ')}"
    end
  rescue StandardError => e
    puts "#{details['name']}の保存に失敗しました。#{e.message}"
  end

  # addressから郵便番号を抽出
  def extract_postal_code(address)
    match = address.match(/〒(\d{3}-\d{4})/)
    match ? match[1] : nil
  end
end
