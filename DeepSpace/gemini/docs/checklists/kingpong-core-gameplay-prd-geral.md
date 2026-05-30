# Checklist de Qualidade — KingPong Core Gameplay — Geral

**PRD:** [docs/prd/kingpong-core-gameplay-prd.md]
**Gerado em:** 29/05/2026
**Domínio:** Qualidade de Requisitos (Geral)
**Audiência:** Autor / Revisor

> **Objetivo**: validar a qualidade da *escrita* dos requisitos, não a implementação.
> Cada item é um "teste unitário" para o PRD: verifica completude, clareza, consistência e mensurabilidade.

---

## Completude

- [x] CHK001 — Os detalhes técnicos do "efeito CRT" (scanlines, flicker, glow) estão especificados? `[Completude, Ref §RF-001]`
- [x] CHK002 — Existe definição para o estado de "Pausa" ou interrupção do gameplay (ex: chamada telefônica)? `[Completude, Gap]`
- [x] CHK003 — O comportamento inicial da bola (ângulo de saída, velocidade inicial) está definido para o início de cada vida? `[Completude, Gap]`
- [x] CHK004 — A ordem de renderização (Z-index) entre Bola, Paddle e Goal está especificada para quando houver sobreposição? `[Completude, Ref §RF-004]`
- [x] CHK005 — Existe requisito para o comportamento do jogo em diferentes proporções de tela (Aspect Ratio)? `[Completude, Ref §RF-001]`
- [x] CHK019 — As dimensões físicas do paddle (largura/altura) e da bolinha (raio) são relativas ao tamanho da tela ou fixas em pixels? `[Completude, Ref §P8, §P10]`
- [x] CHK023 — O tamanho exato ou relativo da bolinha está especificado (já que o Goal depende matematicamente dele para ter 3x a largura)? `[Completude, Ref §P10]`
- [x] CHK024 — A interface do botão/modal "Iniciar" possui definições de posicionamento e cor ou segue um padrão implícito? `[Completude, Ref §P11]`

## Clareza

- [x] CHK006 — O termo "preto ligeiramente mais claro" está quantificado com um código de cor (ex: HEX ou RGB)? `[Clareza, Ref §P6]`
- [x] CHK007 — A "variação mais acentuada" no ângulo de rebatimento está definida com valores numéricos ou fórmula matemática? `[Clareza, Ref §P4, §RF-003]`
- [x] CHK008 — Os critérios de aceite de todos os requisitos funcionais seguem estritamente o formato Dado/Quando/Então? `[Clareza, Ref §3]`
- [x] CHK009 — A cor da bolinha está explicitamente definida (assume-se verde, mas não consta no texto)? `[Clareza, Ref §P6]`
- [x] CHK021 — O "verde-radioativo" recém-adicionado foi especificado com um código de cor exato (ex: HEX #39FF14)? `[Clareza, Ref §P6]`

## Consistência

- [x] CHK010 — A terminologia para a área de pontuação ("goal") é uniforme em todo o documento? `[Consistência, Ref §RF-004]`
- [x] CHK011 — A regra de "3x a largura da bola" no Goal é consistente com a descrição de colisão no topo central? `[Consistência, Ref §RN-003]`

## Mensurabilidade

- [x] CHK012 — A meta de latência de toque (< 16ms) possui uma metodologia de medição definida para dispositivos reais? `[Mensurabilidade, Ref §RNF-001]`
- [x] CHK013 — O RNF de performance em dispositivos low-end define quais modelos de referência ou especificações de hardware (ex: 2GB RAM)? `[Mensurabilidade, Ref §RNF-002]`
- [x] CHK014 — O critério de aceite para o sistema de vidas permite verificação objetiva de falha (ex: o que acontece exatamente no pixel do limite inferior)? `[Mensurabilidade, Ref §RF-005]`

## Cobertura de Cenários

- [x] CHK015 — Existe especificação para o cenário de rebatimento simultâneo (ex: bola atinge canto entre paddle e parede)? `[Cobertura, Ref §P12]`
- [x] CHK016 — O comportamento do botão "Reiniciar" cobre a limpeza de estado de memória além da UI? `[Cobertura, Ref §RF-005]`
- [x] CHK020 — Existe tratamento para evitar que o ângulo aleatório inicial lance a bola diretamente para a área de morte (limite inferior) sem tempo de reação? `[Cobertura, Ref §P5]`
- [x] CHK022 — O comportamento do jogo caso a bola fique rebatendo horizontalmente de forma contínua entre as paredes laterais está coberto? `[Cobertura, Ref §RF-003]`

## Rastreabilidade

- [x] CHK017 — Cada Requisito Funcional possui um ID único e sequencial? `[Rastreabilidade, Ref §3]`
- [x] CHK018 — As Regras de Negócio (RN) estão vinculadas aos seus respectivos Requisitos Funcionais (RF)? `[Rastreabilidade, Ref §5]`

---

## Itens marcados (sessão atual)

> Todos os 24 itens de qualidade foram verificados e atendidos no PRD v1.0.

---

## Histórico

| Data | Itens adicionados | Total acumulado |
|------|------------------|-----------------|
| 29/05/2026 | CHK001–CHK018 | 18 |
| 29/05/2026 | CHK019–CHK022 | 22 |
| 29/05/2026 | CHK023–CHK024 | 24 |
