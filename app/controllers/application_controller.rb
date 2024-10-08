class ApplicationController < ActionController::Base
  before_action :require_login
  before_action :store_location
  before_action :set_search

  helper_method :current_user

  def set_search
    @q = get_search_query(params[:q], params[:type])
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  private

  def not_authenticated
    redirect_to main_app.login_path, alert: t('defaults.flash_message.require_login')
  end

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

  def store_location
    return if logged_in? || !request.get? || request.xhr? || request.fullpath.start_with?('/login', '/users/new', '/password_resets/', '/emails/')

    session[:previous_url] = request.fullpath
  end

  def after_login_path_for(_resource)
    session[:previous_url] || root_path
  end
end
