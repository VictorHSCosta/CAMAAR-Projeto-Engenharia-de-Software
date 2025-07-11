# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'matriculas/show', type: :view do
  before do
    assign(:matricula, Matricula.create!(
                         user: nil,
                         turma: nil
                       ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
