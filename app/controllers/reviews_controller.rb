class ReviewsController < ApplicationController
  before_action :set_shop, only: %i[new create]

  def new
    @review = Review.new
  end

  def create
    @review = current_user.review.build(review_params)
    if @review.save
      flash.now.notice = 'レビューを投稿しました'
      render turbo_stream: [
        turbo_stream.prepend('reviews', @review),
        turbo_stream.update('flash', partial: 'shared/flash_message')
      ]
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def review_params
    params.require(:review).permit(:content).merge(shop_id: params[:shop_id])
  end

  def set_shop
    @shop = Shop.find(params[:shop_id])
  end
end
