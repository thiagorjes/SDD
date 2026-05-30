# Checklist de Qualidade — KingPong Feature 1: Tela de Jogo — Geral

**PRD:** `docs/prd/kingpong-feature-1-prd.md` (v1.2)
**Gerado em:** 2026-05-30
**Domínio:** Geral
**Audiência:** Autor (gate formal antes do /techspec)

> **Objetivo**: validar a qualidade da *escrita* dos requisitos, não a implementação.
> Cada item é um "teste unitário" para o PRD: verifica completude, clareza, consistência e mensurabilidade.
> **Gate**: todos os itens devem estar marcados `[x]` antes de executar `/techspec`.

---

## Completude

- [x] CHK001 — O ciclo completo de estados do game loop (`pre-launch → playing → life_lost → pre-launch/game_over`) está mapeado em pelo menos um RF ou seção de fluxo? `[Completude, Gap]` → **resolvido**: tabela de estados adicionada em §2.3
- [x] CHK002 — O overlay de pre-launch (Clarificação P5) tem critérios de aceite consolidados em uma seção coesa ou RF dedicado, não dispersos entre RF-003, RF-005 e RF-006? `[Completude, Gap §RF-003, §RF-005, §RF-006]` → **resolvido**: RF-008 criado com todos os critérios do overlay
- [x] CHK003 — O RF-002 especifica o comportamento do controle do paddle durante os overlays (pre-launch e game over) — paddle responde ou fica bloqueado? `[Completude, Gap §RF-002]` → **resolvido**: critério adicionado a RF-002
- [x] CHK004 — O RF-003 ou RF-005 especifica explicitamente que a bolinha não se move enquanto qualquer overlay está ativo? `[Completude, Gap §RF-003]` → **resolvido**: critério adicionado a RF-003
- [x] CHK005 — A range angular exata do lançamento aleatório "descendente" está definida no PRD ou explicitamente adiada para o techspec com justificativa? `[Completude, Gap §RF-003]` → **resolvido**: `BALL_LAUNCH_ANGLE_MIN = 30°`, `BALL_LAUNCH_ANGLE_MAX = 150°`
- [x] CHK006 — O RF-007 (HUD) especifica se pontuação e vidas permanecem visíveis durante os overlays (pre-launch e game over)? `[Completude, Gap §RF-007]` → **resolvido**: critério adicionado a RF-007
- [x] CHK007 — Existe especificação ou premissa explícita sobre o estado visual que o usuário vê enquanto o app inicializa antes da tela de jogo? `[Completude, Gap §7]` → **resolvido**: premissa de splash nativo adicionada a §7
- [x] CHK008 — O incremento de velocidade por rebate no paddle e por ponto marcado está declarado como constante a ser definida no techspec (com nome de constante sugerido)? `[Completude §RF-003]` → **resolvido**: `BALL_SPEED_INCREMENT_PADDLE`, `BALL_SPEED_INCREMENT_GOAL` adicionados
- [x] CHK009 — O cap de velocidade máxima está declarado como constante a ser definida no techspec (com nome de constante sugerido)? `[Completude §RF-003]` → **resolvido**: `BALL_SPEED_MAX` adicionado

---

## Clareza

