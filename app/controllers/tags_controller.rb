class TagsController < ApplicationController
  before_action :set_tag_data

  def collection_tag_items
    @items = @results.collection_items.page(params[:page]).per(10)
    render 'items/collection_items'
  end

  def want_tag_items
    @items = @results.want_items.page(params[:page]).per(10)
    render 'items/want_items'
  end

  private

  def set_tag_data
    @tag = Tag.find(params[:tag_id])
    tagged_items = current_user.items.tagged_with(@tag.id)
    @items_search = tagged_items.ransack(params[:q])
    @results = @items_search.result
  end
end
