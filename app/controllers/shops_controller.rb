class ShopsController < ApplicationController
  def map
    @shops = Shop.all
  end
end