- [x] CHK010 — O RF-003 quantifica a variação angular do rebate no paddle (ex: ângulo mínimo e máximo nas extremidades vs. centro) ou adiou explicitamente para techspec? `[Clareza §RF-003]` → **resolvido**: `BALL_BOUNCE_ANGLE_CENTER` e `BALL_BOUNCE_ANGLE_EDGE` como constantes no techspec
- [x] CHK011 — "Proporcional ao deslocamento do dedo" no RF-002 está claramente marcado como razão de sensibilidade a calibrar no techspec? `[Clareza §RF-002]` → **satisfeito**: RF-002 obs já especifica
- [x] CHK012 — O RF-004 distingue claramente "primeiro frame de interseção" (entrada) de "completamente dentro" e "saída" para a lógica de marcação de ponto? `[Clareza §RF-004]` → **resolvido**: RF-004 critério e obs atualizados
- [x] CHK013 — O RF-003 distingue "velocidade base" (`INITIAL_BALL_SPEED`) de "velocidade acumulada durante a jogada" de forma não ambígua? `[Clareza §RF-003]` → **resolvido**: terminologia adicionada à descrição de RF-003
- [x] CHK014 — "Detecção tolerante a velocidades altas" no RF-004 descreve o mecanismo esperado (ex: swept detection) ou está explicitamente adiado para techspec? `[Clareza §RF-004]` → **resolvido**: RF-004 fluxo de erro referencia swept detection de RF-003
- [x] CHK015 — Os RFs que referenciam "borda lateral" e "borda inferior" deixam claro que se referem aos limites da área de jogo, não da tela do dispositivo? `[Clareza §RF-003]` → **resolvido**: nota adicionada às obs de RF-003
- [x] CHK016 — O RF-006 distingue claramente o overlay de pre-launch (exibido após "play again") do overlay de game over (sem sobreposição ou confusão entre os dois)? `[Clareza §RF-006]` → **resolvido**: distinção adicionada às obs de RF-006
- [x] CHK017 — O RF-005 e RF-006 usam terminologia consistente para o botão do overlay de pre-launch ("continuar" em RF-005 vs. "iniciar" em RF-006) ou justificam a diferença? `[Clareza §RF-005, §RF-006]` → **resolvido**: justificativa adicionada às obs de RF-006

---

## Consistência

- [x] CHK018 — A velocidade da bolinha ao reiniciar após perda de vida (RF-005) é consistente com a velocidade ao reiniciar via "play again" (RF-006) — ambas explicitamente usam `INITIAL_BALL_SPEED`? `[Consistência §RF-003, §RF-005, §RF-006]` → **satisfeito**
- [x] CHK019 — O RN-008 ("velocidade → base") é consistente com a constante `INITIAL_BALL_SPEED = 20` definida nas Clarificações P2? `[Consistência §RN-008, Clarificações P2]` → **resolvido**: RN-008 atualizado para `INITIAL_BALL_SPEED`
- [x] CHK020 — O RF-004 é internamente consistente: "marcação na entrada da zona" é compatível com "marcado apenas uma vez por travessia" em cenários de alta velocidade? `[Consistência §RF-004]` → **satisfeito**
- [x] CHK021 — A sequência de eventos em RF-003 (bolinha cruza borda inferior) e RF-005 (decremento de vida + overlay) está ordenada de forma consistente e sem ambiguidade de precedência? `[Consistência §RF-003, §RF-005]` → **resolvido**: RF-005 crit. 2 atualizado; RF-003 delega para RF-005
- [x] CHK022 — A premissa em §7 (Reanimated 3) é consistente com a Clarificação P1 e o Risco 1 marcado como mitigado em §9? `[Consistência §7, §9, Clarificações P1]` → **satisfeito**
- [x] CHK023 — O RF-005 e RF-006 são explicitamente consistentes sobre qual overlay aparece quando a **terceira** vida é perdida (game over, não pre-launch)? `[Consistência §RF-005, §RF-006]` → **resolvido**: RF-005 crit. 3 "novo valor ≥ 1 → overlay de pre-launch"; crit. 4 "novo valor = 0 → game over (sem overlay de pre-launch)"

---

## Mensurabilidade

- [x] CHK024 — O RNF-001 (≥60 FPS) tem método de medição especificado para o contexto de Reanimated 3 (worklet thread) — não apenas Flipper genérico? `[Mensurabilidade §RNF-001]` → **resolvido**: métrica atualizada com Systrace + UI thread
- [x] CHK025 — O RNF-002 (≤16ms de latência de input) tem método de verificação definido para implementação com Reanimated 3? `[Mensurabilidade §RNF-002]` → **resolvido**: métrica atualizada com UI thread sem JS bridge
- [x] CHK026 — A largura da goal zone (60px) tem critério de aceite verificável associado no RF-004 (ex: "a area demarcada tem largura de 60px")? `[Mensurabilidade §RF-004]` → **resolvido**: critério 1 de RF-004 atualizado com "60 px"
- [x] CHK027 — Os critérios de aceite do RF-003 que dependem de constantes (incrementos, cap) são verificáveis como requisito escrito, independentemente dos valores finais do techspec? `[Mensurabilidade §RF-003]` → **satisfeito**
- [x] CHK028 — O RNF-004 ("suportar pontuações até 999.999") está escrito como requisito verificável no PRD (não apenas como meta de implementação)? `[Mensurabilidade §RNF-004]` → **satisfeito**

