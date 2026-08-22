# Integração SPDD — SSPDD Framework
_Atualizado em: 2026-08-22_

> Arquivo adicional (além dos 9 padrão) específico ao SSPDD.
> Documenta como o REASONS Canvas se integra ao pipeline SDD.

## O que é o REASONS Canvas

Um artefato de prompt estruturado — não documentação, mas **instrução executável** para a fase de implementação. Gerado automaticamente a partir do PRD + TechSpec, serve como "contrato de design" que a IA deve seguir ao implementar.

**Princípio central:** quando implementação diverge do canvas, corrija o canvas primeiro — depois atualize o código.

## Posição no Pipeline

```
/techspec  →  /spdd-canvas  →  /tasks  →  /implement (usa canvas)
                  ↓
          docs/spdd/[feature]-canvas.md
```

O `/spdd-canvas` é executado automaticamente ao final de `/techspec`. O usuário pode re-executar se o TechSpec for atualizado.

## Estrutura do REASONS Canvas

```markdown
# REASONS Canvas — {{FEATURE_NAME}}
_Gerado em: {{DATE}} | Baseado em: PRD v{{PRD_VERSION}} + TechSpec v{{TECHSPEC_VERSION}}_

## R — Requirements (Requisitos)
{{OBJETIVOS_DE_NEGOCIO}}
{{SCOPE_IN_OUT}}

## E — Entities (Entidades)
{{DIAGRAMA_MERMAID_DOMINIO}}

## A — Approach (Abordagem)
{{ESTRATEGIA_DE_SOLUCAO}}
{{TRADEOFFS}}

## S — Structure (Estrutura)
{{ARQUITETURA}}
{{DEPENDENCIAS}}

## O — Operations (Operações)
{{LISTA_TASKS_ORDENADA}}

## N — Norms (Normas)
{{PADROES_DE_CODIGO_RELEVANTES}}
{{CONVENCOES_ESPECIFICAS}}

## S — Safeguards (Guardrails)
{{RESTRICOES}}
{{O_QUE_NAO_FAZER}}
```

## Regras de Geração

1. **Completude mínima:** todas as 7 dimensões devem ter conteúdo — nenhuma pode ser vazia ou "N/A" sem justificativa
2. **Rastreabilidade:** cada item em R deve referenciar um RF-xxx do PRD; cada item em O deve referenciar uma TASK-xxx
3. **Norms seletivas:** copiar apenas guidelines relevantes à feature — não incluir o arquivo inteiro de guidelines
4. **Safeguards ativos:** redigir como proibições concretas ("NÃO usar X", "NUNCA Y") — não como sugestões

## Versionamento do Canvas

| Evento | Ação |
|--------|------|
| TechSpec atualizado | Re-executar `/spdd-canvas` → nova versão do canvas |
| Código diverge do canvas | Executar `/spdd-sync` → canvas atualizado + registro em deviations.md |
| Feature concluída | Canvas arquivado em `docs/spdd/archive/` |

## /spdd-sync — Detecção de Divergência

O comando `sspdd sync` compara:
- Código atual (git diff desde última sincronização)
- Canvas vigente (`docs/spdd/[feature]-canvas.md`)

Detecta divergências em:
- **Entities:** nova entidade no código não está no canvas
- **Structure:** dependência adicionada sem constar em S
- **Operations:** task implementada diferente do que O especifica
- **Safeguards:** violação de restrição documentada

Para cada divergência encontrada:
1. Apresenta divergência ao usuário
2. Pergunta: "Corrigir canvas para refletir realidade?" ou "Reverter código para seguir canvas?"
3. Executa ação e registra em `docs/spdd/[feature]-deviations.md`

## Canvas como Contexto de Implementação

Ao executar `/implement TASK-xxx`, a skill deve:
1. Ler o REASONS Canvas da feature
2. Usar as dimensões N (Norms) e S (Safeguards) como restrições ativas
3. Verificar que a implementação satisfaz os critérios em R (Requirements)
4. Após implementação, sugerir execução de `sspdd sync` para verificar aderência

## Geração por `sspdd generate`

```bash
sspdd generate canvas --feature auth-login
# Lê: docs/prd/auth-login-prd.md + docs/techspec/api-auth-login-techspec.md
# Gera: docs/spdd/auth-login-canvas.md
# Usa:  .agents/skills/spdd-canvas/templates/canvas-template.md
```

O CLI abstrai a invocação manual de `/spdd-canvas` — equivalente em resultado.
