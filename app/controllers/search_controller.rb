class SearchController < ApplicationController

  def index
    @type = params[:type]
    @q = get_search_query(@type, params[:q])

    @results = preload_associations(@q.result(distinct: true)).page(params[:page]).per(10)
  end

  private
  
  def get_search_query(type, search_params)
    case type
    when 'artist'
      Artist.ransack(search_params)
    when 'release'
      Release.ransack(search_params)
    else
      Artist.none.ransack
    end
  end

  def preload_associations(query)
    case @type
    when 'release'
      query.includes(artist_credit: [], mediums: :medium_format)
    else
      query
    end
  end
end
