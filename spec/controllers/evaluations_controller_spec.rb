# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EvaluationsController, type: :controller do
  let(:user_admin) { create(:user, role: 'admin') }
  let(:user_coordenador) { create(:user, role: 'coordenador') }
  let(:user_aluno) { create(:user, role: 'aluno') }
  let(:curso) { create(:curso) }
  let(:disciplina) { create(:disciplina, curso: curso) }
  let(:template) { create(:template, criado_por: user_coordenador, disciplina: disciplina) }
  let(:formulario) { create(:formulario, template: template, coordenador: user_coordenador, ativo: true) }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET #index' do
    context 'como admin' do
      before do
        allow(controller).to receive(:current_user).and_return(user_admin)
      end

      it 'retorna sucesso' do
        get :index
        expect(response).to have_http_status(:success)
      end

      it 'exibe todos os formulários ativos para administrador' do
        get :index
        expect(assigns(:formularios)).to include(formulario)
        expect(assigns(:formularios_disponiveis)).to include(formulario)
        expect(assigns(:formularios_respondidos)).to be_empty
      end
    end

    context 'como coordenador' do
      before do
        allow(controller).to receive(:current_user).and_return(user_coordenador)
      end

      it 'retorna sucesso' do
        get :index
        expect(response).to have_http_status(:success)
      end

      it 'exibe formulários criados pelo coordenador' do
        get :index
        expect(assigns(:formularios)).to include(formulario)
        expect(assigns(:formularios_disponiveis)).to include(formulario)
        expect(assigns(:formularios_respondidos)).to be_empty
      end
    end

    context 'como aluno' do
      before do
        allow(controller).to receive(:current_user).and_return(user_aluno)
      end

      it 'retorna sucesso' do
        get :index
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'GET #show' do
    before do
      allow(controller).to receive(:current_user).and_return(user_aluno)
    end

    context 'quando o usuário pode ver o formulário' do
      before do
        allow(formulario).to receive(:can_be_seen_by?).with(user_aluno).and_return(true)
        allow(formulario).to receive(:already_answered_by?).with(user_aluno).and_return(false)
      end

      it 'exibe o formulário com sucesso' do
        get :show, params: { id: formulario.id }
        expect(response).to have_http_status(:success)
        expect(assigns(:formulario)).to eq(formulario)
        expect(assigns(:template)).to eq(template)
      end
    end

    context 'quando o usuário não pode ver o formulário' do
      before do
        allow(formulario).to receive(:can_be_seen_by?).with(user_aluno).and_return(false)
      end

      it 'redireciona com mensagem de erro' do
        get :show, params: { id: formulario.id }
        expect(response).to redirect_to(evaluations_path)
        expect(flash[:alert]).to eq('Você não tem permissão para acessar este formulário.')
      end
    end
  end

  describe 'GET #results' do
    context 'como admin' do
      before do
        allow(controller).to receive(:current_user).and_return(user_admin)
      end

      it 'exibe resultados do formulário' do
        get :results, params: { id: formulario.id }
        expect(response).to have_http_status(:success)
        expect(assigns(:formulario)).to eq(formulario)
        expect(assigns(:template)).to eq(template)
      end
    end

    context 'como aluno' do
      before do
        allow(controller).to receive(:current_user).and_return(user_aluno)
      end

      it 'nega acesso aos resultados' do
        get :results, params: { id: formulario.id }
        expect(response).to redirect_to(evaluations_path)
        expect(flash[:alert]).to eq('Acesso negado. Você não tem permissão para ver estes resultados.')
      end
    end
  end
end
