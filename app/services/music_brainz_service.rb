class MusicBrainzService
  require 'net/http'
  require 'uri'

  BASE_URL = 'https://musicbrainz.org/ws/2'.freeze

  def initialize
    @last_request_time = nil
  end

  # artistsテーブルのgidを用いてアーティスト詳細情報を取得する
  def fetch_artist_details(gid)
    sleep_until_allowed
    url = "#{BASE_URL}/artist/#{gid}?fmt=json"
    response = request_to_musicbrainz_api(url)
    @last_request_time = Time.now
    JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
  end

  # releasesテーブルのgidを用いてリリース詳細情報を取得する
  def fetch_release_details(gid)
    sleep_until_allowed
    url = "#{BASE_URL}/release/#{gid}?inc=recordings&fmt=json"
    response = request_to_musicbrainz_api(url)
    @last_request_time = Time.now
    JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
  end

  private

  # APIリクエストを送信
  def request_to_musicbrainz_api(endpoint)
    uri = URI(endpoint)
    request = Net::HTTP::Get.new(uri)
    request['User-Agent'] = "VinylLog/1.0 ( #{ENV['MUSIC_BRAINZ_MAIL']} )"
    Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end
  end

  # レート制限対策(1秒に1リクエストまで)
  def sleep_until_allowed
    return unless @last_request_time

    elapsed = Time.now - @last_request_time
    sleep(1 - elapsed) if elapsed < 1
  end
end
