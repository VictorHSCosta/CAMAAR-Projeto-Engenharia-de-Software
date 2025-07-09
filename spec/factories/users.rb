FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { 'password123' }
    password_confirmation { 'password123' }
    name { Faker::Name.name }
    matricula { Faker::Number.number(digits: 8).to_s }
    role { 0 } # Assumindo que 0 é um papel válido
  end
end
