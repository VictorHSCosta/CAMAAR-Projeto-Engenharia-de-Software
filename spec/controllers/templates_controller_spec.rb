require 'rails_helper'

RSpec.describe TemplatesController, type: :controller do
  let(:admin_user) { create(:user, role: :admin) }
  let(:professor_user) { create(:user, role: :professor) }
  let(:aluno_user) { create(:user, role: :aluno) }
  let(:disciplina) { create(:disciplina) }
  let(:template) { create(:template, criado_por: admin_user, disciplina: disciplina) }

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

      it 'assigns all templates' do
        template
        get :index
        expect(assigns(:templates)).to include(template)
      end
    end

    describe 'GET #show' do
      it 'returns a success response' do
        get :show, params: { id: template.to_param }
        expect(response).to be_successful
      end

      it 'assigns the requested template' do
        get :show, params: { id: template.to_param }
        expect(assigns(:template)).to eq(template)
      end
    end

    describe 'GET #new' do
      it 'returns a success response' do
        get :new
        expect(response).to be_successful
      end

      it 'assigns a new template' do
        get :new
        expect(assigns(:template)).to be_a_new(Template)
      end
    end

    describe 'GET #edit' do
      it 'returns a success response' do
        get :edit, params: { id: template.to_param }
        expect(response).to be_successful
      end
    end

    describe 'POST #create' do
      let(:valid_attributes) do
        {
          titulo: 'Template Teste',
          descricao: 'Descrição do template',
          publico_alvo: 'alunos',
          disciplina_id: disciplina.id,
          criado_por_id: admin_user.id
        }
      end

      context 'with valid parameters' do
        it 'creates a new Template' do
          expect {
            post :create, params: { template: valid_attributes }
          }.to change(Template, :count).by(1)
        end

        it 'redirects to the created template' do
          post :create, params: { template: valid_attributes }
          expect(response).to redirect_to(Template.last)
        end

        it 'sets criado_por to current_user' do
          post :create, params: { template: valid_attributes }
          expect(Template.last.criado_por).to eq(admin_user)
        end
      end

      context 'with invalid parameters' do
        let(:invalid_attributes) { { titulo: '' } }

        it 'does not create a new Template' do
          expect {
            post :create, params: { template: invalid_attributes }
          }.to change(Template, :count).by(0)
        end

        it 'renders the new template' do
          post :create, params: { template: invalid_attributes }
          expect(response).to render_template('new')
        end

        it 'has unprocessable_entity status' do
          post :create, params: { template: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid parameters' do
        let(:new_attributes) { { titulo: 'Updated Template' } }

        it 'updates the requested template' do
          put :update, params: { id: template.to_param, template: new_attributes }
          template.reload
          expect(template.titulo).to eq('Updated Template')
        end

        it 'redirects to the template' do
          put :update, params: { id: template.to_param, template: new_attributes }
          expect(response).to redirect_to(template)
        end
      end

      context 'with invalid parameters' do
        it 'renders the edit template' do
          put :update, params: { id: template.to_param, template: { titulo: '' } }
          expect(response).to render_template('edit')
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested template' do
        template
        expect {
          delete :destroy, params: { id: template.to_param }
        }.to change(Template, :count).by(-1)
      end

      it 'redirects to the templates list' do
        delete :destroy, params: { id: template.to_param }
        expect(response).to redirect_to(templates_url)
      end
    end
  end

  describe 'when user is professor' do
    before do
      allow(controller).to receive(:current_user).and_return(professor_user)
    end

    describe 'GET #index' do
      it 'returns a success response' do
        get :index
        expect(response).to be_successful
      end
    end

    describe 'GET #new' do
      it 'returns a success response' do
        get :new
        expect(response).to be_successful
      end
    end

    describe 'POST #create' do
      let(:valid_attributes) do
        {
          titulo: 'Template Professor',
          descricao: 'Descrição do template',
          publico_alvo: 'alunos',
          disciplina_id: disciplina.id,
          criado_por_id: professor_user.id
        }
      end

      context 'with valid parameters' do
        it 'creates a new Template' do
          expect {
            post :create, params: { template: valid_attributes }
          }.to change(Template, :count).by(1)
        end

        it 'sets criado_por to current_user' do
          post :create, params: { template: valid_attributes }
          expect(Template.last.criado_por).to eq(professor_user)
        end
      end
    end
  end

  describe 'when user is aluno' do
    before do
      allow(controller).to receive(:current_user).and_return(aluno_user)
    end

    describe 'GET #index' do
      it 'returns success' do
        get :index
        expect(response).to be_successful
      end
    end
  end
end
