class RecordsController < ApplicationController

  def index
    @records = current_user.records.includes(:user)
  end

  def new; end

  def create; end

  def edit; end

  def update; end

  def show; end

  def destroy; end
end
