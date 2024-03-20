class TagsController < ApplicationController
  def index
    @tag = Tag.find(params[:tag_id])
    tagged_items = current_user.items.joins(:tags).where(tags: { id: @tag.id })

    @q = tagged_items.ransack(params[:q])

    case params[:view_type]
    when 'collection_items'
      @items = results.collection_items.page(params[:page]).per(20)
      render 'items/collection_items'
    when 'want_items'
      @items = results.want_items.page(params[:page]).per(20)
      render 'items/want_items'
    end
  end
end
