# frozen_string_literal: true

module Admin
  # Adicione um comentário de documentação para a classe Admin::UsersController.
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_admin

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      @user.password = generate_temp_password if @user.password.blank?

      if @user.save
        redirect_to users_path, notice: "Usuário criado com sucesso! Senha temporária: #{@user.password}"
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.expect(user: %i[email name matricula role password password_confirmation])
    end

    def ensure_admin
      redirect_to root_path, alert: I18n.t('messages.access_denied') unless current_user.admin?
    end

    def generate_temp_password
      SecureRandom.hex(4) # Gera senha temporária de 8 caracteres
    end
  end
end
