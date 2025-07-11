# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'turmas/show', type: :view do
  let(:curso) { create(:curso) }
  let(:professor) { create(:user, role: 'professor') }
  let(:disciplina) { create(:disciplina, curso: curso) }
  let(:turma) { create(:turma, professor: professor, disciplina: disciplina) }

  before do
    assign(:turma, turma)
  end

  it 'renders attributes in <p>' do # rubocop:disable RSpec/MultipleExpectations
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Semestre/)
  end
end
