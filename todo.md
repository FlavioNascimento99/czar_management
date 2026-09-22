# CzarManagement - Lista de Tarefas

## Fase 1: Configuração inicial do projeto Rails
- [x] Verificar versão do Ruby instalada
- [x] Instalar Ruby 3.2.2 se necessário
- [x] Instalar Rails 8.0.2
- [x] Criar novo projeto Rails com SQLite
- [x] Configurar Gemfile com bcrypt para autenticação
- [x] Executar bundle install

## Fase 2: Criação dos modelos e relacionamentos
- [x] Criar modelo User com atributos e validações
- [x] Criar modelo Project com atributos
- [x] Criar modelo Task com atributos e enums
- [x] Criar modelo Requirement com atributos
- [x] Configurar relacionamentos entre modelos
- [x] Criar tabela de junção para User-Project (N:N)
- [x] Executar migrações

## Fase 3: Implementação do sistema de autenticação
- [x] Configurar has_secure_password no modelo User
- [x] Criar controller de autenticação (sessions)
- [x] Implementar métodos de login/logout
- [x] Criar helpers de autenticação
- [x] Configurar rotas de autenticação

## Fase 4: Desenvolvimento dos controllers e rotas
- [x] Criar controller para Projects
- [x] Criar controller para Tasks
- [x] Criar controller para Requirements
- [x] Implementar CRUD para cada entidade
- [x] Configurar rotas RESTful
- [x] Implementar autorização básica

## Fase 5: Criação das views e interface web
- [x] Criar layout principal da aplicação
- [x] Criar views de autenticação (login/registro)
- [x] Criar views para projetos
- [x] Criar views para tarefas
- [x] Criar views para requisitos
- [x] Implementar navegação e interface básica

## Fase 6: Testes e validação do sistema
- [x] Testar funcionalidades de autenticação
- [x] Testar criação e listagem de projetos
- [x] Testar navegação entre páginas
- [x] Corrigir problemas encontrados (enum syntax)
- [x] Validar interface e usabilidade
- [ ] Testar CRUD de projetos
- [ ] Testar CRUD de tarefas
- [ ] Testar CRUD de requisitos
- [ ] Validar relacionamentos entre entidades
- [ ] Testar interface web completa

## Fase 7: Entrega final e documentação
- [x] Criar documentação completa (README.md)
- [x] Criar guia de uso para usuários
- [x] Documentar arquitetura e funcionalidades
- [x] Preparar entrega final

## Estado atual (2026-09-22)

Fases 1–5 e 7 entregues. Fase 6 parcialmente pendente (itens acima) —
coberta pela suite RSpec (`bundle exec rspec`), mas sem aceite manual
roteirizado (ver `docs/ROADMAP_PENDENTE.md`).
7. ✅ Entrega final e documentação
- [ ] Entregar projeto completo

