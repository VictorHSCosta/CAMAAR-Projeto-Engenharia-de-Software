# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let(:professor) { create(:user, :professor) }
  let(:aluno) { create(:user, :aluno) }
  let(:curso) { create(:curso) }
  let(:disciplina) { create(:disciplina, curso: curso) }
  let(:turma) { create(:turma, disciplina: disciplina, professor: professor) }
  let(:template) { create(:template, criado_por: admin, disciplina: disciplina) }
  let(:formulario) { create(:formulario, template: template, turma: turma, coordenador: admin) }

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

      it 'shows all formularios' do
        formulario # create the formulario
        get :index
        expect(assigns(:formularios)).to include(formulario)
      end

      it 'calculates general statistics' do
        get :index
        expect(assigns(:estatisticas_gerais)).to be_present
        expect(assigns(:estatisticas_gerais)).to have_key(:total_formularios)
        expect(assigns(:estatisticas_gerais)).to have_key(:total_respostas)
        expect(assigns(:estatisticas_gerais)).to have_key(:formularios_com_respostas)
        expect(assigns(:estatisticas_gerais)).to have_key(:taxa_participacao)
      end
    end

    context 'when user is professor' do
      before { login_as(professor, scope: :user) }

      it 'returns a successful response' do
        get :index
        expect(response).to be_successful
      end

      it 'shows only formularios from professor disciplines' do
        professor_formulario = create(:formulario, template: template, turma: turma, coordenador: admin)
        other_turma = create(:turma, disciplina: create(:disciplina), professor: create(:user, :professor))
        other_formulario = create(:formulario, template: template, turma: other_turma, coordenador: admin)

        get :index
        expect(assigns(:formularios)).to include(professor_formulario)
        expect(assigns(:formularios)).not_to include(other_formulario)
      end
    end

    context 'when user is aluno' do
      before { login_as(aluno, scope: :user) }

      it 'redirects to root path' do
        get :index
        expect(response).to redirect_to(root_path)
      end

      it 'sets access denied alert' do
        get :index
        expect(flash[:alert]).to eq('Acesso negado. Apenas professores e administradores podem ver relatórios.')
      end
    end
  end

  describe 'GET #show' do
    context 'when user is admin' do
      before { login_as(admin, scope: :user) }

      it 'returns a successful response' do
        get :show, params: { id: formulario.id }
        expect(response).to be_successful
      end

      it 'assigns the formulario' do
        get :show, params: { id: formulario.id }
        expect(assigns(:formulario)).to eq(formulario)
      end

      it 'calculates formulario statistics' do
        get :show, params: { id: formulario.id }
        expect(assigns(:estatisticas)).to be_present
        expect(assigns(:estatisticas)).to have_key(:total_respostas)
        expect(assigns(:estatisticas)).to have_key(:total_perguntas)
        expect(assigns(:estatisticas)).to have_key(:tempo_medio)
      end

      it 'gets formulario responses' do
        pergunta = create(:perguntum, template: template)
        get :show, params: { id: formulario.id }
        expect(assigns(:respostas)).to be_present
      end
    end

    context 'when user is professor with access' do
      before { login_as(professor, scope: :user) }

      it 'returns a successful response' do
        get :show, params: { id: formulario.id }
        expect(response).to be_successful
      end
    end

    context 'when user is professor without access' do
      let(:other_professor) { create(:user, :professor) }
      let(:other_turma) { create(:turma, disciplina: create(:disciplina), professor: other_professor) }
      let(:other_formulario) { create(:formulario, template: template, turma: other_turma, coordenador: admin) }

      before { login_as(other_professor, scope: :user) }

      it 'raises ActiveRecord::RecordNotFound' do
        expect do
          get :show, params: { id: other_formulario.id }
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when user is aluno' do
      before { login_as(aluno, scope: :user) }

      it 'redirects to root path' do
        get :show, params: { id: formulario.id }
        expect(response).to redirect_to(root_path)
      end

      it 'sets access denied alert' do
        get :show, params: { id: formulario.id }
        expect(flash[:alert]).to eq('Acesso negado. Apenas professores e administradores podem ver relatórios.')
      end
    end
  end

  describe 'private methods' do
    let(:controller_instance) { described_class.new }

    before do
      allow(controller_instance).to receive(:current_user).and_return(admin)
      controller_instance.instance_variable_set(:@formularios, [formulario])
    end

    describe '#calcular_estatisticas_gerais' do
      it 'calculates correct statistics' do
        result = controller_instance.send(:calcular_estatisticas_gerais)

        expect(result).to have_key(:total_formularios)
        expect(result).to have_key(:total_respostas)
        expect(result).to have_key(:formularios_com_respostas)
        expect(result).to have_key(:taxa_participacao)

        expect(result[:total_formularios]).to eq(1)
        expect(result[:total_respostas]).to eq(0)
        expect(result[:formularios_com_respostas]).to eq(0)
        expect(result[:taxa_participacao]).to eq(0)
      end

      it 'calculates correct participation rate with responses' do
        create(:submissao_concluida, formulario: formulario, user: aluno)
        controller_instance.instance_variable_set(:@formularios, [formulario])

        result = controller_instance.send(:calcular_estatisticas_gerais)
        expect(result[:formularios_com_respostas]).to eq(1)
        expect(result[:taxa_participacao]).to eq(100.0)
      end
    end

    describe '#calcular_estatisticas_formulario' do
      it 'calculates formulario specific statistics' do
        pergunta = create(:perguntum, template: template)

        result = controller_instance.send(:calcular_estatisticas_formulario, formulario)

        expect(result).to have_key(:total_respostas)
        expect(result).to have_key(:total_perguntas)
        expect(result).to have_key(:tempo_medio)

        expect(result[:total_respostas]).to eq(0)
        expect(result[:total_perguntas]).to eq(1)
        expect(result[:tempo_medio]).to be_nil
      end
    end

    describe '#calcular_tempo_medio_resposta' do
      it 'returns nil for now' do
        result = controller_instance.send(:calcular_tempo_medio_resposta, formulario)
        expect(result).to be_nil
      end
    end
  end
end
