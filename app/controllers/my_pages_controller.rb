class MyPagesController < ApplicationController
  before_action :require_login
  before_action :set_user, only: %i[show]

  def show
    @random = Item.where(user_id: @user.id, role: 0, status: 0).order('RANDOM()').limit(5)

    @date = Date.current
    record_item_service = RecordItemService.new(current_user)
    @artist_name_distribution = record_item_service.artist_name_distribution(@date)
  end

  private

  def set_user
    @user = User.find(current_user.id)
  end
end
