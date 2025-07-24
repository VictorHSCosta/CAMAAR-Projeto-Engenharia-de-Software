# frozen_string_literal: true

FactoryBot.define do
  factory :submissao_concluida do
    association :user
    association :formulario
    data_submissao { Time.current }
  end
end
