# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'opcoes_pergunta/edit', type: :view do
  let(:opcoes_perguntum) do
    OpcoesPerguntum.create!(
      pergunta: nil,
      texto: 'MyString'
    )
  end

  before do
    assign(:opcoes_perguntum, opcoes_perguntum)
  end

  it 'renders the edit opcoes_perguntum form' do
    render

    assert_select 'form[action=?][method=?]', opcoes_perguntum_path(opcoes_perguntum), 'post' do
      assert_select 'input[name=?]', 'opcoes_perguntum[pergunta_id]'

      assert_select 'input[name=?]', 'opcoes_perguntum[texto]'
    end
  end
end
