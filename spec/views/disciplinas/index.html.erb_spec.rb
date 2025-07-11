# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'disciplinas/index', type: :view do
  let(:curso) { Curso.create!(nome: 'Test Course') }

  before do
    assign(:disciplinas, [
             Disciplina.create!(
               nome: 'Nome',
               curso: curso
             ),
             Disciplina.create!(
               nome: 'Nome',
               curso: curso
             )
           ])
  end

  it 'renders a list of disciplinas' do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new('Nome'), count: 2
  end
end
