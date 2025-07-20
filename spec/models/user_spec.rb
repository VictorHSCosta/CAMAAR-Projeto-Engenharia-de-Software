# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build(:user) }

    it 'is valid with valid attributes' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'validates presence of name' do
      user = build(:user, name: nil)
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end

    it 'validates presence of matricula' do
      user = build(:user, matricula: nil)
      expect(user).not_to be_valid
      expect(user.errors[:matricula]).to include("can't be blank")
    end

    it 'validates uniqueness of matricula' do
      create(:user, matricula: '12345')
      user = build(:user, matricula: '12345')
      expect(user).not_to be_valid
      expect(user.errors[:matricula]).to include('has already been taken')
    end

    it 'validates presence of role' do
      user = build(:user, role: nil)
      expect(user).not_to be_valid
    end

    it 'validates length of curso' do
      user = build(:user, curso: 'a' * 256)
      expect(user).not_to be_valid
      expect(user.errors[:curso]).to include('is too long (maximum is 255 characters)')
    end

    it 'allows blank curso' do
      user = build(:user, curso: '')
      expect(user).to be_valid
    end
  end

  describe 'enums' do
    it 'defines correct roles' do
      expect(described_class.roles).to eq({ 'admin' => 0, 'aluno' => 1, 'professor' => 2, 'coordenador' => 3 })
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:templates).dependent(:destroy) }
    it { is_expected.to have_many(:formularios).dependent(:destroy) }
    it { is_expected.to have_many(:turmas).dependent(:destroy) }
    it { is_expected.to have_many(:matriculas).dependent(:destroy) }

    # Associações específicas para professores
    it { is_expected.to have_many(:turmas_como_professor).dependent(:destroy) }
    it { is_expected.to have_many(:disciplinas_como_professor) }

    # Associações específicas para alunos
    it { is_expected.to have_many(:turmas_matriculadas) }
    it { is_expected.to have_many(:disciplinas_como_aluno) }
  end

  describe 'callbacks' do
    it 'downcases email before save' do
      user = build(:user, email: 'TEST@EXAMPLE.COM')
      user.save
      expect(user.email).to eq('test@example.com')
    end
  end

  describe '.can_register?' do
    context 'when current user is admin' do
      let(:admin) { create(:user, :admin) }

      it 'returns true' do
        expect(described_class.can_register?(admin)).to be true
      end
    end

    context 'when current user is not admin' do
      let(:aluno) { create(:user, :aluno) }

      it 'returns false' do
        expect(described_class.can_register?(aluno)).to be false
      end
    end

    context 'when no current user' do
      it 'returns false' do
        expect(described_class.can_register?(nil)).to be false
      end
    end
  end

  describe '#disciplinas' do
    let(:curso) { create(:curso) }
    let(:disciplina1) { create(:disciplina, curso: curso) }
    let(:disciplina2) { create(:disciplina, curso: curso) }

    context 'when user is admin' do
      let(:admin) { create(:user, :admin) }

      it 'returns all disciplinas' do
        disciplina1
        disciplina2
        expect(admin.disciplinas).to include(disciplina1, disciplina2)
      end
    end

    context 'when user is professor' do
      let(:professor) { create(:user, :professor) }
      let!(:turma) { create(:turma, disciplina: disciplina1, professor: professor) }

      it 'returns only disciplinas they teach' do
        expect(professor.disciplinas).to include(disciplina1)
        expect(professor.disciplinas).not_to include(disciplina2)
      end
    end

    context 'when user is aluno' do
      let(:aluno) { create(:user, :aluno) }
      let(:professor) { create(:user, :professor) }
      let!(:turma) { create(:turma, disciplina: disciplina1, professor: professor) }
      let!(:matricula) { create(:matricula, user: aluno, turma: turma) }

      it 'returns only disciplinas they are enrolled in' do
        expect(aluno.disciplinas).to include(disciplina1)
        expect(aluno.disciplinas).not_to include(disciplina2)
      end
    end
  end

  describe 'role methods' do
    it 'correctly identifies admin role' do
      admin = create(:user, :admin)
      expect(admin.admin?).to be true
      expect(admin.aluno?).to be false
    end

    it 'correctly identifies aluno role' do
      aluno = create(:user, :aluno)
      expect(aluno.aluno?).to be true
      expect(aluno.admin?).to be false
    end

    it 'correctly identifies professor role' do
      professor = create(:user, :professor)
      expect(professor.professor?).to be true
      expect(professor.admin?).to be false
    end
  end
end
