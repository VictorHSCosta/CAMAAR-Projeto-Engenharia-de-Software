# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'helper methods' do
    it 'responds to helper methods' do
      # Testa se o helper está carregado corretamente
      expect(helper).to respond_to(:link_to)
    end
  end

  # Adicione testes específicos para métodos do ApplicationHelper aqui
  # Por exemplo, se você tiver um método para formatar datas:
  # describe '#format_date' do
  #   it 'formats date correctly' do
  #     date = Date.new(2024, 1, 15)
  #     expect(helper.format_date(date)).to eq('15/01/2024')
  #   end
  # end
end
