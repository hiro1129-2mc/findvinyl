class ApplicationController < ActionController::Base
  before_action :require_login
  before_action :store_location
  before_action :set_search
  add_flash_types :success, :danger

  helper_method :current_user

  def set_search
    @q = get_search_query(params[:q], params[:type])
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  private

  def not_authenticated
    redirect_to main_app.login_path, danger: t('defaults.flash_message.require_login')
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
    return unless !logged_in? && request.get? && !request.xhr? && !request.fullpath.match?(%r{/login|/users/new|/password_resets/new|/password_resets/edit|/emails/new|/emails/edit})

    session[:previous_url] = request.fullpath
  end
end
