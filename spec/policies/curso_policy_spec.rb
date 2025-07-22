# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CursoPolicy, type: :policy do
  subject { described_class.new(user, curso) }

  let(:curso) { create(:curso) }

  context 'when user is admin' do
    let(:user) { create(:user, :admin) }

    it { is_expected.to permit_actions(%i[index show create update destroy]) }
  end

  context 'when user is coordenador' do
    let(:user) { create(:user, :coordenador) }

    it { is_expected.to permit_actions(%i[index show create update]) }
    it { is_expected.not_to permit_action(:destroy) }
  end

  context 'when user is professor' do
    let(:user) { create(:user, :professor) }

    it { is_expected.to permit_actions(%i[index show]) }
    it { is_expected.not_to permit_actions(%i[create update destroy]) }
  end

  context 'when user is aluno' do
    let(:user) { create(:user, :aluno) }

    it { is_expected.to permit_actions(%i[index show]) }
    it { is_expected.not_to permit_actions(%i[create update destroy]) }
  end

  context 'when user is nil' do
    let(:user) { nil }

    it { is_expected.not_to permit_actions(%i[index show create update destroy]) }
  end

  describe 'Scope' do
    let(:admin) { create(:user, :admin) }
    let(:professor) { create(:user, :professor) }
    let!(:curso1) { create(:curso, nome: 'Curso 1') }
    let!(:curso2) { create(:curso, nome: 'Curso 2') }

    it 'returns all cursos for any user' do
      scope = described_class::Scope.new(admin, Curso.all).resolve
      expect(scope).to include(curso1, curso2)
    end

    it 'returns all cursos for professor' do
      scope = described_class::Scope.new(professor, Curso.all).resolve
      expect(scope).to include(curso1, curso2)
    end
  end
end
