FactoryBot.define do
  factory :curso do
    nome { Faker::Educator.course_name }
  end
end
