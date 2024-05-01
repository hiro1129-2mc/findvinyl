class RecordsController < ApplicationController
  before_action :require_login
  before_action :set_record, only: %i[show edit update destroy]

  def index
    @records_by_date = current_user.records.group_by { |record| record.created_at.to_date }
  end

  def search
    items = current_user.items
    @items_search = items.ransack(title_name_or_artist_name_name_cont: params[:q])
    @items = @items_search.result.includes(:title, :artist_name)

    items_json = @items.as_json(include: %i[title artist_name])
    render json: items_json
  end

  def new
    @record = Record.new
  end

  def create
    @record = current_user.records.build(record_params.except(:item_ids))
    if @record.save
      if params[:item_ids].present?
        params[:item_ids].each do |item_id|
          @record.record_items.create(item_id:) unless item_id.blank?
        end
      end
      redirect_to records_path, notice: t('records.new.saved')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @record = current_user.records.find(params[:id])
    gon.record_items = @record.items.includes(:title, :artist_name).map do |item|
      {
        id: item.id,
        title: item.title.name,
        artist_name: item.artist_name.name
      }
    end
  end

  def update
    @record = current_user.records.find(params[:id])
    if @record.update(record_params.except(:item_ids))
      @record.record_items.destroy_all
      if params[:item_ids].present?
        params[:item_ids].each do |item_id|
          @record.record_items.create(item_id:) unless item_id.blank?
        end
      end
      redirect_to record_path(@record), notice: t('records.update.saved')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @record = Record.find(params[:id])
  end

  def daily_records
    date = Date.parse(params[:date])
    @records = current_user.records.where('DATE(created_at) = ?', date)
  end

  def destroy
    @record = current_user.records.find(params[:id])
    @record.destroy!
    redirect_to records_path, success: t('records.delete.success')
  end

  private

  def set_record
    @record = current_user.records.find_by(id: params[:id])
    redirect_to records_path, alert: 'Record not found.' if @record.nil?
  end

  def record_params
    params.require(:record).permit(:content, item_ids: [])
  end
end
