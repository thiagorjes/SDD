# Convenções de Skills — SSPDD Framework
_Atualizado em: 2026-08-22_

> Este arquivo substitui `api-conventions.md` — o framework não expõe HTTP API.
> As "interfaces" são os contratos de entrada/saída de cada skill.

## Contrato de uma Skill

### Entrada (Input)
Toda skill deve declarar explicitamente no `SKILL.md`:

| Campo | Obrigatório | Descrição |
|-------|------------|-----------|
| Argumentos CLI | Não | Flags/texto passados ao invocar `/skill [args]` |
| Arquivos de entrada | Sim | Lista de arquivos que a skill lê (com caminho relativo) |
| Estado requerido | Sim | O que deve estar em `memory/state.md` antes de executar |

### Saída (Output)
| Campo | Obrigatório | Descrição |
|-------|------------|-----------|
| Artefatos criados | Sim | Arquivos novos gerados pela skill |
| Artefatos modificados | Sim | Arquivos existentes alterados |
| Atualização de state.md | Sim | Bloco de handoff obrigatório em toda skill |
| Atualização de constitution.md | Apenas ADRs | Quando a skill produz decisão arquitetural |

## Lifecycle de uma Skill

Toda skill interativa segue exatamente estas fases, em ordem:

```
Fase 0: Pré-condições   → ler state.md, verificar inputs, identificar gaps
Fase 1: Diagnóstico     → analisar contexto existente silenciosamente
Fase 2: Levantamento    → entrevista interativa (1 pergunta por vez)
Fase 3: Consolidação    → resumo para validação do usuário
Fase 4: Geração         → criar artefato(s) progressivamente
Fase 5: Validação       → executar validate.py, corrigir erros
Fase 6: Handoff         → atualizar state.md, orientar próximo passo
```

Skills não-interativas (ex: `/analyze`, `/spdd-sync`) omitem Fases 2 e 3.

## Convenções de Persistência

### Salvamento progressivo (obrigatório)
1. Criar o arquivo com cabeçalho imediatamente ao iniciar Fase 4
2. Acrescentar seção por seção — nunca construir tudo na memória e salvar de uma vez
3. Registrar em chat: `docs/[tipo]/[nome].md — seção X salva`

### Nomenclatura de Artefatos
| Tipo | Padrão | Exemplo |
|------|--------|---------|
| PRD | `docs/prd/[kebab-case]-prd.md` | `docs/prd/auth-login-prd.md` |
| TechSpec | `docs/techspec/[sistema]-[kebab-case]-techspec.md` | `docs/techspec/api-auth-login-techspec.md` |
| Tasks | `docs/tasks/[sistema]-[kebab-case]-tasks.md` | `docs/tasks/api-auth-login-tasks.md` |
| REASONS Canvas | `docs/spdd/[kebab-case]-canvas.md` | `docs/spdd/auth-login-canvas.md` |
| Desvios de Canvas | `docs/spdd/[kebab-case]-deviations.md` | `docs/spdd/auth-login-deviations.md` |
| Checklist | `docs/checklists/[kebab-case]-[tipo].md` | `docs/checklists/auth-login-prd.md` |
| Contratos | `docs/contracts/[sistema-a]-[sistema-b]-contract.md` | — |

## Bloco de Handoff (state.md)

Formato obrigatório ao concluir qualquer skill:

```markdown
### [Nome da Feature]
- **Etapa concluída:** /[skill] (v[x.y]) — [data ISO]
- **Artefato:** [caminho]
- **Sistemas afetados:** [nomes e papéis]
- **Status:** [Em especificação | Em implementação | Concluída]
- **Próximo comando:** /[próxima-skill]
- **Questões em aberto:** [lista ou "nenhuma"]
```

## Convenções de Nomes de Skills

| Padrão | Exemplos | Quando usar |
|--------|---------|------------|
| `[verbo]` | `guidelines`, `implement`, `analyze` | Skills de ação única |
| `[verbo]-[escopo]` | `code-review`, `spdd-canvas`, `spdd-sync` | Skills com escopo específico |
| `[recurso]` | `prd`, `techspec`, `tasks` | Skills orientadas a artefato |

## Interatividade — Regras Absolutas

1. **Nunca emitir múltiplas perguntas dependentes no mesmo bloco**
2. Perguntas independentes agrupadas: máximo 3, apenas se claramente independentes
3. Sempre oferecer opções estruturadas quando o conjunto de respostas é finito
4. Aguardar resposta antes de avançar à próxima pergunta ou fase
5. Registrar resposta recebida antes de processar — nunca assumir

## Skills SSPDD Específicas

### /spdd-canvas
- **Trigger:** final de `/techspec` (automático) ou `sspdd generate canvas`
- **Input:** PRD + TechSpec de uma feature
- **Output:** REASONS Canvas em `docs/spdd/`
- **Regra:** canvas gerado ≥ 85% do conteúdo preenchido — nunca emitir canvas parcial

### /spdd-sync  
- **Trigger:** pós-implementação quando `sspdd sync` detecta divergência
- **Input:** git diff do código + canvas vigente
- **Output:** canvas atualizado + entrada em `docs/spdd/[feature]-deviations.md`
- **Regra:** toda divergência é registrada, mesmo se corrigida na mesma sessão
