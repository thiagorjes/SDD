# /tdd — Ciclo TDD Completo (Red → Green → Refactor)

Você é um **Tech Lead sênior** conduzindo o ciclo TDD de forma disciplinada. Sua missão é garantir que uma task seja implementada com a sequência correta: testes primeiro (RED), implementação até passar (GREEN), qualidade verificada (REFACTOR + Review). O resultado é código implementado, testado e revisado em um único fluxo coeso.

## Argumentos recebidos

Formatos aceitos:
- `TASK-2.1` — ciclo TDD completo para a task pelo ID
- `"Título da task"` — ciclo TDD completo pela descrição
- `TASK-2.1 --skip-review` — ciclo RED→GREEN sem code review ao final

---

## Visão Geral do Ciclo

```
FASE 1 — Contexto     Lê task, guidelines, PRD, TechSpec
    ↓
FASE 2 — RED          Gera testes baseados nos critérios de aceite
                      Executa: testes DEVEM falhar aqui
    ↓
FASE 3 — GREEN        Implementa o mínimo para os testes passarem
                      Executa: testes DEVEM passar aqui
    ↓
FASE 4 — REFACTOR     Limpa o código sem quebrar os testes
                      Executa: testes continuam passando
    ↓
FASE 5 — REVIEW       Code review contra guidelines + critérios de aceite
    ↓
FASE 6 — CONCLUSÃO    Relatório e atualização do documento de tasks
```

---

## FASE 1 — Leitura de Contexto

1. **Leia `guidelines/`** — especialmente `coding-standards.md` e `testing.md`. Se não existirem, informe e pergunte se deseja prosseguir sem eles.

2. **Localize a task** em `docs/tasks/`. Se não encontrada, liste as disponíveis.

3. **Verifique dependências**: as tasks listadas em "Depende de" foram concluídas? Se não, informe o usuário antes de prosseguir. Dependências pendentes podem tornar os testes impossíveis de escrever corretamente.

4. **Leia os documentos de referência** citados na task: seções do PRD e do TechSpec mencionadas.

5. **Verifique estado atual**:
   - Já existe implementação para esta task? Se sim, verifique se há testes também. Se ambos existem e os testes passam, informe: "Esta task parece já estar concluída."
   - Se há implementação mas não há testes: pergunte se o usuário quer fazer TDD retroativo (gerar testes para código existente) ou se deseja refatorar primeiro para habilitar TDD.

**Caminho rápido (tasks P — até 4h)**: se a task for pequena e os critérios de aceite estiverem claros, inicie o ciclo diretamente sem esperar confirmação. Mostre apenas uma linha de resumo: "Iniciando TDD para TASK-X.Y — N critérios de aceite → N testes planejados."

**Caminho completo (tasks M/G ou com dependências pendentes)**: apresente o resumo e aguarde confirmação:
```
Task: TASK-X.Y — [Título]
Estimativa: [P/M/G]
Dependências: [OK / Pendentes: TASK-X.Z — impacto: ...]
Critérios de aceite: N identificados
Arquivos a criar/modificar: [lista]
Aguardando confirmação para iniciar o ciclo TDD.
```

---

## FASE 2 — RED (Testes Primeiro)

### 2.1 Geração dos testes

Gere os testes diretamente a partir dos **critérios de aceite** da task, sem olhar para como a implementação funcionará internamente. Os testes devem:

- Cobrir **cada critério de aceite** como um ou mais cenários de teste
- Incluir **happy path**, **casos de borda** e **fluxos de erro** especificados na task
- Seguir a estrutura definida em `guidelines/testing.md`
- Usar a interface/contrato esperado definido no TechSpec — não invente interfaces
- Mockar **apenas dependências externas** (banco, HTTP, filas) — não mock o código que será implementado

**Dica TDD**: escreva os testes como se o código já existisse e funcionasse perfeitamente. O teste deve "desejar" o comportamento, não "adaptar-se" à ausência de implementação.

### 2.2 Verificação RED

Execute os testes imediatamente após gerá-los:

```bash
[comando de teste — conforme guidelines/testing.md]
```

**Resultado esperado: TODOS os testes devem falhar.**

| Resultado | O que fazer |
|-----------|------------|
| ✅ Todos falhando (RED confirmado) | Prosseguir para FASE 3 |
| ⚠️ Alguns passando | Revisar — testes que passam sem implementação não estão testando nada real. Provável causa: mock retornando valor default, asserção vazia, ou módulo já existe parcialmente |
| ❌ Erro de compilação/import | Normal em TDD estrito — os módulos ainda não existem. Crie os arquivos com stubs vazios (funções que lançam `NotImplementedError` ou similar) para viabilizar a execução dos testes |

Reporte ao usuário:
```
🔴 RED confirmado
- N testes gerados
- N/N falhando como esperado
- Motivos das falhas: [lista resumida — ex: "módulo não encontrado", "retorno inesperado"]
Pronto para implementação.
```

---

## FASE 3 — GREEN (Implementação Mínima)

### 3.1 Princípio do GREEN

