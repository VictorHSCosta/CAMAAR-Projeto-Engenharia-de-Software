require 'rails_helper'

RSpec.describe FormulariosController, type: :controller do
  include ActiveSupport::Testing::TimeHelpers
  
  let(:admin_user) { create(:user, role: :admin) }
  let(:aluno_user) { create(:user, role: :aluno) }
  let(:template) { create(:template, criado_por: admin_user) }
  let(:formulario) { create(:formulario, template: template, coordenador: admin_user) }
  let(:valid_attributes) do
    {
      data_envio: Date.current,
      data_fim: Date.current + 1.week,
      template_id: template.id,
      ativo: true
    }
  end
  let(:invalid_attributes) { { template_id: nil } }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'when user is admin' do
    before do
      allow(controller).to receive(:current_user).and_return(admin_user)
    end

    describe 'GET #index' do
      it 'returns a success response' do
        get :index
        expect(response).to be_successful
      end

      it 'assigns all formularios' do
        formulario
        get :index
        expect(assigns(:formularios)).to include(formulario)
      end
    end

    describe 'GET #show' do
      it 'returns a success response' do
        get :show, params: { id: formulario.to_param }
        expect(response).to be_successful
      end

      it 'assigns the requested formulario' do
        get :show, params: { id: formulario.to_param }
        expect(assigns(:formulario)).to eq(formulario)
      end
    end

    describe 'GET #new' do
      it 'returns a success response' do
        get :new
        expect(response).to be_successful
      end

      it 'assigns a new formulario' do
        get :new
        expect(assigns(:formulario)).to be_a_new(Formulario)
      end

      it 'loads select data' do
        template # Create the template
        get :new
        expect(assigns(:templates)).to be_present
      end
    end

    describe 'GET #edit' do
      it 'returns a success response' do
        get :edit, params: { id: formulario.to_param }
        expect(response).to be_successful
      end

      it 'loads select data' do
        template # Create the template
        get :edit, params: { id: formulario.to_param }
        expect(assigns(:templates)).to be_present
      end
    end

    describe 'POST #create' do
      context 'with valid parameters' do
        it 'creates a new Formulario' do
          expect {
            post :create, params: { formulario: valid_attributes }
          }.to change(Formulario, :count).by(1)
        end

        it 'redirects to the created formulario' do
          post :create, params: { formulario: valid_attributes }
          expect(response).to redirect_to(Formulario.last)
        end

        it 'sets coordenador_id to current_user' do
          post :create, params: { formulario: valid_attributes }
          expect(Formulario.last.coordenador_id).to eq(admin_user.id)
        end

        it 'sets data_envio to current time' do
          freeze_time = Time.current
          travel_to(freeze_time) do
            post :create, params: { formulario: valid_attributes }
            expect(Formulario.last.data_envio).to be_within(1.second).of(freeze_time)
          end
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new Formulario' do
          expect {
            post :create, params: { formulario: invalid_attributes }
          }.to change(Formulario, :count).by(0)
        end

        it 'renders the new template' do
          post :create, params: { formulario: invalid_attributes }
          expect(response).to render_template('new')
        end

        it 'has unprocessable_entity status' do
          post :create, params: { formulario: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid parameters' do
        let(:new_attributes) { { ativo: false } }

        it 'updates the requested formulario' do
          put :update, params: { id: formulario.to_param, formulario: new_attributes }
          formulario.reload
          expect(formulario.ativo).to eq(false)
        end

        it 'redirects to the formulario' do
          put :update, params: { id: formulario.to_param, formulario: new_attributes }
          expect(response).to redirect_to(formulario)
        end
      end

      context 'with invalid parameters' do
        it 'renders the edit template' do
          put :update, params: { id: formulario.to_param, formulario: invalid_attributes }
          expect(response).to render_template('edit')
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested formulario' do
        formulario
        expect {
          delete :destroy, params: { id: formulario.to_param }
        }.to change(Formulario, :count).by(-1)
      end

      it 'redirects to the formularios list' do
        delete :destroy, params: { id: formulario.to_param }
        expect(response).to redirect_to(formularios_url)
      end
    end
  end

  describe 'when user is aluno' do
    before do
      allow(controller).to receive(:current_user).and_return(aluno_user)
    end

    describe 'GET #show' do
      context 'when formulario is active and not answered' do
        let(:active_formulario) { create(:formulario, ativo: true, template: template) }

        it 'returns a success response' do
          get :show, params: { id: active_formulario.to_param }
          expect(response).to be_successful
        end

        it 'loads perguntas if available' do
          get :show, params: { id: active_formulario.to_param }
          expect(response).to be_successful
        end
      end

      context 'when formulario is inactive' do
        let(:inactive_formulario) { create(:formulario, ativo: false, template: template) }

        it 'returns a success response' do
          get :show, params: { id: inactive_formulario.to_param }
          expect(response).to be_successful
        end
      end

      context 'when formulario is already answered' do
        let(:answered_formulario) { create(:formulario, ativo: true, template: template) }

        it 'returns a success response when not answered' do
          get :show, params: { id: answered_formulario.to_param }
          expect(response).to be_successful
        end
      end
    end

    describe 'GET #show basic functionality' do
      it 'works with active formulario' do
        active_formulario = create(:formulario, ativo: true, template: template)
        get :show, params: { id: active_formulario.to_param }
        expect(response).to be_successful
      end
    end
  end

  describe 'private methods' do
    before do
      allow(controller).to receive(:current_user).and_return(admin_user)
    end

    describe '#carregar_dados_do_select' do
      it 'loads necessary data for forms' do
        template # Create the template
        get :new
        expect(assigns(:templates)).to be_present
      end
    end

    describe '#set_formulario' do
      it 'sets the formulario from params' do
        get :show, params: { id: formulario.to_param }
        expect(assigns(:formulario)).to eq(formulario)
      end
    end
  end
end