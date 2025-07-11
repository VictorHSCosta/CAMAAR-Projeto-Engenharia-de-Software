# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'formularios/index', type: :view do
  let(:user) do
    User.create!(name: 'Test User', email: 'test@example.com', password: 'password', matricula: '12345', role: 'admin')
  end
  let(:curso) { Curso.create!(nome: 'Test Course') }
  let(:disciplina) { Disciplina.create!(nome: 'Test Discipline', curso: curso) }
  let(:professor) do
    User.create!(name: 'Professor', email: 'professor@example.com', password: 'password', matricula: '67890',
                 role: 'professor')
  end
  let(:turma) { Turma.create!(disciplina: disciplina, professor: professor, semestre: '2024.1') }
  let(:template) { Template.create!(titulo: 'Test Template', publico_alvo: 1, criado_por: user) }

  before do
    assign(:formularios, [
             Formulario.create!(
               template: template,
               turma: turma,
               coordenador: user
             ),
             Formulario.create!(
               template: template,
               turma: turma,
               coordenador: user
             )
           ])
  end

  it 'renders a list of formularios' do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
  end
end