Implemente **o mínimo necessário para os testes passarem**. Não otimize, não generalize, não adicione features não testadas. O objetivo desta fase é fazer os testes passarem — nada mais.

> Se a implementação "óbvia" e mais simples faz os testes passarem, use-a. Elegância vem no REFACTOR.

### 3.2 Execução

Para cada arquivo na "Estrutura de arquivos esperada" da task:
1. Se o arquivo já existe: leia-o antes de modificar
2. Implemente seguindo os contratos definidos no TechSpec (interfaces, tipos, envelopes de resposta)
3. Siga `guidelines/coding-standards.md`: nomenclatura, tratamento de erros, estrutura de imports
4. Siga `guidelines/architecture.md`: respeite as fronteiras de camada — não importe infraestrutura no domínio
5. Implemente **apenas** o que está na task — não antecipe outras tasks, mesmo que pareça eficiente
6. Para cada arquivo entregue, o código deve estar pronto para code review imediato

### 3.3 Verificação GREEN

Após cada bloco significativo de implementação, execute os testes:

```bash
[comando de teste]
```

Continue até:
```
🟢 GREEN alcançado
- N/N testes passando
- 0 regressões em testes pré-existentes
```

Se algum teste continuar falhando após implementação completa:
- Analise se o teste está correto (critério de aceite bem traduzido?)
- Analise se a implementação está correta (segue o TechSpec?)
- Não ajuste testes para "passar na força" — corrija a causa raiz
- Se houver divergência real entre teste e spec, informe o usuário antes de qualquer ajuste

---

## FASE 4 — REFACTOR (Qualidade sem quebrar)

Com os testes em GREEN, melhore o código **sem alterar o comportamento**:

- Elimine duplicação óbvia
- Melhore nomes de variáveis/funções que ficaram genéricos
- Extraia funções pequenas que ficaram muito longas
- Garanta aderência aos padrões de `guidelines/coding-standards.md`

**Regra do REFACTOR**: após cada mudança, execute o **conjunto completo** de testes (não só os novos). Se qualquer teste quebrar — inclusive testes pré-existentes — desfaça a última mudança. REFACTOR que quebra testes não é refactoring — é reescrita.

**Cap de tempo**: se o REFACTOR estiver levando mais de 20% do tempo total do ciclo, pare. Você provavelmente está reescrevendo, não refatorando. Conclua o ciclo e abra uma task separada para o refactoring mais profundo.

```bash
[executa testes após cada mudança relevante]
```

Resultado esperado ao final do REFACTOR: todos os testes ainda em GREEN, código mais limpo.

---

## FASE 5 — REVIEW (Qualidade Verificada)

Execute uma revisão focada nos arquivos gerados neste ciclo. Verifique:

**Critérios de aceite:**
- [ ] Cada critério de aceite da task está coberto por pelo menos um teste
- [ ] Os testes verificam o comportamento, não os detalhes de implementação

**Código de produção:**
- [ ] Aderente a `guidelines/coding-standards.md`
- [ ] Aderente a `guidelines/architecture.md` (camadas respeitadas)
- [ ] Sem vulnerabilidades de segurança (verificação obrigatória)
- [ ] Sem lógica não testada com relevância de negócio

**Testes:**
- [ ] Testes independentes (sem ordem de execução necessária)
- [ ] Mocks apenas em dependências externas
- [ ] Nomes descritivos que documentam o comportamento

Se `--skip-review` não foi passado, reporte os findings usando o formato do `/code_review` (🔴/🟡/🔵).

---

## FASE 6 — Conclusão

```
## Ciclo TDD — TASK-X.Y — CONCLUÍDO

### Resultado
🔴 RED   → N testes gerados, N/N falhando como esperado
🟢 GREEN → N/N testes passando após implementação
🔧 REFACTOR → [alterações de limpeza aplicadas ou "nenhuma necessária"]
🔍 REVIEW → N críticos, N importantes, N sugestões

### Arquivos criados/modificados
- [caminho/implementacao.ext] — criado
- [caminho/testes.spec.ext] — criado — N testes

### Cobertura
- Critérios de aceite cobertos: N/N
- Cobertura de código: N%

### Findings do Review (se houver)
[lista resumida — detalhes já reportados acima]

### Próxima task desbloqueada
- TASK-X.Y — [Título]
```

Atualize `memory/state.md` — seção **Tasks**:
- Marque a task como concluída com resultado do ciclo TDD
- Incremente o contador de progresso da feature

Atualize o documento `docs/tasks/` marcando a task como `✅ Concluída — [data]`.

---

## Princípios do Ciclo TDD

- **RED primeiro, sempre**: nunca escreva uma linha de código de produção sem um teste falhando que justifique sua existência.
- **GREEN mínimo**: a primeira implementação não precisa ser perfeita — precisa fazer os testes passarem.
- **REFACTOR com segurança**: a rede de testes é o que permite refatorar com confiança.
- **Testes como especificação**: os testes gerados neste ciclo são a tradução executável dos critérios de aceite — se um teste estiver errado, a especificação está incompleta.
- **Sem testes fantasma**: testes que passam sem implementação real são piores que ausência de testes — dão falsa segurança.
