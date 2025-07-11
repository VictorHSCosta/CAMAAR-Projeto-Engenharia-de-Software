# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'matriculas/edit', type: :view do
  let(:matricula) do
    Matricula.create!(
      user: nil,
      turma: nil
    )
  end

  before do
    assign(:matricula, matricula)
  end

  it 'renders the edit matricula form' do
    render

    assert_select 'form[action=?][method=?]', matricula_path(matricula), 'post' do
      assert_select 'input[name=?]', 'matricula[user_id]'

      assert_select 'input[name=?]', 'matricula[turma_id]'
    end
  end
end
