class UsersController < ApplicationController
  before_action :require_login, only: [ :show ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      reset_session
      session[:user_id] = @user.id
      redirect_to root_path, notice: I18n.t("auth.signup_success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    if params[:id].to_s != current_user.id.to_s
      redirect_to root_path, alert: I18n.t("auth.profile_forbidden")
    else
      @user = current_user
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
