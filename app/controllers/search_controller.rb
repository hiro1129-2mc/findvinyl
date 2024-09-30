class SearchController < ApplicationController
  skip_before_action :require_login, only: [:index]

  def index
    @type = params[:type]
    @q = get_search_query(@type, params[:q])
    @results = preload_associations(@q.result(distinct: true)).page(params[:page]).per(15)
  end

  private

  def preload_associations(query)
    case @type
    when 'release'
      query.includes(artist_credit: [], mediums: :medium_format)
    else
      query
    end
  end
end
