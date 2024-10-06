class RecordsController < ApplicationController
  before_action :set_record, only: %i[edit update show destroy]

  def index
    @date = determine_date
    user_record_stats_service = UserRecordStatsService.new(current_user)

    # recordを作成した日にカレンダーに♪を表示するための変数
    @records_by_date = current_user.records.group_by { |record| record.created_at.to_date }
    # 円グラフを表示するための変数
    @artist_name_distribution = user_record_stats_service.artist_name_distribution(@date)
  end

  def search
    items = current_user.items.where(status: :active)
    @items_search = items.ransack(title_name_or_artist_name_name_cont: params[:q])
    @items = @items_search.result.includes(:title, :artist_name)

    items_json = @items.as_json(include: %i[title artist_name])
    render json: items_json
  end

  def new
    @record = Record.new
  end

  def create
    @record = current_user.records.build(record_params)
    if @record.save
      params[:item_ids].each do |item_id|
        @record.record_items.create(item_id:)
      end
      redirect_to records_path, notice: t('defaults.flash_message.created', item: Record.model_name.human)
    else
      flash.now[:alert] = t('defaults.flash_message.not_created', item: Record.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    gon.record_items = @record.items.includes(:title, :artist_name).map do |item|
      {
        id: item.id,
        title: item.title.name,
        artist_name: item.artist_name.name
      }
    end
  end

  def update
    if @record.update(record_params)
      @record.record_items.destroy_all
      params[:item_ids].each do |item_id|
        @record.record_items.create(item_id:)
      end
      redirect_to record_path(@record), notice: t('defaults.flash_message.updated', item: Record.model_name.human)
    else
      flash.now[:alert] = t('defaults.flash_message.not_updated', item: Record.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  def show; end

  def daily_records
    date = Date.parse(params[:date])
    @records = current_user.records
                           .where(created_at: date.in_time_zone.all_day)
                           .page(params[:page]).per(6)
  end

  def destroy
    @record.destroy!
    redirect_to records_path, notice: t('defaults.flash_message.deleted', item: Record.model_name.human)
  end

  def report_show
    @date = determine_date
    user_record_stats_service = UserRecordStatsService.new(current_user)

    @artist_name_distribution = user_record_stats_service.artist_name_distribution(@date)
    @monthly_creation_count = user_record_stats_service.monthly_creation_count(@date)
    @top_titles = user_record_stats_service.top_titles_by_month(@date)
  end

  private

  def set_record
    @record = current_user.records.find_by(id: params[:id])
    redirect_to records_path, alert: t('records.not_found') if @record.nil?
    raise ActiveRecord::RecordNotFound, t('defaults.flash_message.not_found', item: Record.model_name.human) unless @record
  end

  def record_params
    params.require(:record).permit(:content, item_ids: [])
  end

  def determine_date
    params[:month] ? Date.strptime(params[:month], '%Y-%m') : Date.current
  end
end
