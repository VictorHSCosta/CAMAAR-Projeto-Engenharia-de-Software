require 'rails_helper'
require 'simplecov'
SimpleCov.start

RSpec.describe 'User Management System Integration' do
  describe 'User model functionality' do
    context 'happy path' do
      it 'creates different types of users' do
        admin = create(:user, :admin)
        aluno = create(:user, :aluno)
        professor = create(:user, :professor)

        expect(admin.admin?).to be true
        expect(aluno.aluno?).to be true
        expect(professor.professor?).to be true
      end

      it 'manages user course assignment' do
        user = create(:user, :aluno, curso: 'Engenharia de Software')
        expect(user.curso).to eq('Engenharia de Software')
      end

      it 'creates users with all required attributes' do
        user = create(:user, name: 'Test User', email: 'test@example.com', matricula: '12345', role: 'admin')
        expect(user).to be_valid
        expect(user).to be_persisted
      end

      it 'handles different user roles correctly' do
        %w[admin aluno professor coordenador].each do |role|
          user = create(:user, role: role)
          expect(user.role).to eq(role)
          expect(user).to be_valid
        end
      end
    end

    context 'sad path' do
      it 'validates user data' do
        user = build(:user, name: nil)
        expect(user).not_to be_valid
        expect(user.errors[:name]).to include("can't be blank")
      end

      it 'prevents duplicate matriculas' do
        create(:user, matricula: '12345')
        duplicate_user = build(:user, matricula: '12345')
        expect(duplicate_user).not_to be_valid
        expect(duplicate_user.errors[:matricula]).to include('has already been taken')
      end

      it 'validates required fields' do
        invalid_user = build(:user, name: '', email: '', matricula: '', role: nil)
        expect(invalid_user).not_to be_valid
        expect(invalid_user.errors.attribute_names).to include(:name, :email, :matricula, :role)
      end

      it 'handles invalid email formats' do
        user = build(:user, email: 'invalid_email')
        expect(user).not_to be_valid
        expect(user.errors[:email]).to be_present
      end
    end
  end

  describe 'Discipline associations' do
    let(:curso) { create(:curso) }
    let(:disciplina) { create(:disciplina, curso: curso) }
    let(:professor) { create(:user, :professor) }
    let(:aluno) { create(:user, :aluno) }

    context 'happy path' do
      it 'associates professor with disciplines' do
        create(:turma, disciplina: disciplina, professor: professor)

        expect(professor.disciplinas_como_professor).to include(disciplina)
        expect(professor.disciplinas.count).to eq(1)
      end

      it 'associates student with disciplines through matriculas' do
        turma = create(:turma, disciplina: disciplina, professor: professor)
        create(:matricula, user: aluno, turma: turma)

        expect(aluno.disciplinas_como_aluno).to include(disciplina)
        expect(aluno.matriculas.count).to eq(1)
      end

      it 'allows multiple discipline associations' do
        disciplina2 = create(:disciplina, curso: curso, nome: 'Disciplina 2')
        turma1 = create(:turma, disciplina: disciplina, professor: professor)
        turma2 = create(:turma, disciplina: disciplina2, professor: professor)
        
        create(:matricula, user: aluno, turma: turma1)
        create(:matricula, user: aluno, turma: turma2)

        expect(aluno.disciplinas_como_aluno.count).to eq(2)
      end

      it 'maintains referential integrity' do
        turma = create(:turma, disciplina: disciplina, professor: professor)
        matricula = create(:matricula, user: aluno, turma: turma)

        expect(matricula.disciplina).to eq(disciplina)
        expect(turma.professor).to eq(professor)
      end
    end

    context 'sad path' do
      it 'prevents duplicate matriculas for same student and turma' do
        turma = create(:turma, disciplina: disciplina, professor: professor)
        create(:matricula, user: aluno, turma: turma)
        
        duplicate_matricula = build(:matricula, user: aluno, turma: turma)
        expect(duplicate_matricula).not_to be_valid
      end

      it 'handles missing associations gracefully' do
        matricula = build(:matricula, user: nil, turma: nil)
        expect(matricula).not_to be_valid
        expect(matricula.errors[:user]).to include('must exist')
        expect(matricula.errors[:turma]).to include('must exist')
      end

      it 'validates turma-professor relationship' do
        turma_without_professor = build(:turma, disciplina: disciplina, professor: nil)
        expect(turma_without_professor).not_to be_valid
      end

      it 'handles deleted dependencies correctly' do
        turma = create(:turma, disciplina: disciplina, professor: professor)
        matricula = create(:matricula, user: aluno, turma: turma)
        
        expect { professor.destroy }.to change { Turma.count }.by(-1)
        expect { matricula.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'Authorization system' do
    it 'allows only admins to register new users' do
      admin = create(:user, :admin)
      aluno = create(:user, :aluno)

      expect(User.can_register?(admin)).to be true
      expect(User.can_register?(aluno)).to be false
      expect(User.can_register?(nil)).to be false
    end
  end
end
