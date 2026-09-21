class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Helpers de autenticação
  helper_method :current_user, :logged_in?

  def current_user
    return if session[:user_id].nil?
    @current_user ||= User.find_by(id: session[:user_id])
    session.delete(:user_id) if @current_user.nil?
    @current_user
  end

  def logged_in?
    !!current_user
  end

  def require_login
    unless logged_in?
      flash[:alert] = I18n.t("auth.login_required")
      redirect_to login_path
    end
  end
end
