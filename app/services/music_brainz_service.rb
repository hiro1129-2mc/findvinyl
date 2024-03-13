class MusicBrainzService
  require 'net/http'
  require 'uri'

  # MusicBrainz APIのベースURL
  BASE_URL = 'https://musicbrainz.org/ws/2'

  def initialize
    @last_request_time = nil
  end

  def fetch_artist_details(gid)
    sleep_until_allowed
    url = "#{BASE_URL}/artist/#{gid}?fmt=json"
    response = request_to_musicbrainz_api(url)
    @last_request_time = Time.now
    JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
  end

  def fetch_release_details(gid)
    sleep_until_allowed
    url = "#{BASE_URL}/release/#{gid}?inc=recordings&fmt=json"
    response = request_to_musicbrainz_api(url)
    @last_request_time = Time.now
    JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
  end

  private

  def request_to_musicbrainz_api(endpoint)
    uri = URI(endpoint)
    request = Net::HTTP::Get.new(uri)
    request['User-Agent'] = 'VinylLog/1.0 ( cocom329@gmail.com )'
    Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end
  end

  def sleep_until_allowed
    return unless @last_request_time

    elapsed = Time.now - @last_request_time
    sleep(1 - elapsed) if elapsed < 1
  end
end
