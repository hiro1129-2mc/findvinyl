class ShopBookmarksController < ApplicationController
  def create
    @shop = Shop.find(params[:shop_id])
    current_user.bookmark(@shop)
  end

  def destroy
    @shop = current_user.shop_bookmarks.find(params[:id]).shop
    current_user.unbookmark(@shop)
  end
end
