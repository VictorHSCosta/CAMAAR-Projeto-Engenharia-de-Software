# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Cria usuários de exemplo
unless User.exists?(email: "admin@camaar.com")
  User.create!(
    email: "admin@camaar.com",
    password: "123456",
    password_confirmation: "123456",
    name: "Administrador",
    matricula: "000000",
    role: 0
  )
end

unless User.exists?(email: "professor@camaar.com")
  User.create!(
    email: "professor@camaar.com",
    password: "123456",
    password_confirmation: "123456",
    name: "Professor Exemplo",
    matricula: "111111",
    role: 1
  )
end

unless User.exists?(email: "aluno@camaar.com")
  User.create!(
    email: "aluno@camaar.com",
    password: "123456",
    password_confirmation: "123456",
    name: "Aluno Exemplo",
    matricula: "222222",
    role: 2
  )
end

# Cria cursos de exemplo
["Engenharia de Software", "Ciência da Computação", "Sistemas de Informação"].each do |nome_curso|
  Curso.find_or_create_by!(nome: nome_curso)
end

puts "Seeds executados com sucesso!"
puts "Usuários criados:"
puts "  - admin@camaar.com (senha: 123456)"
puts "  - professor@camaar.com (senha: 123456)"
puts "  - aluno@camaar.com (senha: 123456)"
