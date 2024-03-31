class ItemsController < ApplicationController
  before_action :require_login
  before_action :set_item, only: %i[show edit update destroy move_to_collection]
  before_action :set_select_collections, only: %i[new create edit update]

  def index
    case params[:view_type]
    when 'collection_items'
      items = current_user.items.collection_items
      @items_search = items.ransack(params[:q])
      @items = @items_search.result.page(params[:page]).per(20)
      render 'collection_items'
    when 'want_items'
      items = current_user.items.want_items
      @items_search = items.ransack(params[:q])
      @items = @items_search.result.page(params[:page]).per(20)
      render 'want_items'
    end
  end

  def new
    @item = Item.new(role: params[:role])
    @press_countries = PressCountry.all
    @conditions = Condition.all
    @accessories = Accessory.all

    @title = params[:title]
    @artist_name = params[:artist_name]
    @release_format = params[:release_format]
    @press_country = params[:press_country]
  end

  def create
    @item = current_user.items.build(item_params.except(:title, :artist_name, :release_format, :press_country, :matrix_number, :tag, accessory_ids: []))

    @item.find_or_create_related_objects({
                                           title: params[:item][:title],
                                           artist_name: params[:item][:artist_name],
                                           release_format: params[:item][:release_format],
                                           press_country: params[:item][:press_country],
                                           matrix_number: params[:item][:matrix_number]
                                         })

    accessory_names = params[:item][:accessory]&.split(',') || []
    @item.save_with_accessories(accessory_names:)

    tag_names = params[:item][:tag]&.split(',') || []
    @item.save_with_tags(tag_names:)

    if @item.save
      if @item.role == 'collection'
        redirect_to collection_items_path, notice: t('items.new.saved')
      else
        @item.role
        redirect_to want_items_path, notice: t('items.new.saved')
      end
    else
      flash.now[:danger] = t('items.new.not_created')
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
                                           release_format: params[:item][:release_format],
                                           press_country: params[:item][:press_country],
                                           matrix_number: params[:item][:matrix_number]
                                         })

    accessory_names = params[:item][:accessory]&.split(',') || []
    @item.save_with_accessories(accessory_names:)

    tag_names = params[:item][:tag]&.split(',') || []
    @item.save_with_tags(tag_names:)

    if @item.update(item_params.except(:title, :artist_name, :release_format, :press_country, :matrix_number, :tag, accessory_ids: []))
      if @item.role == 'collection'
        redirect_to collection_items_path, notice: t('items.edit.edit')
      else
        @item.role
        redirect_to want_items_path, notice: t('items.edit.edit')
      end
    else
      flash.now[:danger] = t('items.edit.not_edited')
      render :edit, status: :unprocessable_entity
    end
  end

  def move_to_collection
    if @item.update(role: 'collection')
      redirect_to want_items_path, notice: t('items.role_updated_to_collection')
    else
      redirect_to want_items_path, alert: t('items.role_update_failed')
    end
  end

  def destroy
    @item = current_user.items.find(params[:id])
    role = @item.role
    @item.destroy!
    if role == 'collection'
      redirect_to collection_items_path, notice: t('items.delete.success.collection')
    else
      redirect_to want_items_path, notice: t('items.delete.success.want')
    end
  end

  private

  def item_params
    params.require(:item).permit(:title, :artist_name, :release_format, :press_country, :matrix_number, :condition_id, :user_note, :role, :tag, accessory_ids: [])
  end

  def set_item
    @item = current_user.items.find_by(id: params[:id])
    raise ActiveRecord::RecordNotFound, t('items.index.not_found') unless @item
  end

  def set_select_collections
    @press_countries = PressCountry.all
    @conditions = Condition.all
    @accessories = Accessory.all
  end
end
