# Sistema de Templates - Documentação

## Visão Geral

O sistema de templates permite que administradores criem formulários de avaliação personalizados para alunos e professores. Cada template pode conter múltiplas perguntas de diferentes tipos, com respostas sempre anônimas.

## Funcionalidades Implementadas

### 1. Gestão de Templates
- **Lista de Templates**: Visualização de todos os templates criados com estatísticas
- **Criação de Templates**: Interface dinâmica para criar novos templates
- **Edição de Templates**: Modificar templates existentes
- **Visualização de Templates**: Preview completo do template com todas as perguntas
- **Exclusão de Templates**: Remover templates (apenas administradores)

### 2. Tipos de Perguntas Suportadas

#### Verdadeiro/Falso
- Pergunta com duas opções: Verdadeiro ou Falso
- Ideal para afirmações que requerem confirmação
- Enum: `verdadeiro_falso` (valor 0)

#### Múltipla Escolha
- Pergunta com múltiplas opções de resposta
- Permite adicionar/remover opções dinamicamente
- Mínimo de 2 opções recomendado
- Enum: `multipla_escolha` (valor 1)

#### Subjetiva
- Pergunta com resposta aberta em texto
- Sem limite de caracteres
- Ideal para feedbacks detalhados
- Enum: `subjetiva` (valor 2)

### 3. Características das Perguntas
- **Obrigatórias**: Perguntas podem ser marcadas como obrigatórias
- **Ordem**: Perguntas são exibidas na ordem de criação
- **Validação**: Validação automática de campos obrigatórios

### 4. Controle de Acesso
- **Administradores**: Acesso completo (criar, editar, visualizar, deletar)
- **Professores**: Sem acesso ao sistema de templates
- **Alunos**: Sem acesso ao sistema de templates
- **Política**: Implementada via Pundit (`TemplatePolicy`)

## Estrutura do Banco de Dados

### Tabela `templates`
```sql
- id: integer (chave primária)
- titulo: string (obrigatório)
- descricao: text (opcional)
- publico_alvo: string (enum: 'alunos', 'professores')
- disciplina_id: integer (FK para disciplinas)
- user_id: integer (FK para users - criador)
- created_at: datetime
- updated_at: datetime
```

### Tabela `pergunta`
```sql
- id: integer (chave primária)
- texto: text (obrigatório)
- tipo: integer (enum: 0=verdadeiro_falso, 1=multipla_escolha, 2=subjetiva)
- obrigatoria: boolean (padrão: true)
- template_id: integer (FK para templates)
- created_at: datetime
- updated_at: datetime
```

### Tabela `opcoes_pergunta`
```sql
- id: integer (chave primária)
- texto: string (obrigatório)
- perguntum_id: integer (FK para pergunta)
- created_at: datetime
- updated_at: datetime
```

## Associações dos Models

### Template
```ruby
belongs_to :disciplina
belongs_to :criado_por, class_name: 'User', foreign_key: 'user_id'
has_many :pergunta, dependent: :destroy
enum publico_alvo: { alunos: 0, professores: 1 }
scope :para_alunos, -> { where(publico_alvo: 'alunos') }
scope :para_professores, -> { where(publico_alvo: 'professores') }
```

### Perguntum
```ruby
belongs_to :template
has_many :opcoes_pergunta, dependent: :destroy
enum tipo: { verdadeiro_falso: 0, multipla_escolha: 1, subjetiva: 2 }
```

### OpcoesPerguntum
```ruby
belongs_to :perguntum
```

## Rotas

```ruby
resources :templates do
  # GET /templates - Lista todos os templates
  # GET /templates/new - Formulário para criar novo template
  # POST /templates - Criar novo template
  # GET /templates/:id - Visualizar template específico
  # GET /templates/:id/edit - Formulário para editar template
  # PATCH/PUT /templates/:id - Atualizar template
  # DELETE /templates/:id - Remover template
end
```

## Controllers

### TemplatesController
- `index`: Lista todos os templates do usuário
- `show`: Exibe template específico
- `new`: Formulário para criar novo template
- `create`: Processa criação do template e suas perguntas
- `edit`: Formulário para editar template existente
- `update`: Processa atualização do template e suas perguntas
- `destroy`: Remove template e suas perguntas

### Métodos Principais
- `authorize_template`: Autorização via Pundit
- `process_perguntas`: Processa perguntas do formulário (criar/atualizar/deletar)
- `template_params`: Parâmetros permitidos

## Views

### index.html.erb
- Lista de templates com estatísticas
- Cards com informações resumidas
- Botões de ação (visualizar, editar, deletar)
- Filtros por tipo de público

### new.html.erb
- Formulário dinâmico para criar template
- JavaScript para adicionar/remover perguntas
- Interface para gerenciar opções de múltipla escolha
- Validação em tempo real

### edit.html.erb
- Formulário para editar template existente
- Carrega perguntas e opções existentes
- Permite adicionar novas perguntas
- Permite editar/deletar perguntas existentes

### show.html.erb
- Visualização completa do template
- Preview de todas as perguntas
- Estatísticas do template
- Informações do criador

## JavaScript

### Funcionalidades
- Adicionar/remover perguntas dinamicamente
- Alterar tipo de pergunta
- Gerenciar opções de múltipla escolha
- Validação de formulários
- Numeração automática de perguntas

### Eventos
- `add-pergunta`: Adiciona nova pergunta
- `remove-pergunta`: Remove pergunta
- `change` no tipo: Mostra/oculta opções
- `add-opcao`: Adiciona nova opção
- `remove-opcao`: Remove opção

## Estilos CSS

### Classes Principais
- `.pergunta-item`: Container para cada pergunta
- `.opcoes-container`: Container para opções de múltipla escolha
- `.opcao-item`: Item individual de opção
- `.user-avatar-small`: Avatar pequeno do usuário
- `.pergunta-preview`: Preview da pergunta na visualização

### Efeitos
- Hover effects em cards e botões
- Transições suaves
- Animações de entrada
- Responsividade para dispositivos móveis

## Segurança

### Autorização
- Apenas administradores podem acessar templates
- Validação via `TemplatePolicy`
- Redirecionamento para página de erro se não autorizado

### Validação
- Campos obrigatórios no modelo
- Validação de presença de título
- Validação de associações (disciplina, usuário)

## Próximos Passos

1. **Sistema de Respostas**: Implementar coleta de respostas anônimas
2. **Relatórios**: Gerar relatórios com estatísticas das respostas
3. **Notificações**: Alertar quando novos formulários estão disponíveis
4. **Exportação**: Exportar dados para Excel/PDF
5. **Templates Predefinidos**: Criar templates padrão para diferentes tipos de avaliação

## Troubleshooting

### Problemas Comuns
1. **Erro 403**: Usuário não é administrador
2. **Perguntas não salvam**: Verificar parâmetros do formulário
3. **JavaScript não funciona**: Verificar console do navegador
4. **Disciplinas não aparecem**: Verificar associação user-disciplina

### Logs
- Verificar `log/development.log` para erros
- Console do navegador para erros de JavaScript
- Parâmetros do formulário no log do Rails
