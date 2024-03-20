class ItemsController < ApplicationController
  before_action :require_login
  before_action :set_item, only: %i[show edit update destroy]
  before_action :set_select_collections, only: [:new, :create, :edit, :update]

  def index
    case params[:view_type]
    when 'collection_items'
      items = current_user.items.collection_items
      @q = items.ransack(params[:q])
      results = @q.result
      @items = @q.result.page(params[:page]).per(20)
      render 'collection_items'
    when 'want_items'
      items = current_user.items.want_items
      @q = items.ransack(params[:q])
      @items = @q.result.page(params[:page]).per(20)
      render 'want_items'
    end
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
      redirect_to items_path, success: "アイテムを保存しました"
    else
      flash.now[:danger] = "アイテムを作成できませんでした"
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
      redirect_to item_path(@item), success: "アイテムを編集しました"
    else
      flash.now[:danger] = "アイテムを編集できませんでした"
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
    raise ActiveRecord::RecordNotFound, "指定されたアイテムが見つかりません。" unless @item
  end
  

  def set_select_collections
    @press_countries = PressCountry.all
    @conditions = Condition.all
    @accessories = Accessory.all
  end
end
