# frozen_string_literal: true

require 'rails_helper'
require 'simplecov'
SimpleCov.start


RSpec.describe EvaluationsController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let(:coordenador) { create(:user, :coordenador) }
  let(:professor) { create(:user, :professor) }
  let(:aluno) { create(:user, :aluno) }
  let(:curso) { create(:curso) }
  let(:disciplina) { create(:disciplina, curso: curso) }
  let(:turma) { create(:turma, disciplina: disciplina, professor: professor) }
  let(:template) { create(:template, criado_por: coordenador, disciplina: disciplina) }
  let(:formulario) { create(:formulario, template: template, turma: turma, coordenador: coordenador) }
  let(:pergunta) { create(:perguntum, template: template, texto: 'Test Question', tipo: 'subjetiva') }

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'GET #index' do
    context 'when user is admin' do
      before { login_as(admin, scope: :user) }

      it 'returns a successful response' do
        get :index
        expect(response).to be_successful
      end

      it 'shows all active formularios' do
        formulario.update!(ativo: true)
        get :index
        expect(assigns(:formularios_disponiveis)).to include(formulario)
      end
    end

    context 'when user is coordenador' do
      before { login_as(coordenador, scope: :user) }

      it 'returns a successful response' do
        get :index
        expect(response).to be_successful
      end

      it 'shows only formularios created by coordenador' do
        formulario.update!(ativo: true)
        other_formulario = create(:formulario, template: template, turma: turma, coordenador: admin)
        other_formulario.update!(ativo: true)
        
        get :index
        expect(assigns(:formularios_disponiveis)).to include(formulario)
        expect(assigns(:formularios_disponiveis)).not_to include(other_formulario)
      end
    end

    context 'when user is aluno' do
      before { login_as(aluno, scope: :user) }

      it 'returns a successful response' do
        get :index
        expect(response).to be_successful
      end
    end
  end

  describe 'GET #show' do
    context 'when user has permission' do
      before do
        login_as(aluno, scope: :user)
        create(:matricula, user: aluno, turma: turma)
      end

      it 'returns a successful response' do
        get :show, params: { id: formulario.id }
        expect(response).to be_successful
      end

      it 'assigns the formulario' do
        get :show, params: { id: formulario.id }
        expect(assigns(:formulario)).to eq(formulario)
      end

      it 'assigns the template' do
        get :show, params: { id: formulario.id }
        expect(assigns(:template)).to eq(template)
      end

      it 'assigns the perguntas' do
        pergunta # create the pergunta
        get :show, params: { id: formulario.id }
        expect(assigns(:perguntas)).to include(pergunta)
      end
    end

    context 'when user already answered' do
      before do
        login_as(aluno, scope: :user)
        create(:matricula, user: aluno, turma: turma)
        create(:submissao_concluida, user: aluno, formulario: formulario)
      end

      it 'redirects to evaluations path' do
        get :show, params: { id: formulario.id }
        expect(response).to redirect_to(evaluations_path)
      end

      it 'sets notice message' do
        get :show, params: { id: formulario.id }
        expect(flash[:notice]).to eq('Você já respondeu este formulário.')
      end
    end

    context 'when user does not have permission' do
      before { login_as(aluno, scope: :user) }

      it 'redirects to evaluations path' do
        get :show, params: { id: formulario.id }
        expect(response).to redirect_to(evaluations_path)
      end

      it 'sets alert message' do
        get :show, params: { id: formulario.id }
        expect(flash[:alert]).to eq('Você não tem permissão para acessar este formulário.')
      end
    end
  end

  describe 'GET #results' do
    context 'when user is admin' do
      before { login_as(admin, scope: :user) }

      it 'returns a successful response' do
        get :results, params: { id: formulario.id }
        expect(response).to be_successful
      end

      it 'assigns the formulario' do
        get :results, params: { id: formulario.id }
        expect(assigns(:formulario)).to eq(formulario)
      end

      it 'assigns the template' do
        get :results, params: { id: formulario.id }
        expect(assigns(:template)).to eq(template)
      end

      it 'calculates statistics' do
        pergunta # create the pergunta
        get :results, params: { id: formulario.id }
        expect(assigns(:estatisticas)).to be_present
      end
    end

    context 'when user is coordenador who created the formulario' do
      before { login_as(coordenador, scope: :user) }

      it 'returns a successful response' do
        get :results, params: { id: formulario.id }
        expect(response).to be_successful
      end
    end

    context 'when user is coordenador who did not create the formulario' do
      let(:other_coordenador) { create(:user, :coordenador) }
      
      before { login_as(other_coordenador, scope: :user) }

      it 'redirects to evaluations path' do
        get :results, params: { id: formulario.id }
        expect(response).to redirect_to(evaluations_path)
      end

      it 'sets access denied alert' do
        get :results, params: { id: formulario.id }
        expect(flash[:alert]).to eq('Acesso negado. Você não tem permissão para ver estes resultados.')
      end
    end

    context 'when user is aluno' do
      before { login_as(aluno, scope: :user) }

      it 'redirects to evaluations path' do
        get :results, params: { id: formulario.id }
        expect(response).to redirect_to(evaluations_path)
      end

      it 'sets access denied alert' do
        get :results, params: { id: formulario.id }
        expect(flash[:alert]).to eq('Acesso negado. Você não tem permissão para ver estes resultados.')
      end
    end
  end

  describe 'POST #show (submitting answers)' do
    let(:opcao) { create(:opcoes_perguntum, pergunta: pergunta) }
    
    before do
      login_as(aluno, scope: :user)
      create(:matricula, user: aluno, turma: turma)
    end

    context 'with valid responses' do
      it 'processes the responses successfully' do
        post :show, params: { 
          id: formulario.id,
          respostas: { pergunta.id.to_s => 'Test answer' }
        }
        expect(response).to redirect_to(evaluations_path)
      end

      it 'creates submissao_concluida' do
        expect {
          post :show, params: { 
            id: formulario.id,
            respostas: { pergunta.id.to_s => 'Test answer' }
          }
        }.to change(SubmissaoConcluida, :count).by(1)
      end

      it 'creates resposta' do
        expect {
          post :show, params: { 
            id: formulario.id,
            respostas: { pergunta.id.to_s => 'Test answer' }
          }
        }.to change(Respostum, :count).by(1)
      end

      it 'sets success notice' do
        post :show, params: { 
          id: formulario.id,
          respostas: { pergunta.id.to_s => 'Test answer' }
        }
        expect(flash[:notice]).to eq('Respostas enviadas com sucesso! Obrigado pela sua participação.')
      end
    end

    context 'with invalid pergunta' do
      let(:invalid_pergunta) { create(:perguntum, template: create(:template, criado_por: admin)) }

      it 'handles error gracefully' do
        post :show, params: { 
          id: formulario.id,
          respostas: { invalid_pergunta.id.to_s => 'Test answer' }
        }
        expect(response).to redirect_to(evaluations_path)
        expect(flash[:alert]).to eq('Erro ao processar respostas. Tente novamente.')
      end
    end
  end
end