---

## Cobertura de Cenários

- [x] CHK029 — O RF-003 cobre o cenário de colisão simultânea com borda lateral e borda superior (canto superior da área de jogo)? `[Cobertura, Borda §RF-003]` → **resolvido**: critério adicionado a RF-003
- [x] CHK030 — O RF-005 cobre o cenário de a bolinha atingir a borda inferior durante a transição para o overlay (ex: física pausada antes ou depois do evento de borda)? `[Cobertura, Borda §RF-005]` → **resolvido**: RF-003 crit. explicita que bolinha para ao entrar em estado LAUNCHING
- [x] CHK031 — O RF-004 cobre o cenário de a bolinha atravessar a goal zone em trajetória diagonal com interseção parcial (tangencia a borda da zona)? `[Cobertura, Borda §RF-004]` → **resolvido**: critério 1 de RF-004 atualizado com "qualquer parte de seu hitbox"
- [x] CHK032 — O RF-006 cobre o cenário de "play again" ser acionado múltiplas vezes em rápida sucessão (duplo toque)? `[Cobertura, Borda §RF-006]` → **resolvido**: fluxo de erro adicionado a RF-006
- [x] CHK033 — O RF-005 ou RF-003 especifica o estado visual da bolinha no momento exato da perda de vida (desaparece, congela, animação de saída)? `[Cobertura, Gap §RF-005]` → **resolvido**: bolinha congela no último frame visível (na borda inferior)
- [x] CHK034 — O RF-001 ou §7 especifica se o jogo suporta apenas modo portrait ou também landscape, para evitar ambiguidade no layout? `[Cobertura, Gap §RF-001]` → **resolvido**: portrait-only declarado em §7 Restrições e RF-001

---

## Rastreabilidade

- [x] CHK035 — Os critérios de aceite adicionados para o overlay de pre-launch (Clarificação P5) estão atribuídos explicitamente a RFs identificáveis (não apenas à seção de Clarificações)? `[Rastreabilidade, Clarificações P5]` → **satisfeito**: CAs em RF-003, RF-005, RF-006
- [x] CHK036 — As Regras de Negócio RN-001 a RN-008 têm referência cruzada para os RFs que as implementam? `[Rastreabilidade §5]` → **resolvido**: coluna RF adicionada à tabela §5
- [x] CHK037 — Todas as decisões das Clarificações P1–P5 estão refletidas nos RFs correspondentes (não apenas na seção de Clarificações, que é histórico)? `[Rastreabilidade, Clarificações P1–P5]` → **satisfeito**
- [x] CHK038 — A seção §10 (Questões em Aberto) marca explicitamente as constantes adiadas para techspec (incremento de velocidade, cap, altura da goal zone, range angular) como pendências rastreáveis? `[Rastreabilidade §10]` → **resolvido**: Q5–Q8 adicionadas a §10

---

---

## Completude — v1.3 (RF-008 e novos critérios)

- [x] CHK039 — RF-008 está listado explicitamente no §1.3 Escopo da Entrega como componente em escopo? `[Completude §1.3, §RF-008]` → **resolvido**: adicionado ao §1.3
- [x] CHK040 — RF-008 especifica posicionamento, dimensões e transparência do overlay ou adiou explicitamente para o techspec? `[Completude §RF-008]` → **resolvido**: RF-008 obs declara explicitamente deferral para o techspec visual
- [x] CHK041 — A tabela de estados (§2.3) cobre a origem do estado `LAUNCHING` na primeira abertura do app (antes de qualquer transição de jogo)? `[Completude §2.3]` → **resolvido**: §2.3 atualizado com "Abertura do app (1ª vez)"

