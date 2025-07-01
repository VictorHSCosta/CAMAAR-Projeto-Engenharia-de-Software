# CAMAAR
**Sistema para avaliação de atividades acadêmicas remotas do CIC**

---

## Membros do Grupo

1. **Victor Henrique da Silva Costa** - 212006450
2. **Denis S.G de Araújo** - 140136282  
3. **Luís Eduardo Dalle Molle** - 241034059
4. **Ryan Reis Fontenele** - 211036132
5. **Gabriel Henrique Barbosa de Oliveira** - 231029583

---

## Papéis do Scrum

### Product Owner
*A ser definido*

### Scrum Master  
 - **Victor Henrique da Silva Costa** - 212006450

### Development Team
 - **Denis S.G de Araújo** - 140136282  
 - **Luís Eduardo Dalle Molle** - 241034059
 - **Ryan Reis Fontenele** - 211036132
 - **Gabriel Henrique Barbosa de Oliveira** - 231029583

---

## Funcionalidades Principais

### 1. Autenticação de Usuários

* **Descrição**: Permite o acesso ao sistema por meio de login e senha, com papéis distintos para administradores, coordenadores, docentes e discentes. O sistema valida credenciais, mantém sessões seguras e controla permissões de acordo com o papel do usuário.
* **Entidades Envolvidas**: `usuarios` (id, email, senha\_hash, nome, papel, matrícula, curso\_id)
* **BDD**:

  * **Cenário**: Login bem-sucedido para cada tipo de usuário.
  * **Cenário**: Acesso negado a áreas restritas sem autenticação.

### 2. Gerenciamento de Templates de Formulários

* **Descrição**: CRUD para templates de formulários (título, público-alvo, perguntas e opções). Templates definidos por administradores ou coordenadores servem de base para criação de formulários instanciados.
* **Entidades Envolvidas**: `templates` (id, título, público\_alvo, criado\_por), `perguntas` (id, template\_id, título, tipo, ordem), `opcoes_pergunta` (id, pergunta\_id, texto)
* **BDD**:

  * **Funcionalidade**: Criar template de formulário.
  * **Cenário**: Criar template com sucesso, incluindo seleção de público-alvo.
  * **Cenário**: Exclusão de template em uso deve ser bloqueada com mensagem de erro.
  * **Cenário**: Edição de template após uso respeita a integridade dos formulários existentes.

### 3. Criação de Formulários Instanciados

* **Descrição**: Instancia um formulário a partir de um template, direcionando-o a uma turma específica. Define prazos (`data_envio`, `data_fim`) e garante envio apenas a alunos matriculados.
* **Entidades Envolvidas**: `formularios` (id, template\_id, turma\_id, coordenador\_id, data\_envio, data\_fim), `turmas`, `matriculas`
* **BDD**:

  * **Funcionalidade**: Criar formulário para docentes ou discentes.
  * **Cenário**: Criação de formulário direcionado a docentes.
  * **Cenário**: Criação de formulário direcionado a discentes.
  * **Cenário**: Validação de público-alvo obrigatório.

### 4. Submissão de Respostas

* **Descrição**: Interface para alunos responderem questões abertas, de múltipla escolha ou verdadeiro/falso. Suporta anonimato via `uuid_anonimo` e registra timestamp de envio.
* **Entidades Envolvidas**: `respostas` (id, formulario\_id, pergunta\_id, opcao\_id, resposta\_texto, turma\_id, uuid\_anonimo, created\_at)
* **BDD**:

  * **Cenário**: Responder formulário com sucesso dentro do prazo.
  * **Cenário**: Bloqueio de respostas fora do prazo.
  * **Cenário**: Erro ao enviar sem preencher perguntas obrigatórias.
  * **Cenário**: Registro de resposta anônima via `uuid_anonimo`.

### 5. Visualização de Resultados

* **Descrição**: Administradores e coordenadores podem visualizar estatísticas e respostas coletadas. Oferece filtros por curso, disciplina, turma e período, e permite exportação dos dados em CSV ou PDF.
* **Entidades Envolvidas**: junção de `respostas`, `formularios`, `perguntas`, `usuarios`, `turmas`
* **BDD**:

  * **Funcionalidade**: Visualizar resultados dos formulários.
  * **Cenário**: Exibição de resultados completos.
  * **Cenário**: Visualização parcial enquanto o formulário permanece aberto.
  * **Funcionalidade**: Exportação dos resultados via botão no dashboard.

## Funcionalidades Secundárias

