#!/usr/bin/env ruby

# Script para testar o sistema de avaliação
puts "🔍 Testando sistema de avaliação..."

# Conectar ao banco de dados
require_relative 'config/environment'

# Verificar se existem formulários disponíveis
puts "\n📋 Formulários disponíveis:"
Formulario.all.each do |form|
  puts "  - ID: #{form.id}, Template: #{form.template.titulo}, Ativo: #{form.ativo}"
end

# Verificar se existe um usuário para testar
user = User.first
if user
  puts "\n👤 Usuário para teste: #{user.name} (#{user.email})"
  
  # Verificar formulários que o usuário pode ver
  active_forms = Formulario.where(ativo: true)
  puts "\n👁️  Formulários ativos para o usuário:"
  active_forms.each do |form|
    puts "  - #{form.template.titulo} (ID: #{form.id})"
    puts "    Perguntas: #{form.template.pergunta.count}"
    form.template.pergunta.each do |pergunta|
      puts "      - #{pergunta.texto} (Tipo: #{pergunta.tipo})"
    end
  end
else
  puts "\n⚠️  Nenhum usuário encontrado!"
end

# Verificar respostas existentes
puts "\n📝 Respostas existentes:"
Respostum.all.each do |resposta|
  puts "  - UUID: #{resposta.uuid_anonimo}, Formulário: #{resposta.formulario.template.titulo}"
end

puts "\n✅ Teste concluído!"
