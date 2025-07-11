# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'turmas/index', type: :view do
  let(:curso) { create(:curso) }
  let(:professor) { create(:user, role: 'professor') }
  let(:disciplina) { create(:disciplina, curso: curso) }
  let(:turma) { create(:turma, professor: professor, disciplina: disciplina) }

  before do
    assign(:turma, turma)
  end

  it 'renders a list of turmas' do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new('Semestre'), count: 2
  end
end
