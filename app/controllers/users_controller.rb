class UsersController < ApplicationController
  skip_before_action :require_authentication, only: [ :new, :create ]

  def new
    return redirect_to(root_path, notice: "Jesteś już zalogowany.") if user_signed_in?

    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      reset_session
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Konto zostało utworzone."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
