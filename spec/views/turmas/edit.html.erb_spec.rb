# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'turmas/edit', type: :view do
  let(:turma) do
    Turma.create!(
      disciplina: nil,
      professor: nil,
      semestre: 'MyString'
    )
  end

  before do
    assign(:turma, turma)
  end

  it 'renders the edit turma form' do
    render

    assert_select 'form[action=?][method=?]', turma_path(turma), 'post' do
      assert_select 'input[name=?]', 'turma[disciplina_id]'

      assert_select 'input[name=?]', 'turma[professor_id]'

      assert_select 'input[name=?]', 'turma[semestre]'
    end
  end
end
