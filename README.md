***Entrega 27 de Agosto***


# CzarManagement

Uma plataforma completa de gerenciamento de tarefas e projetos desenvolvida em Ruby on Rails, onde usuários podem criar e participar de projetos, criar tarefas, atribuí-las a outros membros, acompanhar progresso e prioridades.

## 🎯 Objetivo Principal

CzarManagement é uma versão simplificada de ferramentas como Trello/Asana, focada em facilitar a colaboração em projetos e o gerenciamento eficiente de tarefas entre equipes.

## 🚀 Funcionalidades

### Autenticação e Usuários
- Sistema de cadastro e login seguro
- Autenticação baseada em sessões com `has_secure_password`
- Proteção de rotas que requerem autenticação

### Gerenciamento de Projetos
- Criação, edição e exclusão de projetos
- Descrição detalhada de objetivos e escopo
- Participação de múltiplos usuários por projeto
- Dashboard com estatísticas do projeto

### Sistema de Tarefas
- Criação de tarefas dentro de projetos
- Atribuição de responsáveis
- Status: Pendente, Em Andamento, Concluída
- Prioridades: Baixa, Média, Alta
- Descrições detalhadas

### Requisitos de Projeto
- Definição de requisitos e funcionalidades
- Priorização de requisitos
- Organização por projeto

## 🏗️ Arquitetura

### Modelos e Relacionamentos

#### User (Usuário)
```ruby
# Atributos
- name: string
- email: string (único)
- password_digest: string

# Relacionamentos
- has_many :authored_tasks (tarefas criadas)
- has_many :assigned_tasks (tarefas atribuídas)
- has_and_belongs_to_many :projects
```

#### Project (Projeto)
```ruby
# Atributos
- name: string
- description: text

# Relacionamentos
- has_and_belongs_to_many :users
- has_many :requirements
- has_many :tasks
```

#### Task (Tarefa)
```ruby
# Atributos
- title: string
- description: text
- status: integer (enum: pendente, em_andamento, concluída)
- priority: integer (enum: baixa, média, alta)

# Relacionamentos
- belongs_to :project
- belongs_to :author (User)
- belongs_to :assigned_to (User)
```

#### Requirement (Requisito)
```ruby
# Atributos
- title: string
- description: text
- priority: integer (enum: baixa, média, alta)

# Relacionamentos
- belongs_to :project
```

## 🔐 Regras de Negócio

1. **Autenticação Obrigatória**: Usuários devem estar logados para acessar funcionalidades
2. **Participação em Projetos**: Usuários só podem ver/editar projetos dos quais participam
3. **Criação de Tarefas**: Tarefas são criadas por um usuário e atribuídas a outro
4. **Validações**: Todos os campos obrigatórios são validados
5. **Email Único**: Cada usuário deve ter um email único no sistema

## 🛠️ Tecnologias Utilizadas

- **Ruby**: 3.2.2
- **Rails**: 8.0.2
- **Banco de Dados**: SQLite (desenvolvimento)
- **Autenticação**: bcrypt gem com has_secure_password
- **Frontend**: Bootstrap 5 para interface responsiva
- **Ambiente**: WSL com Ubuntu

## 📦 Instalação e Configuração

### Pré-requisitos
- Ruby 3.2.2
- Rails 8.0.2
- SQLite3

### Passos para Instalação

1. **Clone o repositório**
```bash
git clone <repository-url>
cd czar_management
```

2. **Instale as dependências**
```bash
bundle install
```

3. **Configure o banco de dados**
```bash
rails db:create
rails db:migrate
```

4. **Inicie o servidor**
```bash
rails server -b 0.0.0.0 -p 3000
```

5. **Acesse a aplicação**
```
http://localhost:3000
```

## 🎨 Interface

A aplicação utiliza Bootstrap 5 para uma interface moderna e responsiva:

- **Layout Responsivo**: Funciona em desktop e dispositivos móveis
- **Navegação Intuitiva**: Menu superior com links principais
- **Cards Informativos**: Projetos e tarefas exibidos em cards organizados
- **Formulários Validados**: Feedback visual para validações
- **Cores Temáticas**: Sistema de cores para status e prioridades

## 📱 Páginas Principais

### 1. Autenticação
- `/login` - Página de login
- `/signup` - Página de cadastro

### 2. Projetos
- `/` - Lista de projetos do usuário
- `/projects/new` - Criar novo projeto
- `/projects/:id` - Detalhes do projeto com tarefas e requisitos
- `/projects/:id/edit` - Editar projeto

### 3. Tarefas
- `/projects/:id/tasks/new` - Criar nova tarefa
- `/projects/:id/tasks/:id` - Detalhes da tarefa
- `/projects/:id/tasks/:id/edit` - Editar tarefa

### 4. Requisitos
- `/projects/:id/requirements/new` - Criar novo requisito
- `/projects/:id/requirements/:id` - Detalhes do requisito
- `/projects/:id/requirements/:id/edit` - Editar requisito

## 🔧 Estrutura de Controllers

### ApplicationController
- Métodos de autenticação (`current_user`, `require_login`)
- Helpers globais para todas as páginas

### SessionsController
- `new` - Exibe formulário de login
- `create` - Processa login
- `destroy` - Logout

### UsersController
- `new` - Exibe formulário de cadastro
- `create` - Processa cadastro

### ProjectsController
- CRUD completo para projetos
- Verificação de participação do usuário

### TasksController
- CRUD completo para tarefas
- Nested routes dentro de projetos

### RequirementsController
- CRUD completo para requisitos
- Nested routes dentro de projetos

## 🎯 Funcionalidades Implementadas

### ✅ Concluído
- [x] Sistema de autenticação completo
- [x] CRUD de usuários
- [x] CRUD de projetos
- [x] CRUD de tarefas
- [x] CRUD de requisitos
- [x] Relacionamentos entre modelos
- [x] Interface web responsiva
- [x] Validações de dados
- [x] Sistema de enums para status e prioridades
- [x] Dashboard de projetos com estatísticas
- [x] Navegação por abas (tarefas/requisitos)

### 🔄 Melhorias Futuras
- [ ] Sistema de notificações
- [ ] Comentários em tarefas
- [ ] Upload de arquivos
- [ ] Relatórios e gráficos
- [ ] API REST
- [ ] Integração com calendário
- [ ] Sistema de permissões mais granular

## 🧪 Testes Realizados

### Funcionalidades Testadas
1. **Autenticação**
   - Cadastro de usuário ✅
   - Login/logout ✅
   - Redirecionamento para login quando não autenticado ✅

2. **Projetos**
   - Criação de projeto ✅
   - Listagem de projetos ✅
   - Visualização de detalhes ✅

3. **Interface**
   - Responsividade ✅
   - Navegação entre páginas ✅
   - Formulários e validações ✅

## 🚀 Deploy

A aplicação está configurada para deploy em produção:

- Configuração de hosts permitidos
- Servidor configurado para escutar em `0.0.0.0`
- Suporte a CORS para integração frontend/backend

## 📞 Suporte

Para dúvidas ou problemas:
1. Verifique a documentação
2. Consulte os logs do Rails
3. Verifique as validações dos modelos

## 📄 Licença

Este projeto foi desenvolvido como demonstração de uma plataforma de gerenciamento de projetos usando Ruby on Rails.

---

**CzarManagement** - Simplifique o gerenciamento dos seus projetos! 🎯

