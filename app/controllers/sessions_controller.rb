class SessionsController < ApplicationController
  def new
    # Formulário de login
  end

  def create
    user = User.find_by(email: params[:email].to_s.strip.downcase)

    if user && user.authenticate(params[:password])
      reset_session
      session[:user_id] = user.id
      redirect_to root_path, notice: I18n.t("auth.login_success")
    else
      flash.now[:alert] = I18n.t("auth.invalid_credentials")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: I18n.t("auth.logout_success")
  end
end
