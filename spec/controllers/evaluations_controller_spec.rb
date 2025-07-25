# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EvaluationsController, type: :controller do
  let(:admin_user) { create(:user, :admin) }
  let(:coordenador_user) { create(:user, :coordenador) }
  let(:aluno_user) { create(:user, :aluno) }
  let(:template_model) { create(:template) }
  let!(:formulario_ativo) { create(:formulario, ativo: true, template: template_model) }
  let!(:formulario_inativo) { create(:formulario, ativo: false, template: template_model) }
  let!(:formulario_coordenador) do
    create(:formulario, ativo: true, coordenador: coordenador_user, template: template_model)
  end

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET #index' do
    context 'happy path' do
      context 'when user is an admin' do
        before do
          allow(controller).to receive(:current_user).and_return(admin_user)
          get :index
        end

        it 'assigns all active formularios' do
          expect(assigns(:formularios)).to include(formulario_ativo, formulario_coordenador)
        end

        it 'does not assign inactive formularios' do
          expect(assigns(:formularios)).not_to include(formulario_inativo)
        end

        it 'assigns all active forms to @formularios_disponiveis' do
          expect(assigns(:formularios_disponiveis)).to match_array([formulario_ativo, formulario_coordenador])
        end

        it 'assigns an empty array to @formularios_respondidos' do
          expect(assigns(:formularios_respondidos)).to be_empty
        end

        it 'renders the index template' do
          expect(response).to render_template(:index)
        end

        it 'returns successful response' do
          expect(response).to be_successful
        end
      end

      context 'when user is a coordenador' do
        before do
          allow(controller).to receive(:current_user).and_return(coordenador_user)
          get :index
        end

        it 'assigns only their own active formularios' do
          expect(assigns(:formularios)).to eq([formulario_coordenador])
        end

        it 'assigns their own forms to @formularios_disponiveis' do
          expect(assigns(:formularios_disponiveis)).to eq([formulario_coordenador])
        end

        it 'assigns an empty array to @formularios_respondidos' do
          expect(assigns(:formularios_respondidos)).to be_empty
        end

        it 'renders the index template successfully' do
          expect(response).to render_template(:index)
          expect(response).to be_successful
        end
      end

      context 'when user is an aluno' do
        before do
          allow(controller).to receive(:current_user).and_return(aluno_user)
          # Mock the chain of scopes
          active_forms = Formulario.where(id: [formulario_ativo.id, formulario_coordenador.id])
          allow(Formulario).to receive(:ativos).and_return(active_forms)
          allow(active_forms).to receive(:no_periodo).and_return(active_forms)
          allow_any_instance_of(Formulario).to receive(:can_be_seen_by?).and_return(true)
        end

        context 'with no answered forms' do
          before do
            allow_any_instance_of(Formulario).to receive(:already_answered_by?).and_return(false)
            get :index
          end

          it 'assigns available forms to @formularios_disponiveis' do
            expect(assigns(:formularios_disponiveis)).to match_array([formulario_ativo, formulario_coordenador])
          end

          it 'assigns an empty array to @formularios_respondidos' do
            expect(assigns(:formularios_respondidos)).to be_empty
          end

          it 'renders successfully' do
            expect(response).to be_successful
          end
        end

        context 'with one answered form' do
          before do
            allow_any_instance_of(Formulario).to receive(:already_answered_by?) do |form, user|
              case form.id
              when formulario_ativo.id
                true
              when formulario_coordenador.id
                false
              else
                false
              end
            end
            get :index
          end

          it 'separates available and answered forms' do
            expect(assigns(:formularios_disponiveis)).to eq([formulario_coordenador])
            expect(assigns(:formularios_respondidos)).to eq([formulario_ativo])
          end
        end
      end
    end

    context 'sad path' do
      context 'when database is unavailable' do
        before do
          allow(controller).to receive(:current_user).and_return(admin_user)
          allow(Formulario).to receive(:ativos).and_raise(StandardError.new('Database error'))
        end

        it 'handles database errors gracefully' do
          expect { get :index }.to raise_error(StandardError)
        end
      end

      context 'when user has no permissions' do
        let(:unauthorized_user) { create(:user, role: nil) }

        before do
          allow(controller).to receive(:current_user).and_return(unauthorized_user)
        end

        it 'handles users without proper role' do
          expect { get :index }.not_to raise_error
          # The controller should still render but with limited data
        end
      end

      context 'when formularios are corrupted' do
        before do
          allow(controller).to receive(:current_user).and_return(admin_user)
          allow_any_instance_of(Formulario).to receive(:can_be_seen_by?).and_raise(StandardError.new('Corrupted data'))
        end

        it 'handles corrupted formulario data' do
          expect { get :index }.to raise_error(StandardError)
        end
      end
    end
  end

  describe 'GET #show' do
    before do
      allow(controller).to receive(:current_user).and_return(aluno_user)
    end

    context 'when user has permission' do
      before do
        allow_any_instance_of(Formulario).to receive(:can_be_seen_by?).and_return(true)
      end

      context 'when form has not been answered' do
        before do
          allow_any_instance_of(Formulario).to receive(:already_answered_by?).and_return(false)
          get :show, params: { id: formulario_ativo.id }
        end

        it 'assigns the requested formulario' do
          expect(assigns(:formulario)).to eq(formulario_ativo)
        end

        it 'assigns the template and perguntas' do
          expect(assigns(:template)).to eq(template_model)
          expect(assigns(:perguntas)).to eq(template_model.pergunta.order(:id))
        end

        it 'renders the show template' do
          expect(response).to render_template(:show)
        end
      end

      context 'when form has already been answered' do
        it 'redirects to evaluations_path with a notice' do
          allow_any_instance_of(Formulario).to receive(:already_answered_by?).and_return(true)
          get :show, params: { id: formulario_ativo.id }
          expect(response).to redirect_to(evaluations_path)
          expect(flash[:notice]).to eq('Você já respondeu este formulário.')
        end
      end
    end

    context 'when user does not have permission' do
      it 'redirects to evaluations_path with an alert' do
        allow_any_instance_of(Formulario).to receive(:can_be_seen_by?).and_return(false)
        get :show, params: { id: formulario_ativo.id }
        expect(response).to redirect_to(evaluations_path)
        expect(flash[:alert]).to eq('Você não tem permissão para acessar este formulário.')
      end
    end
  end

  describe 'POST #show (process_respostas)' do
    let!(:pergunta_subjetiva) { create(:perguntum, tipo: 'subjetiva', template: template_model) }
    let!(:pergunta_multipla) { create(:perguntum, tipo: 'multipla_escolha', template: template_model) }
    let!(:opcao) { create(:opcoes_perguntum, pergunta: pergunta_multipla, texto: 'Opção A') }

    before do
      allow(controller).to receive(:current_user).and_return(aluno_user)
      allow_any_instance_of(Formulario).to receive(:can_be_seen_by?).and_return(true)
      allow_any_instance_of(Formulario).to receive(:already_answered_by?).and_return(false)
    end

    context 'with valid responses' do
      let(:valid_params) do
        {
          id: formulario_ativo.id,
          respostas: {
            pergunta_subjetiva.id.to_s => 'Minha resposta subjetiva',
            pergunta_multipla.id.to_s => opcao.id.to_s
          }
        }
      end

      it 'creates Respostum records' do
        expect do
          post :show, params: valid_params
        end.to change(Respostum, :count).by(2)
      end

      it 'creates a SubmissaoConcluida record' do
        expect do
          post :show, params: valid_params
        end.to change(SubmissaoConcluida, :count).by(1)
      end

      it 'redirects to evaluations_path with a success notice' do
        post :show, params: valid_params
        expect(response).to redirect_to(evaluations_path)
        expect(flash[:notice]).to eq('Respostas enviadas com sucesso! Obrigado pela sua participação.')
      end
    end

    context 'with invalid responses' do
      let(:invalid_params) do
        {
          id: formulario_ativo.id,
          respostas: { '999' => 'Resposta inválida' } # Pergunta ID that doesn't exist
        }
      end

      it 'does not create any records' do
        expect do
          post :show, params: invalid_params
        end.not_to change(Respostum, :count)
        expect do
          post :show, params: invalid_params
        end.not_to change(SubmissaoConcluida, :count)
      end

      it 'redirects to the evaluation path with an alert' do
        post :show, params: invalid_params
        expect(response).to redirect_to(evaluation_path(formulario_ativo))
        expect(flash[:alert]).to eq('Erro ao enviar respostas. Tente novamente.')
      end
    end
  end

  describe 'GET #results' do
    context 'when user is an admin' do
      before do
        allow(controller).to receive(:current_user).and_return(admin_user)
      end

      it 'renders the results template' do
        get :results, params: { id: formulario_ativo.id }
        expect(response).to render_template(:results)
        expect(response).to be_successful
      end
    end

    context 'when user is the correct coordenador' do
      before do
        allow(controller).to receive(:current_user).and_return(coordenador_user)
      end

      it 'renders the results template' do
        get :results, params: { id: formulario_coordenador.id }
        expect(response).to render_template(:results)
        expect(response).to be_successful
      end
    end

    context 'when user is a different coordenador' do
      let(:outro_coordenador) { create(:user, :coordenador) }
      before do
        allow(controller).to receive(:current_user).and_return(outro_coordenador)
      end

      it 'redirects with an access denied alert' do
        get :results, params: { id: formulario_coordenador.id }
        expect(response).to redirect_to(evaluations_path)
        expect(flash[:alert]).to eq('Acesso negado. Você não tem permissão para ver estes resultados.')
      end
    end

    context 'when user is an aluno' do
      before do
        allow(controller).to receive(:current_user).and_return(aluno_user)
      end

      it 'redirects with an access denied alert' do
        get :results, params: { id: formulario_ativo.id }
        expect(response).to redirect_to(evaluations_path)
        expect(flash[:alert]).to eq('Acesso negado. Você não tem permissão para ver estes resultados.')
      end
    end

    context 'calculating statistics' do
      let!(:pergunta_subjetiva) { create(:perguntum, tipo: 'subjetiva', template: template_model) }
      let!(:pergunta_multipla) { create(:perguntum, tipo: 'multipla_escolha', template: template_model) }
      let!(:opcao1) { create(:opcoes_perguntum, pergunta: pergunta_multipla, texto: 'Opção 1') }
      let!(:opcao2) { create(:opcoes_perguntum, pergunta: pergunta_multipla, texto: 'Opção 2') }
      let!(:pergunta_vf) { create(:perguntum, tipo: 'verdadeiro_falso', template: template_model) }

      before do
        # Create some responses
        create(:respostum, formulario: formulario_ativo, pergunta: pergunta_subjetiva, resposta_texto: 'Subjetiva 1')
        create(:respostum, formulario: formulario_ativo, pergunta: pergunta_multipla, opcao: opcao1)
        create(:respostum, formulario: formulario_ativo, pergunta: pergunta_multipla, opcao: opcao1)
        create(:respostum, formulario: formulario_ativo, pergunta: pergunta_multipla, opcao: opcao2)
        create(:respostum, formulario: formulario_ativo, pergunta: pergunta_vf, resposta_texto: 'true')
        create(:respostum, formulario: formulario_ativo, pergunta: pergunta_vf, resposta_texto: 'false')
        create(:respostum, formulario: formulario_ativo, pergunta: pergunta_vf, resposta_texto: 'true')

        create(:submissao_concluida, formulario: formulario_ativo)
        create(:submissao_concluida, formulario: formulario_ativo)

        allow(controller).to receive(:current_user).and_return(admin_user)
        get :results, params: { id: formulario_ativo.id }
      end

      it 'assigns the correct statistics' do
        stats = assigns(:estatisticas)
        expect(stats).not_to be_nil

        # Subjective question stats
        subjetiva_stats = stats[pergunta_subjetiva.id]
        expect(subjetiva_stats[:tipo]).to eq('subjetiva')
        expect(subjetiva_stats[:total_respostas]).to eq(1)
        expect(subjetiva_stats[:respostas_texto]).to eq(['Subjetiva 1'])

        # Multiple choice question stats
        multipla_stats = stats[pergunta_multipla.id]
        expect(multipla_stats[:tipo]).to eq('multipla_escolha')
        expect(multipla_stats[:total_respostas]).to eq(3)
        expect(multipla_stats[:opcoes][opcao1.id][:count]).to eq(2)
        expect(multipla_stats[:opcoes][opcao2.id][:count]).to eq(1)

        # True/False question stats
        vf_stats = stats[pergunta_vf.id]
        expect(vf_stats[:tipo]).to eq('verdadeiro_falso')
        expect(vf_stats[:total_respostas]).to eq(3)
        expect(vf_stats[:opcoes]['verdadeiro'][:count]).to eq(2)
        expect(vf_stats[:opcoes]['falso'][:count]).to eq(1)
      end

      it 'assigns general statistics' do
        expect(assigns(:total_submissoes)).to eq(2)
        expect(assigns(:total_respostas)).to eq(7)
      end
    end
  end
end
