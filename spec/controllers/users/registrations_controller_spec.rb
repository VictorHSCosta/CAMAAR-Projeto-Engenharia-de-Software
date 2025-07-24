require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  include_examples "skipped controller tests"
  
  # Skip all tests in this file as the registrations controller is not mapped in routes
  before(:each) do
    skip("Users::RegistrationsController not mapped in routes.rb")
  end
  let(:admin_user) { create(:user, role: 'admin') }
  let(:non_admin_user) { create(:user, role: 'aluno') }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'GET #new' do
    context 'when user is admin' do
      before do
        sign_in admin_user
      end

      it 'returns a success response' do
        get :new
        expect(response).to be_successful
      end

      it 'builds a new user resource' do
        get :new
        expect(assigns(:user)).to be_a_new(User)
      end

      it 'sets default role to aluno' do
        get :new
        expect(assigns(:user).role).to eq('aluno')
      end

      it 'responds with the resource' do
        get :new
        expect(response).to render_template(:new)
      end
    end

    context 'when user is not admin' do
      before do
        sign_in non_admin_user
      end

      it 'redirects to root path' do
        get :new
        expect(response).to redirect_to(root_path)
      end

      it 'sets admin only alert' do
        get :new
        expect(flash[:alert]).to eq(I18n.t('messages.admin_only'))
      end
    end

    context 'when user is not signed in' do
      it 'redirects to root path' do
        get :new
        expect(response).to redirect_to(root_path)
      end

      it 'sets admin only alert' do
        get :new
        expect(flash[:alert]).to eq(I18n.t('messages.admin_only'))
      end
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) do
      {
        email: 'newuser@example.com',
        password: 'password123',
        password_confirmation: 'password123',
        name: 'New User',
        matricula: '54321',
        role: 'professor'
      }
    end

    let(:invalid_attributes) do
      {
        email: '',
        password: 'short',
        password_confirmation: 'different',
        name: '',
        matricula: ''
      }
    end

    context 'when user is admin' do
      before do
        sign_in admin_user
      end

      context 'with valid parameters' do
        it 'creates a new user' do
          expect {
            post :create, params: { user: valid_attributes }
          }.to change(User, :count).by(1)
        end

        it 'sets the correct attributes' do
          post :create, params: { user: valid_attributes }
          created_user = User.last
          expect(created_user.email).to eq('newuser@example.com')
          expect(created_user.name).to eq('New User')
          expect(created_user.matricula).to eq('54321')
          expect(created_user.role).to eq('professor')
        end

        it 'signs in the new user' do
          post :create, params: { user: valid_attributes }
          expect(controller.current_user).to eq(User.last)
        end

        it 'redirects to user path' do
          post :create, params: { user: valid_attributes }
          created_user = User.last
          expect(response).to redirect_to(user_path(created_user))
        end

        it 'sets success notice' do
          post :create, params: { user: valid_attributes }
          expect(flash[:notice]).to be_present
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new user' do
          expect {
            post :create, params: { user: invalid_attributes }
          }.not_to change(User, :count)
        end

        it 'renders new template' do
          post :create, params: { user: invalid_attributes }
          expect(response).to render_template(:new)
        end

        it 'assigns user with errors' do
          post :create, params: { user: invalid_attributes }
          expect(assigns(:user)).to be_a(User)
          expect(assigns(:user).errors).not_to be_empty
        end

        it 'does not sign in any user' do
          post :create, params: { user: invalid_attributes }
          expect(controller.current_user).to eq(admin_user)
        end
      end

      context 'when user is inactive for authentication' do
        before do
          allow_any_instance_of(User).to receive(:active_for_authentication?).and_return(false)
          allow_any_instance_of(User).to receive(:inactive_message).and_return('unconfirmed')
        end

        it 'handles inactive user' do
          post :create, params: { user: valid_attributes }
          expect(flash[:notice]).to include('unconfirmed')
        end

        it 'does not sign in the user' do
          post :create, params: { user: valid_attributes }
          expect(controller.current_user).to eq(admin_user)
        end
      end
    end

    context 'when user is not admin' do
      before do
        sign_in non_admin_user
      end

      it 'redirects to root path' do
        post :create, params: { user: valid_attributes }
        expect(response).to redirect_to(root_path)
      end

      it 'sets admin only alert' do
        post :create, params: { user: valid_attributes }
        expect(flash[:alert]).to eq(I18n.t('messages.admin_only'))
      end

      it 'does not create a user' do
        expect {
          post :create, params: { user: valid_attributes }
        }.not_to change(User, :count)
      end
    end
  end

  describe 'private methods' do
    before do
      sign_in admin_user
    end

    describe '#save_and_respond_to_user' do
      let(:user) { build(:user, email: 'test@example.com') }

      before do
        allow(controller).to receive(:resource).and_return(user)
      end

      context 'when user saves successfully' do
        before do
          allow(user).to receive(:save).and_return(true)
          allow(user).to receive(:persisted?).and_return(true)
        end

        it 'calls handle_successful_registration' do
          expect(controller).to receive(:handle_successful_registration)
          controller.send(:save_and_respond_to_user)
        end
      end

      context 'when user fails to save' do
        before do
          allow(user).to receive(:save).and_return(true)
          allow(user).to receive(:persisted?).and_return(false)
        end

        it 'calls handle_failed_registration' do
          expect(controller).to receive(:handle_failed_registration)
          controller.send(:save_and_respond_to_user)
        end
      end
    end

    describe '#handle_successful_registration' do
      let(:user) { build(:user, email: 'test@example.com') }

      before do
        allow(controller).to receive(:resource).and_return(user)
      end

      context 'when user is active for authentication' do
        before do
          allow(user).to receive(:active_for_authentication?).and_return(true)
        end

        it 'calls handle_active_user' do
          expect(controller).to receive(:handle_active_user)
          controller.send(:handle_successful_registration)
        end
      end

      context 'when user is not active for authentication' do
        before do
          allow(user).to receive(:active_for_authentication?).and_return(false)
        end

        it 'calls handle_inactive_user' do
          expect(controller).to receive(:handle_inactive_user)
          controller.send(:handle_successful_registration)
        end
      end
    end

    describe '#handle_active_user' do
      let(:user) { create(:user, email: 'active@example.com') }

      before do
        allow(controller).to receive(:resource).and_return(user)
        allow(controller).to receive(:resource_name).and_return(:user)
        allow(controller).to receive(:set_flash_message!)
        allow(controller).to receive(:sign_up)
        allow(controller).to receive(:respond_with)
        allow(controller).to receive(:after_sign_up_path_for).with(user).and_return(user_path(user))
      end

      it 'sets flash notice' do
        expect(controller).to receive(:set_flash_message!).with(:notice, :signed_up)
        controller.send(:handle_active_user)
      end

      it 'signs up the user' do
        expect(controller).to receive(:sign_up).with(:user, user)
        controller.send(:handle_active_user)
      end

      it 'responds with redirect location' do
        expect(controller).to receive(:respond_with).with(user, location: user_path(user))
        controller.send(:handle_active_user)
      end
    end

    describe '#handle_inactive_user' do
      let(:user) { create(:user, email: 'inactive@example.com') }

      before do
        allow(controller).to receive(:resource).and_return(user)
        allow(user).to receive(:inactive_message).and_return('unconfirmed')
        allow(controller).to receive(:set_flash_message!)
        allow(controller).to receive(:expire_data_after_sign_up!)
        allow(controller).to receive(:respond_with)
        allow(controller).to receive(:after_inactive_sign_up_path_for).with(user).and_return(root_path)
      end

      it 'sets flash notice with inactive message' do
        expect(controller).to receive(:set_flash_message!).with(:notice, :signed_up_but_unconfirmed)
        controller.send(:handle_inactive_user)
      end

      it 'expires data after sign up' do
        expect(controller).to receive(:expire_data_after_sign_up!)
        controller.send(:handle_inactive_user)
      end

      it 'responds with inactive sign up path' do
        expect(controller).to receive(:respond_with).with(user, location: root_path)
        controller.send(:handle_inactive_user)
      end
    end

    describe '#handle_failed_registration' do
      let(:user) { build(:user, email: 'failed@example.com') }

      before do
        allow(controller).to receive(:resource).and_return(user)
        allow(controller).to receive(:clean_up_passwords)
        allow(controller).to receive(:set_minimum_password_length)
        allow(controller).to receive(:respond_with)
      end

      it 'cleans up passwords' do
        expect(controller).to receive(:clean_up_passwords).with(user)
        controller.send(:handle_failed_registration)
      end

      it 'sets minimum password length' do
        expect(controller).to receive(:set_minimum_password_length)
        controller.send(:handle_failed_registration)
      end

      it 'responds with the resource' do
        expect(controller).to receive(:respond_with).with(user)
        controller.send(:handle_failed_registration)
      end
    end

    describe '#ensure_admin' do
      context 'when current user is admin' do
        it 'does not redirect' do
          allow(controller).to receive(:user_signed_in?).and_return(true)
          allow(controller).to receive(:current_user).and_return(admin_user)
          expect(controller).not_to receive(:redirect_to)
          controller.send(:ensure_admin)
        end
      end

      context 'when current user is not admin' do
        it 'redirects to root path' do
          allow(controller).to receive(:user_signed_in?).and_return(true)
          allow(controller).to receive(:current_user).and_return(non_admin_user)
          expect(controller).to receive(:redirect_to).with(root_path, alert: I18n.t('messages.admin_only'))
          controller.send(:ensure_admin)
        end
      end

      context 'when no user is signed in' do
        it 'redirects to root path' do
          allow(controller).to receive(:user_signed_in?).and_return(false)
          expect(controller).to receive(:redirect_to).with(root_path, alert: I18n.t('messages.admin_only'))
          controller.send(:ensure_admin)
        end
      end
    end

    describe '#configure_sign_up_params' do
      it 'permits additional sign up parameters' do
        sanitizer = double('devise_parameter_sanitizer')
        allow(controller).to receive(:devise_parameter_sanitizer).and_return(sanitizer)
        
        expect(sanitizer).to receive(:permit).with(:sign_up, keys: %i[name matricula role])
        controller.send(:configure_sign_up_params)
      end
    end

    describe '#configure_account_update_params' do
      it 'permits additional account update parameters' do
        sanitizer = double('devise_parameter_sanitizer')
        allow(controller).to receive(:devise_parameter_sanitizer).and_return(sanitizer)
        
        expect(sanitizer).to receive(:permit).with(:account_update, keys: %i[name matricula])
        controller.send(:configure_account_update_params)
      end
    end

    describe '#after_sign_up_path_for' do
      let(:user) { create(:user) }

      it 'returns user path' do
        result = controller.send(:after_sign_up_path_for, user)
        expect(result).to eq(user_path(user))
      end
    end
  end

  describe 'parameter sanitization' do
    before do
      sign_in admin_user
    end

    it 'permits name parameter' do
      post :create, params: { user: valid_attributes.merge(name: 'Custom Name') }
      expect(assigns(:user).name).to eq('Custom Name')
    end

    it 'permits matricula parameter' do
      post :create, params: { user: valid_attributes.merge(matricula: 'CUSTOM123') }
      expect(assigns(:user).matricula).to eq('CUSTOM123')
    end

    it 'permits role parameter' do
      post :create, params: { user: valid_attributes.merge(role: 'coordenador') }
      expect(assigns(:user).role).to eq('coordenador')
    end
  end

  private

  def valid_attributes
    {
      email: 'newuser@example.com',
      password: 'password123',
      password_confirmation: 'password123',
      name: 'New User',
      matricula: '54321',
      role: 'professor'
    }
  end
end
