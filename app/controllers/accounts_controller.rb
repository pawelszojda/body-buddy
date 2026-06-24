class AccountsController < ApplicationController
  def show
  end

  def update
    profile_updated = current_user.update(profile_params)
    password_updated = update_password_if_requested

    if profile_updated && password_updated
      redirect_to account_path, notice: "Konto zostało zaktualizowane."
    else
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.destroy
    reset_session
    redirect_to new_session_path, notice: "Twoje konto zostało usunięte."
  end

  private

  def profile_params
    params.require(:user).permit(:username, :email)
  end

  def password_update_requested?
    params[:user][:password].present? || params[:user][:password_confirmation].present?
  end

  def update_password_if_requested
    return true unless password_update_requested?

    unless current_user.authenticate(params[:user][:current_password].to_s)
      current_user.errors.add(:current_password, "jest nieprawidłowe")
      return false
    end

    current_user.update(password_params)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
