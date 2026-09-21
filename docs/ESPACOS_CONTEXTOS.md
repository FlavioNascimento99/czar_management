# Espaços: Equipe vs Pessoal | Branch `feature/espacos-contextos`

`Project#kind` (`equipe` default, `pessoal`): pessoal = 1 membro, sem
convites, sem card de membros; index separada; template `rotina_estudos`.

## Checks
- [x] Migration up dev+test; `rspec` 140/0; `rubocop` 129 limpo; `brakeman` 0
- [x] Pessoal bloqueia add_member e conversão equipe→pessoal com >1 membro
- [x] Index separa `@team_projects` / `@personal_projects`
