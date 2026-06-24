class SessionsController < ApplicationController
  skip_before_action :require_authentication, only: [ :new, :create ]

  def new
    return redirect_to(root_path, notice: "Jesteś już zalogowany.") if user_signed_in?
  end

  def create
    user = User.find_by(email: params[:email].to_s.downcase.strip)

    if user&.authenticate(params[:password].to_s)
      reset_session
      session[:user_id] = user.id
      redirect_to root_path, notice: "Witaj ponownie."
    else
      flash.now[:alert] = "Nieprawidłowy e-mail lub hasło."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to new_session_path, notice: "Zostałeś wylogowany."
  end
end
