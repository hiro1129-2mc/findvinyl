class ShopsController < ApplicationController
  skip_before_action :require_login, only: %i[map shop_image]

  def map
    @shops_search = Shop.ransack(params[:q])
    @shops = @shops_search.result(distinct: true)
  end

  def shop_image
    photo_reference = params[:photo_reference]
    image_url = fetch_image_from_google(photo_reference)
    render json: { imageUrl: image_url }
  end

  private

  def fetch_image_from_google(photo_reference)
    key = ENV['MAP_API_KEY']
    url = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=#{photo_reference}&key=#{key}"
    begin
      image_data = URI.open(url).read
      "data:image/jpeg;base64,#{Base64.encode64(image_data)}"
    rescue StandardError
      '/img/noimage.png'
    end
  end
end
