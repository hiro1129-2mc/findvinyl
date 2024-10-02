class ItemsController < ApplicationController
  before_action :set_item, only: %i[show edit update move_to_collection soft_delete]
  before_action :set_select_items, only: %i[new create edit update]

  def collection_items
    items = current_user.items.collection_items.active
    @items_search = items.ransack(params[:q])
    @items = @items_search.result.page(params[:page]).per(10)
  end

  def want_items
    items = current_user.items.want_items.active
    @items_search = items.ransack(params[:q])
    @items = @items_search.result.page(params[:page]).per(10)
  end

  def new
    @item = Item.new(role: params[:role])

    @title = params[:title]
    @artist_name = params[:artist_name]
    @release_format = params[:release_format]
    @press_country = params[:press_country]
  end

  def create
    @item = build_item
    if save_item
      redirect_to item_path(@item), notice: t('items.new.saved')
    else
      flash.now[:danger] = t('items.new.not_created')
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    if update_item
      redirect_to item_path(@item), notice: t('items.edit.edit')
    else
      flash.now[:danger] = t('items.edit.not_edited')
      render :edit, status: :unprocessable_entity
    end
  end

  # 欲しいものリストのitemをコレクションリストに移動
  def move_to_collection
    if @item.update(role: 'collection')
      redirect_to want_items_path, notice: t('items.role_updated_to_collection')
    else
      redirect_to want_items_path, alert: t('items.role_update_failed')
    end
  end

  # recordに紐づけられたitemに影響を与えないため論理削除にしている
  def soft_delete
    role = @item.role
    @item.update(status: :deleted)

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

  def set_select_items
    @conditions = Condition.all
    @accessories = Accessory.all
  end

  def build_item
    item = current_user.items.build(item_params.except(:title, :artist_name, :release_format, :press_country, :matrix_number, :tag, accessory_ids: []))
    item.find_or_create_related_objects(item_association_params)
    item
  end

  def save_item
    accessory_names = params[:item][:accessory]&.split(',') || []
    tag_names = params[:item][:tag]&.split(',') || []

    @item.save_with_accessories(accessory_names:) &&
      @item.save_with_tags(tag_names:) &&
      @item.save
  end

  def update_item
    @item.find_or_create_related_objects(item_association_params)

    accessory_names = params[:item][:accessory]&.split(',') || []
    tag_names = params[:item][:tag]&.split(',') || []

    @item.save_with_accessories(accessory_names:) &&
      @item.save_with_tags(tag_names:) &&
      @item.update(item_params.except(:title, :artist_name, :release_format, :press_country, :matrix_number, :tag, accessory_ids: []))
  end

  def item_association_params
    {
      title: params[:item][:title],
      artist_name: params[:item][:artist_name],
      release_format: params[:item][:release_format],
      press_country: params[:item][:press_country],
      matrix_number: params[:item][:matrix_number]
    }
  end
end
