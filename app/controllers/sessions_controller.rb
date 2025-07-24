# frozen_string_literal: true

# SessionsController for custom authentication logic
class SessionsController < Devise::SessionsController
  # Desativa o layout padrão para esta página específica
  layout false, only: [:new]

  def new
    super
  end

  def create
    # Handle missing parameters
    if params[:user].blank? || params[:user][:email].blank? || params[:user][:password].blank?
      flash.now[:alert] = 'Por favor, preencha email e senha.'
      render :new, status: :unprocessable_entity
      return
    end

    super
  end

  def destroy
    super
  end

  protected

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
  end
end
