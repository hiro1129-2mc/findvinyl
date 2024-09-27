class ProfilesController < ApplicationController
  before_action :set_user, only: %i[edit update]

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to profile_path, notice: t('profile.edit.edit')
    else
      flash.now[:alert] = t('profile.edit.not_edited')
      render :edit, status: :unprocessable_entity
    end
  end

  def show; end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:name, :avatar, :avatar_cache)
  end
end
