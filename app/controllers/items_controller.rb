class ItemsController < ApplicationController
  before_action :require_login
  before_action :set_item, only: %i[show edit update destroy]
  before_action :set_select_collections, only: [:new, :create, :edit, :update]

  def collection_items
    @q = current_user.items.collection.ransack(params[:q])
    @items = @q.result(distinct: true).includes(:user).order(title: :asc).page(params[:page]).per(20)
  end

  def want_items
    @q = current_user.items.wont.ransack(params[:q])
    @items = @q.result(distinct: true).includes(:user).order(title: :asc).page(params[:page]).per(20)
  end

  def new
    @item = Item.new
    @press_countries = PressCountry.all
    @conditions = Condition.all
    @accessories = Accessory.all
  end

  def create
    @item = current_user.items.build(item_params.except(:title, :artist_name, :press_country, :matrix_number))

    @item.find_or_create_related_objects({
      title: params[:item][:title],
      artist_name: params[:item][:artist_name],
      press_country: params[:item][:press_country],
      matrix_number: params[:item][:matrix_number],
    })

    accessory_names = params[:item][:accessory]&.split(',') || []
    @item.save_with_accessories(accessory_names: accessory_names)

    tag_names = params[:item][:tag]&.split(',') || []
    @item.save_with_tags(tag_names: tag_names)

    if @item.save
      redirect_to items_path
    else
      render :new, status: :unprocessable_entity
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
  
    @item.find_or_create_related_objects({
      title: params[:item][:title],
      artist_name: params[:item][:artist_name],
      press_country: params[:item][:press_country],
      matrix_number: params[:item][:matrix_number],
    })
  
    accessory_names = params[:item][:accessory]&.split(',') || []
    @item.save_with_accessories(accessory_names: accessory_names)
  
    tag_names = params[:item][:tag]&.split(',') || []
    @item.save_with_tags(tag_names: tag_names)
  
    if @item.update(item_params.except(:title, :artist_name, :press_country, :matrix_number))
      redirect_to item_path(@item)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    item = current_user.items.find(params[:id])
    item.destroy!
    redirect_to items_path
  end

  private

  def item_params
    params.require(:item).permit(:title, :artist_name, :press_country, :matrix_number, :condition_id, :user_note, :role)
  end

  def set_item
    @item = current_user.items.find_by(id: params[:id])
    raise ActiveRecord::RecordNotFound unless @item
  end

  def set_select_collections
    @press_countries = PressCountry.all
    @conditions = Condition.all
    @accessories = Accessory.all
  end
end
