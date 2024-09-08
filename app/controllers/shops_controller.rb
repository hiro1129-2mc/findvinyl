class ShopsController < ApplicationController
  skip_before_action :require_login, only: %i[map shop_image show]

  def map
    @shops_search = Shop.ransack(params[:q])
    @shops = @shops_search.result(distinct: true)

    return unless @shops.empty?

    redirect_to map_shops_path, notice: t('search.no_results')
  end

  def shop_image
    photo_reference = params[:photo_reference]
    image_url = fetch_image_from_google(photo_reference)
    render json: { imageUrl: image_url }
  end

  def show
    @shop = Shop.find(params[:id])
    @reviews = @shop.review.includes(:user).order(created_at: :desc)

    photo_reference = @shop.shop_image
    @image_url = fetch_image_from_google(photo_reference)
  end

  def bookmarks
    @bookmark_shops = current_user.bookmark_shops.order(:address).page(params[:page]).per(6)
    @shop_images = {}
    @bookmark_shops.each do |shop|
      @shop_images[shop.id] = fetch_image_from_google(shop.shop_image)
    end
  end

  def review_shops
    @review_shops = current_user.review_shops
                                .select('DISTINCT ON (shops.id) shops.*, reviews.created_at as review_created_at')
                                .order('shops.id, reviews.created_at DESC')
                                .page(params[:page])
                                .per(6)
    @shop_images = {}
    @review_shops.each do |shop|
      @shop_images[shop.id] = fetch_image_from_google(shop.shop_image)
    end
  end

  private

  def fetch_image_from_google(photo_reference)
    key = ENV['MAP_API_KEY']
    cache_key = "shop_image_#{photo_reference}"

    Rails.cache.fetch(cache_key, expires_in: 24.hours) do
      url = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=#{photo_reference}&key=#{key}"
      begin
        image_data = URI.open(url).read
        "data:image/jpeg;base64,#{Base64.encode64(image_data)}"
      rescue StandardError
        '/img/noimage.png'
      end
    end
  end
end
