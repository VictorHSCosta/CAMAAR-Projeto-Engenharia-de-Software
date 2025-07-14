#!/usr/bin/env ruby

# Script para simular uma submissão de avaliação
puts "🔄 Simulando submissão de avaliação..."

# Conectar ao banco de dados
require_relative 'config/environment'

# Simular parâmetros de uma submissão
formulario_id = 1
formulario = Formulario.find(formulario_id)

puts "📋 Formulário: #{formulario.template.titulo}"
puts "🔍 Perguntas: #{formulario.template.pergunta.count}"

# Criar UUID anônimo para esta submissão
uuid_anonimo = SecureRandom.uuid
puts "🎭 UUID anônimo: #{uuid_anonimo}"

# Simular respostas para cada pergunta
respostas_params = {}
formulario.template.pergunta.each_with_index do |pergunta, index|
  case pergunta.tipo
  when 'subjetiva'
    respostas_params["pergunta_#{pergunta.id}"] = "Resposta simulada #{index + 1}"
  when 'verdadeiro_falso'
    # Buscar opções verdadeiro/falso para esta pergunta
    opcao = pergunta.opcoes_pergunta.first
    respostas_params["pergunta_#{pergunta.id}"] = opcao&.id.to_s if opcao
  when 'multipla_escolha'
    # Buscar primeira opção disponível
    opcao = pergunta.opcoes_pergunta.first
    respostas_params["pergunta_#{pergunta.id}"] = opcao&.id.to_s if opcao
  end
end

puts "\n📝 Respostas simuladas:"
respostas_params.each do |key, value|
  puts "  #{key}: #{value}"
end

# Tentar processar as respostas
begin
  respostas_params.each do |param_name, resposta|
    next unless param_name.start_with?('pergunta_')
    
    pergunta_id = param_name.split('_').last.to_i
    pergunta = Perguntum.find(pergunta_id)
    
    resposta_data = {
      formulario: formulario,
      pergunta: pergunta,
      uuid_anonimo: uuid_anonimo
    }
    
    if resposta.present? && resposta.to_i > 0
      # É uma opção de múltipla escolha ou verdadeiro/falso
      opcao = OpcoesPerguntum.find(resposta.to_i)
      resposta_data[:opcao] = opcao
    else
      # É uma resposta subjetiva
      resposta_data[:resposta_texto] = resposta
    end
    
    nova_resposta = Respostum.create!(resposta_data)
    puts "✅ Resposta criada: ID #{nova_resposta.id}"
  end
  
  # Marcar submissão como concluída
  SubmissaoConcluida.create!(
    formulario: formulario,
    uuid_anonimo: uuid_anonimo
  )
  
  puts "\n🎉 Submissão concluída com sucesso!"
  puts "📊 Total de respostas: #{Respostum.where(uuid_anonimo: uuid_anonimo).count}"
  
rescue => e
  puts "\n❌ Erro durante a submissão:"
  puts "   #{e.message}"
  puts "   #{e.backtrace.first}"
end
