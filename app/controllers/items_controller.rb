class ItemsController < ApplicationController
  before_action :require_login
  before_action :set_item, only: %i[show edit update destroy]

  def collection_items
    @q = current_user.items.collection.ransack(params[:q])
    @items = @q.result(distinct: true).includes(:user).order(title: :asc).page(params[:page])
  end

  def wont_items
    @q = current_user.items.wont.ransack(params[:q])
    @items = @q.result(distinct: true).includes(:user).order(title: :asc).page(params[:page])
  end

  def new
    @item = Item.new
  end

  def create
    @item = current_user.items.build(item_params)
    if @item.save
      redirect_to items_path
    else
      render :new
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def edit
    @item = current_user.items.find(params[:id])
  end

  def update
    @item = current_user.items.find(params[:id])
    if @item.update(item_params)
      redirect_to item_path(@item)
    else
      render :edit, status: :unprocessable_entity
  end

  def destroy
    item = current_user.items.find(params[:id])
    item.destroy!
    redirect_to items_path
  end

  def item_params
    params.require(:item).permit(:title, :artist_name, :press_country, :matrix_number, :condition, :user_note, :role, :tag, :accessory)
  end

  def set_item
    @item = current_user.items.find_by(id: params[:id])
    raise ActiveRecord::RecordNotFound unless @item
  end
end
