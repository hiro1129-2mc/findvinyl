class RecordsController < ApplicationController
  before_action :require_login

  def index
    records_grouped_by_date = current_user.records.group_by { |record| record.created_at.to_date }
    @records_by_date = records_grouped_by_date.keys
  end

  def search
    @items_search = Item.ransack(title_name_or_artist_name_name_cont: params[:q], user_id_eq: current_user.id)
    @items = @items_search.result.includes(:title, :artist_name)
  
    items_json = @items.as_json(include: [:title, :artist_name])
    render json: items_json
  end

  def new
    @record = Record.new
  end

  def create
    @record = current_user.records.build(record_params)
    if @record.save
      redirect_to records_path, notice: '記録を作成しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update; end

  def show; end

  def destroy; end

  private

  def record_params
    params.require(:record).permit(:content, item_ids: [])
  end
end
