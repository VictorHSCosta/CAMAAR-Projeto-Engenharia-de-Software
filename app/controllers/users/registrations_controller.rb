# frozen_string_literal: true

module Users
  # Custom Devise registrations controller for user management
  class RegistrationsController < Devise::RegistrationsController
    before_action :ensure_admin, only: %i[new create]
    before_action :configure_sign_up_params, only: [:create]

    # GET /resource/sign_up
    def new
      build_resource({})
      resource.role = :aluno # Define role padrão
      yield resource if block_given?
      respond_with resource
    end

    # POST /resource
    def create
      build_resource(sign_up_params)
      save_and_respond_to_user
    end

    private

    def save_and_respond_to_user
      resource.save
      yield resource if block_given?
      if resource.persisted?
        handle_successful_registration
      else
        handle_failed_registration
      end
    end

    def handle_successful_registration
      if resource.active_for_authentication?
        handle_active_user
      else
        handle_inactive_user
      end
    end

    def handle_active_user
      set_flash_message! :notice, :signed_up
      sign_up(resource_name, resource)
      respond_with resource, location: after_sign_up_path_for(resource)
    end

    def handle_inactive_user
      set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
      expire_data_after_sign_up!
      respond_with resource, location: after_inactive_sign_up_path_for(resource)
    end

    def handle_failed_registration
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end

    protected

    # Permite cadastro apenas para admins
    def ensure_admin
      return if user_signed_in? && current_user.admin?

      redirect_to root_path, alert: I18n.t('messages.admin_only')
    end

    # Permite parâmetros adicionais para cadastro
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[name matricula role])
    end

    # Permite parâmetros adicionais para atualização
    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: %i[name matricula])
    end

    # Redireciona após cadastro bem-sucedido
    def after_sign_up_path_for(_resource)
      users_path
    end
  end
end
