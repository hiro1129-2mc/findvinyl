class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def create
    @user = login(params[:email], params[:password])

    if @user
      redirect_to after_login_path_for(@user), notice: t('user_sessions.create.success')
    else
      flash.now[:danger] = t('user_sessions.create.failure')
      render :new, status: :unprocessable_entity
    end
  end

  def after_login_path_for(_resource)
    session[:previous_url] || root_path
  end

  def destroy
    logout
    redirect_to root_path, status: :see_other, notice: t('user_sessions.destroy.success')
  end
end
