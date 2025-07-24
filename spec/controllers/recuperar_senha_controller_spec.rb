# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecuperarSenhaController, type: :controller do
  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

    let(:existing_user) { create(:user, email: 'user@example.com', matricula: '12345678') }

  describe 'GET #new' do
    it 'returns a successful response' do
      get :new
      expect(response).to be_successful
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with missing parameters' do
      it 'handles missing matricula' do
        post :create, params: {
          email: user.email,
          password: 'newpassword123',
          password_confirmation: 'newpassword123'
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash.now[:alert]).to eq('Por favor, preencha todos os campos obrigatórios.')
      end

      it 'handles missing email' do
        post :create, params: {
          matricula: user.matricula,
          password: 'newpassword123',
          password_confirmation: 'newpassword123'
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash.now[:alert]).to eq('Por favor, preencha todos os campos obrigatórios.')
      end

      it 'handles missing password' do
        post :create, params: {
          matricula: user.matricula,
          email: user.email,
          password_confirmation: 'newpassword123'
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash.now[:alert]).to eq('Por favor, informe a nova senha e sua confirmação.')
      end

      it 'handles missing password confirmation' do
        post :create, params: {
          matricula: user.matricula,
          email: user.email,
          password: 'newpassword123'
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash.now[:alert]).to eq('Por favor, informe a nova senha e sua confirmação.')
      end
    end

    context 'with password validation errors' do
      it 'handles password mismatch' do
        post :create, params: {
          matricula: user.matricula,
          email: user.email,
          password: 'newpassword123',
          password_confirmation: 'differentpassword'
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash.now[:alert]).to eq('As senhas não coincidem.')
      end

      it 'handles password too short' do
        post :create, params: {
          matricula: user.matricula,
          email: user.email,
          password: '123',
          password_confirmation: '123'
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash.now[:alert]).to eq('A senha deve ter pelo menos 6 caracteres.')
      end
    end

    context 'with user not found' do
      it 'handles invalid matricula' do
        post :create, params: {
          matricula: 'invalid_matricula',
          email: user.email,
          password: 'newpassword123',
          password_confirmation: 'newpassword123'
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash.now[:alert]).to eq('Usuário não encontrado. Verifique sua matrícula e email.')
      end

      it 'handles invalid email' do
        post :create, params: {
          matricula: user.matricula,
          email: 'invalid@email.com',
          password: 'newpassword123',
          password_confirmation: 'newpassword123'
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash.now[:alert]).to eq('Usuário não encontrado. Verifique sua matrícula e email.')
      end
    end

    context 'with valid parameters' do
      it 'successfully resets the password' do
        post :create, params: {
          matricula: user.matricula,
          email: user.email,
          password: 'newpassword123',
          password_confirmation: 'newpassword123'
        }

        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:notice]).to eq('Senha redefinida com sucesso! Agora você pode fazer login.')
      end

      it 'updates the user password' do
        post :create, params: {
          matricula: user.matricula,
          email: user.email,
          password: 'newpassword123',
          password_confirmation: 'newpassword123'
        }

        user.reload
        expect(user.valid_password?('newpassword123')).to be true
      end

      it 'invalidates old password' do
        post :create, params: {
          matricula: user.matricula,
          email: user.email,
          password: 'newpassword123',
          password_confirmation: 'newpassword123'
        }

        user.reload
        expect(user.valid_password?('oldpassword123')).to be false
      end
    end

    context 'when password update fails' do
      before do
        allow_any_instance_of(User).to receive(:update).and_return(false)
      end

      it 'handles password update failure' do
        post :create, params: {
          matricula: user.matricula,
          email: user.email,
          password: 'newpassword123',
          password_confirmation: 'newpassword123'
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash.now[:alert]).to eq('Erro ao redefinir senha. Tente novamente.')
      end
    end

    context 'parameter sanitization' do
      it 'strips whitespace from matricula and email' do
        post :create, params: {
          matricula: "  #{user.matricula}  ",
          email: "  #{user.email.upcase}  ",
          password: 'newpassword123',
          password_confirmation: 'newpassword123'
        }

        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:notice]).to eq('Senha redefinida com sucesso! Agora você pode fazer login.')
      end
    end

    context 'case insensitive email matching' do
      it 'finds user with different case email' do
        post :create, params: {
          matricula: user.matricula,
          email: user.email.upcase,
          password: 'newpassword123',
          password_confirmation: 'newpassword123'
        }

        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:notice]).to eq('Senha redefinida com sucesso! Agora você pode fazer login.')
      end
    end
  end
end
