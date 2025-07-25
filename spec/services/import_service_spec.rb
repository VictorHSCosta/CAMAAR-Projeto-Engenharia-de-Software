require 'rails_helper'

RSpec.describe ImportService, type: :service do
  before { 
    User.destroy_all
    Disciplina.destroy_all
    Curso.destroy_all
  }

  describe '.import_users' do
    context 'happy path' do
      context 'with valid user data array' do
        let(:user_data) do
          [
            {
              'nome' => 'João Silva',
              'email' => 'joao@example.com',
              'matricula' => '12345',
              'ocupacao' => 'dicente',
              'curso' => 'Ciência da Computação',
              'departamento' => 'CIC',
              'formacao' => 'Graduação'
            },
            {
              'nome' => 'Maria Santos',
              'email' => 'maria@example.com',
              'usuario' => '67890',
              'ocupacao' => 'docente',
              'curso' => 'Engenharia de Computação',
              'departamento' => 'ENE'
            }
          ]
        end

        it 'imports users successfully' do
          result = ImportService.import_users(user_data)

          expect(result).to include(
            success: true,
            imported: 2,
            skipped: 0
          )

          expect(User.count).to eq(2)
          
          joao = User.find_by(email: 'joao@example.com')
          expect(joao.name).to eq('João Silva')
          expect(joao.matricula).to eq('12345')
          expect(joao.role).to eq('aluno')
          expect(joao.curso).to eq('Ciência da Computação')
          
          maria = User.find_by(email: 'maria@example.com')
          expect(maria.name).to eq('Maria Santos')
          expect(maria.matricula).to eq('67890')
          expect(maria.role).to eq('professor')
        end

        it 'sets default password for imported users' do
          ImportService.import_users(user_data)
          
          user = User.find_by(email: 'joao@example.com')
          expect(user.valid_password?('123456')).to be true
        end

        it 'handles single user data object' do
          single_user_data = user_data.first
          result = ImportService.import_users(single_user_data)

          expect(result).to include(
            success: true,
            imported: 1,
            skipped: 0
          )

          expect(User.count).to eq(1)
        end

        it 'correctly determines roles from ocupacao' do
          user_data_with_roles = [
            { 'nome' => 'Admin', 'email' => 'admin@test.com', 'matricula' => '001', 'ocupacao' => 'coordenador' },
            { 'nome' => 'Prof', 'email' => 'prof@test.com', 'matricula' => '002', 'ocupacao' => 'docente' },
            { 'nome' => 'Student', 'email' => 'student@test.com', 'matricula' => '003', 'ocupacao' => 'graduando' },
            { 'nome' => 'Unknown', 'email' => 'unknown@test.com', 'matricula' => '004', 'ocupacao' => 'other' }
          ]

          ImportService.import_users(user_data_with_roles)

          expect(User.find_by(email: 'admin@test.com').role).to eq('coordenador')
          expect(User.find_by(email: 'prof@test.com').role).to eq('professor')
          expect(User.find_by(email: 'student@test.com').role).to eq('aluno')
          expect(User.find_by(email: 'unknown@test.com').role).to eq('aluno') # default
        end
      end

      context 'with class_members.json format' do
        let(:class_members_data) do
          [
            {
              'dicente' => [
                {
                  'nome' => 'Aluno 1',
                  'email' => 'aluno1@example.com',
                  'matricula' => '111',
                  'ocupacao' => 'dicente'
                },
                {
                  'nome' => 'Aluno 2',
                  'email' => 'aluno2@example.com',
                  'matricula' => '222',
                  'ocupacao' => 'dicente'
                }
              ],
              'docente' => {
                'nome' => 'Professor 1',
                'email' => 'prof1@example.com',
                'matricula' => '333',
                'ocupacao' => 'docente'
              }
            }
          ]
        end

        it 'imports both students and teacher' do
          result = ImportService.import_users(class_members_data)

          expect(result).to include(
            success: true,
            imported: 3,
            skipped: 0
          )

          expect(User.where(role: 'aluno').count).to eq(2)
          expect(User.where(role: 'professor').count).to eq(1)
        end

        it 'handles class members with only dicente array' do
          data_only_students = [{
            'dicente' => [
              { 'nome' => 'Student A', 'email' => 'a@test.com', 'matricula' => '001', 'ocupacao' => 'dicente' }
            ]
          }]

          result = ImportService.import_users(data_only_students)

          expect(result).to include(success: true, imported: 1, skipped: 0)
          expect(User.count).to eq(1)
        end

        it 'handles class members with only docente hash' do
          data_only_teacher = [{
            'docente' => { 'nome' => 'Teacher A', 'email' => 'teacher@test.com', 'matricula' => '001', 'ocupacao' => 'docente' }
          }]

          result = ImportService.import_users(data_only_teacher)

          expect(result).to include(success: true, imported: 1, skipped: 0)
          expect(User.count).to eq(1)
        end
      end

      context 'with existing users' do
        before do
          create(:user, email: 'existing@example.com', name: 'Existing User', matricula: '99999')
        end

        it 'skips existing users and imports new ones' do
          user_data = [
            { 'nome' => 'Existing User', 'email' => 'existing@example.com', 'matricula' => '99999' },
            { 'nome' => 'New User', 'email' => 'new@example.com', 'matricula' => '11111' }
          ]

          result = ImportService.import_users(user_data)

          expect(result).to include(
            success: true,
            imported: 1,
            skipped: 1
          )

          expect(User.count).to eq(2) # 1 existing + 1 new
        end
      end
    end

    context 'sad path' do
      context 'with invalid user data' do
        it 'handles users with blank email' do
          user_data = [
            { 'nome' => 'Valid User', 'email' => 'valid@test.com', 'matricula' => '123' },
            { 'nome' => 'Invalid User', 'email' => '', 'matricula' => '456' },
            { 'nome' => 'Nil Email User', 'email' => nil, 'matricula' => '789' }
          ]

          result = ImportService.import_users(user_data)

          expect(result).to include(success: true, imported: 1, skipped: 0)
          expect(User.count).to eq(1)
          expect(User.first.email).to eq('valid@test.com')
        end

        it 'handles user validation errors' do
          user_data = [
            { 'nome' => '', 'email' => 'test@invalid.com', 'matricula' => '' }, # Invalid: blank name and matricula
            { 'nome' => 'Valid User', 'email' => 'valid@test.com', 'matricula' => '123' }
          ]

          result = ImportService.import_users(user_data)

          expect(result[:success]).to be false
          expect(result[:error]).to include('Erro ao importar')
          expect(User.count).to eq(1) # Valid user still saved
        end

        it 'handles invalid email format' do
          user_data = [
            { 'nome' => 'User', 'email' => 'invalid-email', 'matricula' => '123' }
          ]

          result = ImportService.import_users(user_data)

          expect(result[:success]).to be false
          expect(result[:error]).to include('Erro ao importar')
        end

        it 'handles duplicate matricula within same import' do
          user_data = [
            { 'nome' => 'User 1', 'email' => 'user1@test.com', 'matricula' => '123' },
            { 'nome' => 'User 2', 'email' => 'user2@test.com', 'matricula' => '123' } # Duplicate matricula
          ]

          result = ImportService.import_users(user_data)

          expect(result[:success]).to be false
          expect(result[:error]).to include('Erro ao importar')
        end
      end

      context 'with database errors' do
        it 'handles database transaction failures' do
          allow(ActiveRecord::Base).to receive(:transaction).and_raise(StandardError.new('Database error'))

          user_data = [{ 'nome' => 'Test', 'email' => 'test@example.com', 'matricula' => '123' }]
          result = ImportService.import_users(user_data)

          expect(result).to include(
            success: false,
            error: 'Database error'
          )
        end

        it 'handles user save failures' do
          user_data = [{ 'nome' => 'Test', 'email' => 'test@example.com', 'matricula' => '123' }]
          
          allow_any_instance_of(User).to receive(:save).and_return(false)
          allow_any_instance_of(User).to receive(:errors).and_return(double(full_messages: ['Save failed']))

          result = ImportService.import_users(user_data)

          expect(result[:success]).to be false
          expect(result[:error]).to include('Save failed')
        end
      end

      context 'with malformed data structures' do
        it 'handles empty arrays' do
          result = ImportService.import_users([])

          expect(result).to include(success: true, imported: 0, skipped: 0)
        end

        it 'handles nil data' do
          result = ImportService.import_users(nil)

          expect(result[:success]).to be false
          expect(result[:error]).to include("undefined method")
        end

        it 'handles malformed class_members structure' do
          malformed_data = [{
            'dicente' => 'not an array',
            'docente' => ['not a hash']
          }]

          result = ImportService.import_users(malformed_data)

          expect(result).to include(success: true, imported: 0, skipped: 0)
        end
      end
    end
  end

  describe '.import_disciplines' do
    context 'happy path' do
      context 'with valid discipline data' do
        let(:discipline_data) do
          [
            {
              'code' => 'CIC0097',
              'name' => 'Engenharia de Software',
              'class' => {
                'classCode' => 'T01',
                'semester' => '2024.1',
                'time' => '08:00-10:00'
              }
            },
            {
              'code' => 'ENE0105',
              'name' => 'Algoritmos e Estruturas de Dados'
            }
          ]
        end

        it 'imports disciplines successfully' do
          result = ImportService.import_disciplines(discipline_data)

          expect(result).to include(
            success: true,
            imported: 2,
            skipped: 0
          )

          expect(Disciplina.count).to eq(2)
          
          eng_software = Disciplina.find_by(codigo: 'CIC0097')
          expect(eng_software.nome).to eq('Engenharia de Software')
          expect(eng_software.codigo_turma).to eq('T01')
          expect(eng_software.semestre).to eq('2024.1')
          expect(eng_software.horario).to eq('08:00-10:00')
          
          algoritmos = Disciplina.find_by(codigo: 'ENE0105')
          expect(algoritmos.nome).to eq('Algoritmos e Estruturas de Dados')
        end

        it 'handles single discipline data object' do
          single_discipline = discipline_data.first
          result = ImportService.import_disciplines([single_discipline])

          expect(result).to include(
            success: true,
            imported: 1,
            skipped: 0
          )

          expect(Disciplina.count).to eq(1)
        end

        it 'correctly extracts course from code' do
          discipline_data_with_codes = [
            { 'code' => 'CIC0001', 'name' => 'Disciplina CIC' },
            { 'code' => 'ENC0002', 'name' => 'Disciplina ENC' },
            { 'code' => 'FTD0003', 'name' => 'Disciplina FTD' },
            { 'code' => 'XYZ0004', 'name' => 'Disciplina Unknown' }
          ]

          ImportService.import_disciplines(discipline_data_with_codes)

          expect(Disciplina.find_by(codigo: 'CIC0001').curso.nome).to eq('Ciência da Computação')
          expect(Disciplina.find_by(codigo: 'ENC0002').curso.nome).to eq('Engenharia de Computação')
          expect(Disciplina.find_by(codigo: 'FTD0003').curso.nome).to eq('Engenharia Mecatrônica')
          expect(Disciplina.find_by(codigo: 'XYZ0004').curso.nome).to eq('Curso Geral')
        end
      end

      context 'with existing disciplines' do
        before do
          curso = create(:curso, nome: 'Ciência da Computação')
          create(:disciplina, codigo: 'CIC0097', nome: 'Existing Discipline', curso: curso)
        end

        it 'skips existing disciplines and imports new ones' do
          discipline_data = [
            { 'code' => 'CIC0097', 'name' => 'Existing Discipline' },
            { 'code' => 'CIC0098', 'name' => 'New Discipline' }
          ]

          result = ImportService.import_disciplines(discipline_data)

          expect(result).to include(
            success: true,
            imported: 1,
            skipped: 1
          )

          expect(Disciplina.count).to eq(2) # 1 existing + 1 new
        end
      end
    end

    context 'sad path' do
      context 'with invalid discipline data' do
        it 'handles disciplines with blank code' do
          discipline_data = [
            { 'code' => 'CIC0001', 'name' => 'Valid Discipline' },
            { 'code' => '', 'name' => 'Invalid Discipline' },
            { 'code' => nil, 'name' => 'Nil Code Discipline' }
          ]

          result = ImportService.import_disciplines(discipline_data)

          expect(result).to include(success: true, imported: 1, skipped: 0)
          expect(Disciplina.count).to eq(1)
          expect(Disciplina.first.codigo).to eq('CIC0001')
        end

        it 'handles discipline validation errors' do
          discipline_data = [
            { 'code' => 'CIC0001', 'name' => 'Valid Discipline' }
          ]
          
          # Mock disciplina to fail validation
          allow_any_instance_of(Disciplina).to receive(:save).and_return(false)
          allow_any_instance_of(Disciplina).to receive(:errors).and_return(double(full_messages: ['Save failed']))

          result = ImportService.import_disciplines(discipline_data)

          expect(result[:success]).to be false
          expect(result[:error]).to include('Erro ao importar')
        end

        it 'handles duplicate codigo within same import' do
          discipline_data = [
            { 'code' => 'CIC0001', 'name' => 'Discipline 1' },
            { 'code' => 'CIC0001', 'name' => 'Discipline 1' } # Same name = existing check skips
          ]

          result = ImportService.import_disciplines(discipline_data)

          expect(result[:success]).to be true
          expect(result[:imported]).to eq(1)
          expect(result[:skipped]).to eq(1)
        end
      end

      context 'with database errors' do
        it 'handles database transaction failures' do
          allow(ActiveRecord::Base).to receive(:transaction).and_raise(StandardError.new('Database error'))

          discipline_data = [{ 'code' => 'CIC0001', 'name' => 'Test' }]
          result = ImportService.import_disciplines(discipline_data)

          expect(result).to include(
            success: false,
            error: 'Database error'
          )
        end

        it 'handles discipline save failures' do
          discipline_data = [{ 'code' => 'CIC0001', 'name' => 'Test' }]
          
          allow_any_instance_of(Disciplina).to receive(:save).and_return(false)
          allow_any_instance_of(Disciplina).to receive(:errors).and_return(double(full_messages: ['Save failed']))

          result = ImportService.import_disciplines(discipline_data)

          expect(result[:success]).to be false
          expect(result[:error]).to include('Save failed')
        end
      end

      context 'with malformed data structures' do
        it 'handles empty arrays' do
          result = ImportService.import_disciplines([])

          expect(result).to include(success: true, imported: 0, skipped: 0)
        end

        it 'handles nil data' do
          result = ImportService.import_disciplines(nil)

          expect(result).to include(success: true, imported: 0, skipped: 0)
        end
      end
    end
  end

  describe 'helper methods' do
    describe '.determine_role' do
      context 'happy path' do
        it 'returns coordenador for coordenador occupation' do
          expect(ImportService.send(:determine_role, 'coordenador')).to eq('coordenador')
        end

        it 'returns professor for docente occupation' do
          expect(ImportService.send(:determine_role, 'docente')).to eq('professor')
        end

        it 'returns aluno for student occupations' do
          %w[dicente graduando mestrando doutorando].each do |occupation|
            expect(ImportService.send(:determine_role, occupation)).to eq('aluno')
          end
        end

        it 'returns aluno for unknown occupations' do
          expect(ImportService.send(:determine_role, 'unknown')).to eq('aluno')
          expect(ImportService.send(:determine_role, 'other')).to eq('aluno')
        end
      end

      context 'sad path' do
        it 'handles nil occupation' do
          expect(ImportService.send(:determine_role, nil)).to eq('aluno')
        end

        it 'handles blank occupation' do
          expect(ImportService.send(:determine_role, '')).to eq('aluno')
        end

        it 'handles case sensitivity' do
          expect(ImportService.send(:determine_role, 'COORDENADOR')).to eq('coordenador') # case insensitive
          expect(ImportService.send(:determine_role, 'Docente')).to eq('professor') # case insensitive
        end
      end
    end

    describe '.extract_course_from_code' do
      context 'happy path' do
        it 'returns correct course for CIC codes' do
          expect(ImportService.send(:extract_course_from_code, 'CIC0001')).to eq('Ciência da Computação')
          expect(ImportService.send(:extract_course_from_code, 'CIC123')).to eq('Ciência da Computação')
        end

        it 'returns correct course for ENC codes' do
          expect(ImportService.send(:extract_course_from_code, 'ENC0001')).to eq('Engenharia de Computação')
          expect(ImportService.send(:extract_course_from_code, 'ENC999')).to eq('Engenharia de Computação')
        end

        it 'returns correct course for FTD codes' do
          expect(ImportService.send(:extract_course_from_code, 'FTD0001')).to eq('Engenharia Mecatrônica')
          expect(ImportService.send(:extract_course_from_code, 'FTD123')).to eq('Engenharia Mecatrônica')
        end

        it 'returns Curso Geral for unknown codes' do
          expect(ImportService.send(:extract_course_from_code, 'XYZ0001')).to eq('Curso Geral')
          expect(ImportService.send(:extract_course_from_code, 'ABC123')).to eq('Curso Geral')
        end
      end

      context 'sad path' do
        it 'handles nil code' do
          expect(ImportService.send(:extract_course_from_code, nil)).to eq('Curso Geral')
        end

        it 'handles blank code' do
          expect(ImportService.send(:extract_course_from_code, '')).to eq('Curso Geral')
        end

        it 'handles codes without known prefixes' do
          expect(ImportService.send(:extract_course_from_code, '123456')).to eq('Curso Geral')
          expect(ImportService.send(:extract_course_from_code, 'UNKNOWN')).to eq('Curso Geral')
        end

        it 'handles lowercase codes (case insensitive)' do
          expect(ImportService.send(:extract_course_from_code, 'cic0001')).to eq('Ciência da Computação')
          expect(ImportService.send(:extract_course_from_code, 'enc0001')).to eq('Engenharia de Computação')
        end
      end
    end
  end
end