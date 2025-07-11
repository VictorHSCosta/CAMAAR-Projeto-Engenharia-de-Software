# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'formularios/show', type: :view do
  before do
    assign(:formulario, Formulario.create!(
                          template: nil,
                          turma: nil,
                          coordenador: nil
                        ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
