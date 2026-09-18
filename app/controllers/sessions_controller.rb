class SessionsController < ApplicationController
  def new
    # Formulário de login
  end

  def create
    user = User.find_by(email: params[:email].to_s.strip.downcase)

    if user && user.authenticate(params[:password])
      reset_session
      session[:user_id] = user.id
      redirect_to root_path, notice: "Login realizado com sucesso!"
    else
      flash.now[:alert] = "Email ou senha inválidos"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to login_path, notice: "Logout realizado com sucesso!"
  end
end
