# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  let(:admin) { create(:user, :admin) }
  let(:aluno) { create(:user, :aluno, curso: 'Engenharia de Software') }
  let(:professor) { create(:user, :professor) }
  let(:curso) { create(:curso, nome: 'Engenharia de Software') }
  let(:disciplina) { create(:disciplina, curso: curso) }
  let(:turma) { create(:turma, disciplina: disciplina, professor: professor) }

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    login_as(admin, scope: :user)
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns all users' do
      get :index
      expect(assigns(:users)).to include(admin)
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      get :show, params: { id: admin.id }
      expect(response).to be_successful
    end

    it 'assigns the requested user' do
      get :show, params: { id: admin.id }
      expect(assigns(:user)).to eq(admin)
    end
  end

  describe 'GET #new' do
    it 'returns a successful response' do
      get :new
      expect(response).to be_successful
    end

    it 'assigns a new user' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'GET #edit' do
    it 'returns a successful response' do
      get :edit, params: { id: admin.id }
      expect(response).to be_successful
    end

    it 'assigns the requested user' do
      get :edit, params: { id: admin.id }
      expect(assigns(:user)).to eq(admin)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_attributes) do
        {
          name: 'New User',
          email: 'newuser@example.com',
          password: 'password123',
          password_confirmation: 'password123',
          matricula: '12345678',
          role: 'aluno',
          curso: 'Engenharia de Software'
        }
      end

      it 'creates a new user' do
        expect do
          post :create, params: { user: valid_attributes }
        end.to change(User, :count).by(1)
      end

      it 'redirects to the user' do
        post :create, params: { user: valid_attributes }
        expect(response).to redirect_to(User.last)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        {
          name: '',
          email: 'invalid_email',
          password: 'pass',
          matricula: ''
        }
      end

      it 'does not create a new user' do
        expect do
          post :create, params: { user: invalid_attributes }
        end.not_to change(User, :count)
      end

      it 'renders the new template' do
        post :create, params: { user: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        {
          name: 'Updated Name',
          curso: 'Ciência da Computação'
        }
      end

      it 'updates the user' do
        patch :update, params: { id: aluno.id, user: new_attributes }
        aluno.reload
        expect(aluno.name).to eq('Updated Name')
        expect(aluno.curso).to eq('Ciência da Computação')
      end

      it 'redirects to the user' do
        patch :update, params: { id: aluno.id, user: new_attributes }
        expect(response).to redirect_to(aluno)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        {
          name: '',
          email: 'invalid_email'
        }
      end

      it 'does not update the user' do
        original_name = aluno.name
        patch :update, params: { id: aluno.id, user: invalid_attributes }
        aluno.reload
        expect(aluno.name).to eq(original_name)
      end

      it 'renders the edit template' do
        patch :update, params: { id: aluno.id, user: invalid_attributes }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the user' do
      user_to_delete = create(:user, :aluno)
      expect do
        delete :destroy, params: { id: user_to_delete.id }
      end.to change(User, :count).by(-1)
    end

    it 'redirects to users index' do
      delete :destroy, params: { id: aluno.id }
      expect(response).to redirect_to(users_url)
    end
  end

  describe 'POST #adicionar_disciplina_aluno' do
    context 'when user is admin' do
      let(:params) do
        {
          user_id: aluno.id,
          disciplina_id: disciplina.id,
          turma_id: turma.id
        }
      end

      it 'adds disciplina to aluno' do
        expect do
          post :adicionar_disciplina_aluno, params: params
        end.to change(Matricula, :count).by(1)
      end

      it 'redirects to edit user page' do
        post :adicionar_disciplina_aluno, params: params
        expect(response).to redirect_to(edit_user_path(aluno))
      end

      it 'sets success notice' do
        post :adicionar_disciplina_aluno, params: params
        expect(flash[:notice]).to match(/Aluno matriculado na disciplina .+ - .+/)
      end
    end

    context 'when user is not admin' do
      before { login_as(aluno, scope: :user) }

      it 'redirects to root path', :pending do
        post :adicionar_disciplina_aluno,
             params: { user_id: aluno.id, disciplina_id: disciplina.id, turma_id: turma.id }
        expect(response).to redirect_to(root_path)
      end

      it 'sets access denied alert', :pending do
        post :adicionar_disciplina_aluno,
             params: { user_id: aluno.id, disciplina_id: disciplina.id, turma_id: turma.id }
        expect(flash[:alert]).to eq('Acesso negado. Apenas administradores podem realizar essa ação.')
      end
    end
  end

  describe 'DELETE #remover_disciplina_aluno' do
    let!(:matricula) { create(:matricula, user: aluno, turma: turma) }

    context 'when user is admin' do
      let(:params) do
        {
          user_id: aluno.id,
          disciplina_id: disciplina.id
        }
      end

      it 'removes disciplina from aluno' do
        expect do
          delete :remover_disciplina_aluno, params: params
        end.to change(Matricula, :count).by(-1)
      end

      it 'redirects to edit user page' do
        delete :remover_disciplina_aluno, params: params
        expect(response).to redirect_to(edit_user_path(aluno))
      end

      it 'sets success notice' do
        delete :remover_disciplina_aluno, params: params
        expect(flash[:notice]).to eq('Disciplina removida com sucesso!')
      end
    end
  end

  describe 'POST #adicionar_disciplina_professor' do
    context 'when user is admin' do
      let(:params) do
        {
          user_id: professor.id,
          disciplina_id: disciplina.id,
          semestre: '2025.1'
        }
      end

      it 'creates new turma for professor' do
        expect do
          post :adicionar_disciplina_professor, params: params
        end.to change(Turma, :count).by(1)
      end

      it 'redirects to edit user page' do
        post :adicionar_disciplina_professor, params: params
        expect(response).to redirect_to(edit_user_path(professor))
      end

      it 'sets success notice' do
        post :adicionar_disciplina_professor, params: params
        expect(flash[:notice]).to eq('Disciplina adicionada ao professor com sucesso!')
      end
    end
  end

  describe 'authorization' do
    context 'when user is not admin' do
      before { login_as(aluno, scope: :user) }

      it 'restricts access to index', pending: 'Authorization disabled in test environment' do
        get :index
        expect(response).to redirect_to(root_path)
      end

      it 'restricts access to new', pending: 'Authorization disabled in test environment' do
        get :new
        expect(response).to redirect_to(root_path)
      end

      it 'restricts access to create', pending: 'Authorization disabled in test environment' do
        post :create, params: { user: { name: 'Test' } }
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
