# frozen_string_literal: true

require 'rails_helper'
require 'simplecov'
SimpleCov.start

RSpec.describe MinhasDisciplinasController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let(:professor) { create(:user, :professor) }
  let(:aluno) { create(:user, :aluno) }
  let(:curso) { create(:curso) }
  let(:disciplina) { create(:disciplina, curso: curso) }
  let(:turma) { create(:turma, disciplina: disciplina, professor: professor) }

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'GET #index' do
    context 'when user is aluno' do
      before do
        login_as(aluno, scope: :user)
        create(:matricula, user: aluno, turma: turma)
      end

      it 'returns a successful response' do
        get :index
        expect(response).to be_successful
      end

      it 'shows disciplinas the aluno is enrolled in' do
        get :index
        expect(assigns(:disciplinas)).to include(disciplina)
      end

      it 'sets correct page title and user type' do
        get :index
        expect(assigns(:page_title)).to eq('Minhas Disciplinas - Aluno')
        expect(assigns(:user_type)).to eq('aluno')
      end
    end

    context 'when user is professor' do
      before { login_as(professor, scope: :user) }

      it 'returns a successful response' do
        get :index
        expect(response).to be_successful
      end

      it 'shows disciplinas the professor teaches' do
        get :index
        expect(assigns(:disciplinas)).to include(disciplina)
      end

      it 'sets correct page title and user type' do
        get :index
        expect(assigns(:page_title)).to eq('Minhas Disciplinas - Professor')
        expect(assigns(:user_type)).to eq('professor')
      end
    end

    context 'when user is admin' do
      before { login_as(admin, scope: :user) }

      it 'returns a successful response' do
        get :index
        expect(response).to be_successful
      end

      it 'shows all disciplinas' do
        get :index
        expect(assigns(:disciplinas)).to include(disciplina)
      end

      it 'sets correct page title and user type' do
        get :index
        expect(assigns(:page_title)).to eq('Todas as Disciplinas - Administrador')
        expect(assigns(:user_type)).to eq('admin')
      end
    end

    context 'when user has invalid role' do
      let(:coordenador) { create(:user, :coordenador) }

      before { login_as(coordenador, scope: :user) }

      it 'redirects to root path' do
        get :index
        expect(response).to redirect_to(root_path)
      end

      it 'sets access denied alert' do
        get :index
        expect(flash[:alert]).to eq('Acesso negado.')
      end
    end
  end

  describe 'GET #show' do
    context 'when user is aluno with access' do
      before do
        login_as(aluno, scope: :user)
        create(:matricula, user: aluno, turma: turma)
      end

      it 'returns a successful response' do
        get :show, params: { id: disciplina.id }
        expect(response).to be_successful
      end

      it 'assigns the disciplina' do
        get :show, params: { id: disciplina.id }
        expect(assigns(:disciplina)).to eq(disciplina)
      end

      it 'assigns turmas the aluno is enrolled in' do
        get :show, params: { id: disciplina.id }
        expect(assigns(:turmas)).to include(turma)
      end
    end

    context 'when user is aluno without access' do
      before { login_as(aluno, scope: :user) }

      it 'redirects to minhas disciplinas path' do
        get :show, params: { id: disciplina.id }
        expect(response).to redirect_to(minhas_disciplinas_path)
      end

      it 'sets access denied alert' do
        get :show, params: { id: disciplina.id }
        expect(flash[:alert]).to eq('Você não tem acesso a esta disciplina.')
      end
    end

    context 'when user is professor with access' do
      before { login_as(professor, scope: :user) }

      it 'returns a successful response' do
        get :show, params: { id: disciplina.id }
        expect(response).to be_successful
      end

      it 'assigns turmas the professor teaches' do
        get :show, params: { id: disciplina.id }
        expect(assigns(:turmas)).to include(turma)
      end
    end

    context 'when user is professor without access' do
      let(:other_professor) { create(:user, :professor) }

      before { login_as(other_professor, scope: :user) }

      it 'redirects to minhas disciplinas path' do
        get :show, params: { id: disciplina.id }
        expect(response).to redirect_to(minhas_disciplinas_path)
      end

      it 'sets access denied alert' do
        get :show, params: { id: disciplina.id }
        expect(flash[:alert]).to eq('Você não leciona esta disciplina.')
      end
    end

    context 'when user is admin' do
      before { login_as(admin, scope: :user) }

      it 'returns a successful response' do
        get :show, params: { id: disciplina.id }
        expect(response).to be_successful
      end

      it 'assigns all turmas for the disciplina' do
        get :show, params: { id: disciplina.id }
        expect(assigns(:turmas)).to include(turma)
      end
    end
  end

  describe 'GET #gerenciar' do
    context 'when user is admin' do
      before { login_as(admin, scope: :user) }

      it 'returns a successful response' do
        get :gerenciar
        expect(response).to be_successful
      end

      it 'assigns necessary data for management' do
        get :gerenciar
        expect(assigns(:disciplinas)).to be_present
        expect(assigns(:cursos)).to be_present
        expect(assigns(:professores)).to be_present
        expect(assigns(:alunos)).to be_present
        expect(assigns(:disciplina)).to be_a_new(Disciplina)
        expect(assigns(:turma)).to be_a_new(Turma)
      end
    end

    context 'when user is not admin' do
      before { login_as(aluno, scope: :user) }

      it 'redirects to root path' do
        get :gerenciar
        expect(response).to redirect_to(root_path)
      end

      it 'sets access denied alert' do
        get :gerenciar
        expect(flash[:alert]).to eq('Acesso negado.')
      end
    end
  end

  describe 'POST #cadastrar_professor_disciplina' do
    context 'when user is admin' do
      before { login_as(admin, scope: :user) }

      it 'creates a new turma for the professor' do
        expect do
          post :cadastrar_professor_disciplina, params: {
            disciplina_id: disciplina.id,
            professor_id: professor.id,
            semestre: '2024.1'
          }
        end.to change(Turma, :count).by(1)
      end

      it 'redirects to gerenciar disciplinas path' do
        post :cadastrar_professor_disciplina, params: {
          disciplina_id: disciplina.id,
          professor_id: professor.id,
          semestre: '2024.1'
        }
        expect(response).to redirect_to(gerenciar_disciplinas_path)
      end

      it 'sets success notice' do
        post :cadastrar_professor_disciplina, params: {
          disciplina_id: disciplina.id,
          professor_id: professor.id,
          semestre: '2024.1'
        }
        expect(flash[:notice]).to include('cadastrado na disciplina')
      end

      it 'prevents duplicate professor-disciplina-semestre combination' do
        create(:turma, disciplina: disciplina, professor: professor, semestre: '2024.1')

        post :cadastrar_professor_disciplina, params: {
          disciplina_id: disciplina.id,
          professor_id: professor.id,
          semestre: '2024.1'
        }

        expect(response).to redirect_to(gerenciar_disciplinas_path)
        expect(flash[:alert]).to eq('Este professor já leciona esta disciplina neste semestre.')
      end
    end

    context 'when user is not admin' do
      before { login_as(aluno, scope: :user) }

      it 'redirects to root path' do
        post :cadastrar_professor_disciplina, params: {
          disciplina_id: disciplina.id,
          professor_id: professor.id,
          semestre: '2024.1'
        }
        expect(response).to redirect_to(root_path)
      end

      it 'sets access denied alert' do
        post :cadastrar_professor_disciplina, params: {
          disciplina_id: disciplina.id,
          professor_id: professor.id,
          semestre: '2024.1'
        }
        expect(flash[:alert]).to eq('Acesso negado.')
      end
    end
  end

  describe 'POST #cadastrar_aluno_disciplina' do
    context 'when user is admin' do
      before { login_as(admin, scope: :user) }

      it 'creates a new matricula for the aluno' do
        expect do
          post :cadastrar_aluno_disciplina, params: {
            aluno_id: aluno.id,
            turma_id: turma.id
          }
        end.to change(Matricula, :count).by(1)
      end

      it 'redirects to gerenciar disciplinas path' do
        post :cadastrar_aluno_disciplina, params: {
          aluno_id: aluno.id,
          turma_id: turma.id
        }
        expect(response).to redirect_to(gerenciar_disciplinas_path)
      end

      it 'sets success notice' do
        post :cadastrar_aluno_disciplina, params: {
          aluno_id: aluno.id,
          turma_id: turma.id
        }
        expect(flash[:notice]).to include('matriculado na turma')
      end

      it 'prevents duplicate matricula' do
        create(:matricula, user: aluno, turma: turma)

        post :cadastrar_aluno_disciplina, params: {
          aluno_id: aluno.id,
          turma_id: turma.id
        }

        expect(response).to redirect_to(gerenciar_disciplinas_path)
        expect(flash[:alert]).to eq('Este aluno já está matriculado nesta turma.')
      end
    end

    context 'when user is not admin' do
      before { login_as(aluno, scope: :user) }

      it 'redirects to root path' do
        post :cadastrar_aluno_disciplina, params: {
          aluno_id: aluno.id,
          turma_id: turma.id
        }
        expect(response).to redirect_to(root_path)
      end

      it 'sets access denied alert' do
        post :cadastrar_aluno_disciplina, params: {
          aluno_id: aluno.id,
          turma_id: turma.id
        }
        expect(flash[:alert]).to eq('Acesso negado.')
      end
    end
  end
end
