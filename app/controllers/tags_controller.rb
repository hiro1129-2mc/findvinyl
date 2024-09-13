class TagsController < ApplicationController
  def collection_tag_items
    @tag = Tag.find(params[:tag_id])
    tagged_items = current_user.items.tagged_with(@tag.id)

    @items_search = tagged_items.ransack(params[:q])
    results = @items_search.result

    @items = results.collection_items.page(params[:page]).per(10)
    render 'items/collection_items'
  end

  def want_tag_items
    @tag = Tag.find(params[:tag_id])
    tagged_items = current_user.items.tagged_with(@tag.id)

    @items_search = tagged_items.ransack(params[:q])
    results = @items_search.result

    @items = results.want_items.page(params[:page]).per(10)
    render 'items/want_items'
  end
end
