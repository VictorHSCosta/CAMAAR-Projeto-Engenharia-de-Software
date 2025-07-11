# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'templates/edit', type: :view do
  let(:template) do
    Template.create!(
      titulo: 'MyString',
      publico_alvo: 1,
      criado_por: nil
    )
  end

  before do
    assign(:template, template)
  end

  it 'renders the edit template form' do # rubocop:disable RSpec/ExampleLength
    render

    assert_select 'form[action=?][method=?]', template_path(template), 'post' do
      assert_select 'input[name=?]', 'template[titulo]'

      assert_select 'input[name=?]', 'template[publico_alvo]'

      assert_select 'input[name=?]', 'template[criado_por_id]'
    end
  end
end