---

## Clareza — v1.3

- [x] CHK042 — RF-003 critérios 1 e 9 referenciam o botão como `"continuar"`, mas RF-008 define `"iniciar"` para vidas = 3 — os dois são terminologicamente consistentes? `[Clareza §RF-003, §RF-008]` → **resolvido**: RF-003 usa "botão de lançamento" (genérico); RF-008 define 3 rótulos contextuais; RN-009 criada
- [x] CHK043 — `"logo abaixo"` (RF-003, posição de congelamento da bolinha na borda) está quantificado (ex: até N px) ou explicitamente adiado para o techspec? `[Clareza §RF-003]` → **resolvido**: 10 px abaixo da borda inferior
- [x] CHK044 — O intervalo [30°, 150°] em RF-003 define a direção do eixo de referência angular de forma inequívoca (ex: 0° = eixo horizontal apontando para a direita)? `[Clareza §RF-003]` → **resolvido**: adicionado "(0° = direita, 90° = baixo)"
- [x] CHK045 — A duração do congelamento da bolinha na borda antes do overlay de pre-launch ser exibido está especificada (imediato? após N ms?) ou explicitamente adiada para o techspec? `[Clareza §RF-003]` → **resolvido**: overlay aparece imediatamente após o congelamento

---

## Consistência — v1.3

- [x] CHK046 — A tabela de estados (§2.3) descreve `LAUNCHING` com "paddle responsivo" — isso é consistente com RF-002 e RF-008 que especificam paddle **bloqueado** durante `LAUNCHING`? `[Consistência §2.3, §RF-002, §RF-008]` → **resolvido**: §2.3 corrigido para "paddle bloqueado (60 px)"; largura do paddle (60px) adicionada ao RF-002 e RN-007
- [x] CHK047 — O critério de bolinha congelada durante overlays (RF-003) e o mesmo critério em RF-008 são mutuamente consistentes e a duplicação é intencional? `[Consistência §RF-003, §RF-008]` → **satisfeito**: ambos referenciam a mesma regra de perspectivas diferentes (física vs. overlay)

---

## Rastreabilidade — v1.3

- [x] CHK048 — RF-008 está referenciado na tabela de Regras de Negócio (§5) para as regras que governam o overlay de pre-launch? `[Rastreabilidade §5, §RF-008]` → **resolvido**: RN-009 criada com referência a RF-008

---

## Cobertura de Cenários — v1.3

- [x] CHK049 — RF-008 ou §7 endereça o comportamento quando o app vai para background e retorna enquanto no estado `LAUNCHING`? `[Cobertura §RF-008]` → **resolvido**: RF-008 obs declara deferral para techspec
- [x] CHK050 — O fluxo de erro de RF-008 ("overlay ativado múltiplas vezes em rápida sucessão — ex: respawn + play again no mesmo frame") descreve um cenário tecnicamente possível dado o game loop definido em §2.3? `[Clareza §RF-008]` → **resolvido**: descrição do fluxo de erro reescrita para "re-entrada inesperada no estado LAUNCHING" (cenário realista)

---

## Itens marcados (sessão atual)

> **Sessão 2026-05-30 (2ª rodada): 50/50 itens aprovados — gate formal APROVADO (PRD v1.4).**

---

## Histórico

| Data | Itens adicionados | Total acumulado | Aprovados |
|------|------------------|-----------------|-----------|
| 2026-05-30 | CHK001–CHK038 | 38 | 0 |
| 2026-05-30 | — | 38 | 33 (auto-resolvidos via PRD v1.2) |
| 2026-05-30 | — | 38 | **38/38 — gate aprovado (PRD v1.3)** |
| 2026-05-30 | CHK039–CHK050 | 50 | 39/50 (11 pendentes — PRD v1.3 adições) |
| 2026-05-30 | — | 50 | **50/50 — gate aprovado (PRD v1.4)** |
