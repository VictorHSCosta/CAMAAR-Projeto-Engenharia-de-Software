# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'disciplinas/edit', type: :view do
  let(:disciplina) do
    Disciplina.create!(
      nome: 'MyString',
      curso: nil
    )
  end

  before do
    assign(:disciplina, disciplina)
  end

  it 'renders the edit disciplina form' do
    render

    assert_select 'form[action=?][method=?]', disciplina_path(disciplina), 'post' do
      assert_select 'input[name=?]', 'disciplina[nome]'

      assert_select 'input[name=?]', 'disciplina[curso_id]'
    end
  end
end