* **Notificações**: Alertas por e-mail ou notificações no dashboard sobre novos formulários, prazos de entrega e resultados publicados.
* **Relatórios**: Geração de relatórios de desempenho em PDF ou planilha, com gráficos de participação e taxa de resposta.
* **Backup de Dados**: Agendamento automático de backups do banco de dados e arquivos de formulários.
* **Integração com Moodle**: Sincronização de turmas, usuários e notas via API do Moodle para manter uma única fonte de dados.

## Regras de Negócio

### RN001 - Autenticação
- Apenas usuários cadastrados podem acessar o sistema
- Professores têm permissões de criação e avaliação
- Alunos têm permissões de visualização e submissão

### RN002 - Prazos
- Atividades devem ter data de início e fim bem definidas
- Submissões após o prazo são marcadas como atrasadas
- Professores podem estender prazos individualmente

### RN003 - Avaliação
- Cada atividade deve ter critérios de avaliação claros
- Notas devem ser numéricas de 0 a 10
- Feedback textual é obrigatório para notas abaixo de 7

### RN004 - Integridade dos Dados
- Todas as submissões devem ser versionadas
- Logs de acesso devem ser mantidos por 2 anos
- Backup diário dos dados críticos

---

## Responsabilidades de Cada Membro

### Victor Henrique da Silva Costa
- **Backend Development**: Desenvolvimento da API REST
- **Banco de Dados**: Modelagem e implementação do banco de dados
- **Autenticação**: Sistema de login e controle de acesso

### Denis S.G de Araújo  
- **Frontend Development**: Interface do usuário com React
- **UX/UI Design**: Design da experiência do usuário
- **Testes de Interface**: Testes automatizados do frontend

### Luís Eduardo Dalle Molle
- **DevOps**: Configuração de CI/CD e deploy
- **Infraestrutura**: Configuração de servidores e monitoramento
- **Segurança**: Implementação de medidas de segurança

### Ryan Reis Fontenele
- **Quality Assurance**: Testes unitários e de integração  
- **Documentação**: Documentação técnica e de usuário
- **Análise de Requisitos**: Levantamento e validação de requisitos

### Gabriel Henrique Barbosa de Oliveira
- **Mobile Development**: Aplicativo mobile complementar
- **Integração**: Integração com sistemas externos (Moodle)
- **Performance**: Otimização de performance do sistema

---

## Política de Branching

### Estrutura de Branches

\`\`\`
main
├── develop
├── feature/nome-da-funcionalidade
├── hotfix/nome-do-hotfix
└── release/versao
\`\`\`

### Regras de Branching

#### Branch `main`
- **Propósito**: Código em produção
- **Proteção**: Apenas merge via Pull Request
- **Testes**: Todos os testes devem passar
- **Review**: Obrigatório review de pelo menos 2 membros

#### Branch `develop`  
- **Propósito**: Integração de funcionalidades
- **Origem**: Base para feature branches
- **Merge**: Apenas de feature branches testadas

#### Feature Branches
- **Nomenclatura**: `feature/CAMAAR-123-nome-descritivo`
- **Origem**: Criada a partir de `develop`
- **Ciclo de Vida**: 
  1. Criar branch
  2. Desenvolver funcionalidade
  3. Testes locais
  4. Pull Request para `develop`
  5. Code Review
  6. Merge e exclusão da branch

#### Hotfix Branches
- **Nomenclatura**: `hotfix/CAMAAR-456-correcao-critica`
- **Origem**: Criada a partir de `main`
- **Urgência**: Para correções críticas em produção
- **Merge**: Tanto em `main` quanto em `develop`

#### Release Branches
- **Nomenclatura**: `release/v1.2.0`
- **Propósito**: Preparação para nova versão
- **Atividades**: Testes finais, ajustes de versão, documentação

### Commits

#### Padrão de Commit Messages
\`\`\`
tipo(escopo): descrição breve

Descrição mais detalhada se necessário

Closes #123
\`\`\`

#### Tipos de Commit
- `feat`: Nova funcionalidade
- `fix`: Correção de bug  
- `docs`: Documentação
- `style`: Formatação de código
- `refactor`: Refatoração
- `test`: Testes
- `chore`: Tarefas de manutenção

#### Exemplo de Commit
\`\`\`bash
git commit -m "feat(auth): implementa sistema de login com JWT

- Adiciona middleware de autenticação
- Implementa geração e validação de tokens
- Adiciona testes unitários para auth service

Closes #45"
\`\`\`
