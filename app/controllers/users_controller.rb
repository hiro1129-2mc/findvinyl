class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  before_action :set_user, only: %i[destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: t('users.create.success')
    else
      flash.now[:alert] = t('users.create.failure')
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to :root, notice: t('users.destroy.success')
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
