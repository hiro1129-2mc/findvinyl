class ReviewsController < ApplicationController
  before_action :set_shop, only: %i[new create]
  before_action :set_review, only: %i[edit update destroy]

  def new
    @review = Review.new
  end

  def create
    @review = current_user.reviews.build(review_params)
    if @review.save
      @reviews_count = @shop.review.count
      flash.now.notice = t('shops.reviews.new.success')
      render :create
    else
      flash.now[:alert] = t('shops.reviews.new.fail')
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @shop = @review.shop
  end

  def update
    if @review.update(review_params.except(:shop_id))
      flash.now.notice = t('shops.reviews.edit.edit')
      render turbo_stream: [
        turbo_stream.replace(@review),
        turbo_stream.update('flash', partial: 'shared/flash_message')
      ]
    else
      flash.now[:alert] = t('shops.reviews.edit.not_edited')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @shop = @review.shop
    @review.destroy!
    @reviews_count = @shop.review.count
    flash.now.notice = t('shops.reviews.delete.success')
    render :destroy
  end

  private

  def review_params
    params.require(:review).permit(:content).merge(shop_id: params[:shop_id])
  end

  def set_shop
    @shop = Shop.find(params[:shop_id])
  end

  def set_review
    @review = current_user.reviews.find(params[:id])
  end
end
