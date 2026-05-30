# PRD: KingPong — Feature 1: Tela de Jogo (Núcleo Jogável)

**Versão:** 1.0
**Data:** 2026-05-29
**Autor:** Thiago Cavalcante
**Status:** Draft
**Próxima revisão:** 2026-06-05

---

## Clarificações

### Sessão 2026-05-30
- P1: Biblioteca de animação/física → Reanimated 3 (worklet-based, UI thread)
- P2: Velocidade inicial da bolinha → 20 px/s; constante `INITIAL_BALL_SPEED = 20` para calibração posterior
- P3: Dimensão da goal zone → largura = 3× diâmetro da bola (raio 10 px → diâmetro 20 px → **goal zone = 60 px de largura**)
- P4: Ângulo inicial da bolinha → aleatório, sempre apontando para baixo
- P5: Trigger de lançamento → overlay de pre-launch com vidas restantes + botão "continuar"; aparece no início da partida (3 vidas) e após cada perda de vida (N vidas restantes)

### Sessão 2026-05-30 (2ª rodada — CHK039–CHK046)
- P6: Largura do paddle → 60 px fixos (3× diâmetro da bolinha; raio = 10 px); §2.3 LAUNCHING corrigido: paddle bloqueado (não responsivo)
- P7: Rótulo do botão de lançamento → três estados: "iniciar" (1ª abertura do app), "continuar" (respawn após perda de vida), "reiniciar" (após game over + play again)
- P8: RF-008 adicionado ao §1.3 Escopo da Entrega
- P9: Estado inicial do app → LAUNCHING com paddle = 60 px e bolinha no topo
- P10: Posição de congelamento da bolinha → 10 px abaixo da borda inferior; overlay de pre-launch aparece imediatamente após o congelamento

---

## 1. Visão Geral

### 1.1 Contexto e Motivação

KingPong é um jogo mobile casual para Android e iOS desenvolvido com React Native CLI. Esta feature constitui o núcleo jogável completo do produto — sem ela, não há jogo. É a entrega de maior prioridade do roadmap e o pré-requisito para todas as features subsequentes (menu, ranking, conquistas).

A mecânica central combina elementos de pong clássico (controle de paddle, física de rebote) com um objetivo diferenciado: uma goal zone central que recompensa o jogador com pontos ao ser atravessada pela bolinha. A dificuldade é progressiva — a velocidade da bola aumenta com a pontuação e com cada rebate no paddle, garantindo escalada natural de desafio sem necessidade de níveis explícitos.

### 1.2 Objetivo

Este projeto tem como objetivo entregar o núcleo jogável completo do KingPong — uma partida funcional, responsiva e visualmente coesa — para que o jogador possa jogar sessões completas (do lançamento da bola até o game over), com mecânica de pontuação e vidas operacional, como base para todas as features futuras do produto.

### 1.3 Escopo da Entrega

**Em escopo (IN):**
- Tela de jogo completa (header, área de jogo, footer de controle)
- Paddle verde controlado por arrasto analógico no footer
- Física da bolinha: movimento, colisões com bordas e paddle
- Goal zone central com lógica de pass-through e marcação de ponto
- Dificuldade progressiva via aumento de velocidade da bola
- Sistema de vidas (3 fixas, não recuperáveis)
- HUD: pontuação e vidas visíveis durante a partida
- Estado de game over com pontuação final e reinício inline
- Overlay de pre-launch (RF-008): confirma lançamento/relançamento da bolinha com feedback de vidas

**Fora do escopo (OUT):**
- Integrações com SDKs ou APIs externas (AdMob, Firebase, etc.) — fora por decisão de escopo do MVP
- Tela de menu / splash screen — feature separada
- Sistema de ranking com persistência em SQLite — feature separada
- Efeitos sonoros e trilha sonora — não incluídos nesta entrega
- Progressão de dificuldade via diminuição do paddle — tamanho fixo nesta versão

---

## 2. Usuários e Stakeholders

### 2.1 Personas

| Persona | Perfil | Necessidades Principais | Critério de Sucesso |
|---------|--------|------------------------|---------------------|
| Jogador casual mobile | Adulto/jovem adulto, joga em momentos de pausa (transporte, espera). Espera resposta imediata ao toque e feedback visual claro. | Controlar a barra com precisão, entender o objetivo rapidamente, sentir progressão de dificuldade | Consegue jogar uma partida completa sem instrução prévia; sente o jogo responsivo e justo |

### 2.2 Jornada do Usuário (alto nível)

**Antes:** o jogador abre o app e vê a tela de jogo com um overlay de pre-launch exibindo 3 vidas e um botão "iniciar". Não há menu intermediário nesta entrega.

**Durante:** a bolinha é lançada do topo. O jogador arrasta o dedo no footer para posicionar o paddle e interceptar a bola. Ao dirigir a bola através da goal zone central, acumula pontos. A cada rebate no paddle e a cada ponto marcado, a bola fica ligeiramente mais rápida. O jogador gerencia três vidas — perder a bola pela parte inferior custa uma vida. A sessão termina ao perder a terceira vida.

**Depois:** a tela de game over exibe a pontuação final. O jogador toca "play again" e uma nova partida começa imediatamente na mesma tela.

### 2.3 Estado do Game Loop

| Estado | Descrição | Origem | Destino |
|--------|-----------|--------|---------|
| `LAUNCHING` | Overlay de pre-launch ativo; bolinha estacionária no topo; **paddle bloqueado** (60 px); botão: "iniciar" / "continuar" / "reiniciar" | Abertura do app (1ª vez) · `LIFE_LOST` (vidas ≥ 1) · `GAME_OVER` → "play again" | Toque no botão → `PLAYING` |
| `PLAYING` | Bolinha em movimento; paddle responsivo (60 px); HUD atualizado | `LAUNCHING` → toque no botão | Bolinha cruza borda inferior → `LIFE_LOST` |
| `LIFE_LOST` | Bolinha congela 10 px abaixo da borda; vida decrementada; transição imediata | `PLAYING` → evento de borda inferior | vidas ≥ 1 → `LAUNCHING`; vidas = 0 → `GAME_OVER` |
| `GAME_OVER` | Overlay de game over ativo; pontuação final exibida; bolinha e paddle congelados | `LIFE_LOST` (vidas = 0) | Toque em "play again" → reset completo → `LAUNCHING` ("reiniciar") |

### 2.4 Stakeholders

| Stakeholder | Papel | Interesse no Projeto |
|-------------|-------|---------------------|
| Thiago Cavalcante | Developer & Product Owner | Entregar um núcleo jogável funcional como base do produto |

---

## 3. Requisitos Funcionais

> Cada RF tem identificador único, descrição clara e critérios de aceite no formato Dado/Quando/Então.

---

### RF-001: Estrutura Visual da Tela de Jogo

**Prioridade:** Must Have
**Persona:** Jogador casual mobile

**Descrição:** A tela de jogo é composta por três regiões verticais distintas: (1) **Header** — exibe o nome "KingPong" centralizado em texto verde estilo CRT (phosphor green) sobre fundo preto levemente mais claro do que a área de jogo; (2) **Área de jogo** — fundo preto escuro onde ocorre todo o gameplay; (3) **Footer** — zona de controle touch do paddle, visualmente diferenciada da área de jogo.

**Critérios de Aceite:**
- [ ] Dado que o app é iniciado, quando a tela de jogo é renderizada, então o header exibe "KingPong" centralizado com fonte de estilo CRT em verde
- [ ] Dado que o jogo está ativo, quando a tela é observada, então o fundo do header é visivelmente mais claro do que o fundo da área de jogo (ambos tons de preto/cinza muito escuro)
- [ ] Dado que o jogo está ativo, quando a tela é observada, então header, área de jogo e footer são visualmente distintos e não se sobrepõem
- [ ] Dado que o dispositivo tem diferentes tamanhos de tela em modo portrait, quando o layout é renderizado, então as três regiões se adaptam proporcionalmente sem sobreposição de elementos
- [ ] Dado que o dispositivo é rotacionado para landscape, quando a orientação muda, então o app permanece em portrait (orientação bloqueada via configuração nativa)

**Fluxo de Erro:**
- [ ] Dado que a fonte CRT não carrega, quando o texto é renderizado, então o nome "KingPong" é exibido em fonte fallback, mantendo a cor verde

**Observações:** As proporções exatas (height) de cada região são decisão do techspec/implementação. A cor verde CRT de referência é aproximadamente `#00FF41` (phosphor green), mas a tonalidade exata será definida no techspec visual.

---

### RF-002: Controle Analógico do Paddle

**Prioridade:** Must Have
**Persona:** Jogador casual mobile

**Descrição:** O footer da tela funciona como zona de controle touch. O usuário arrasta o dedo horizontalmente no footer para mover o paddle verde dentro da área de jogo. O movimento do paddle é proporcional ao deslocamento do dedo (analógico), não a um ponto absoluto da tela. O paddle não ultrapassa as bordas laterais da área de jogo. **Dimensão:** o paddle tem largura fixa de 60 px (3× o diâmetro da bolinha; raio = 10 px → diâmetro = 20 px) durante toda a partida.

**Critérios de Aceite:**
- [ ] Dado que o jogo está ativo, quando o usuário inicia um arrasto no footer para a direita, então o paddle se move para a direita proporcionalmente ao deslocamento do dedo
- [ ] Dado que o jogo está ativo, quando o usuário inicia um arrasto no footer para a esquerda, então o paddle se move para a esquerda proporcionalmente ao deslocamento do dedo
- [ ] Dado que o paddle está na borda lateral direita da área de jogo, quando o usuário arrasta para a direita, então o paddle permanece na borda sem ultrapassá-la
- [ ] Dado que o paddle está na borda lateral esquerda da área de jogo, quando o usuário arrasta para a esquerda, então o paddle permanece na borda sem ultrapassá-la
- [ ] Dado que o usuário levanta o dedo do footer, quando o toque é encerrado, então o paddle permanece na última posição sem movimento adicional
- [ ] Dado que múltiplos toques ocorrem no footer, quando apenas um é ativo, então o controle usa o primeiro toque registrado (single-touch)

- [ ] Dado que qualquer overlay está ativo (`LAUNCHING` ou `GAME_OVER`), quando o usuário arrasta o dedo no footer, então o paddle não responde ao gesto (paddle bloqueado)
- [ ] Dado que uma nova partida é iniciada (ou reiniciada via "play again"), quando o paddle é posicionado, então sua largura é de 60 px e está centralizado na área de jogo

**Fluxo de Erro:**
- [ ] Dado que o toque começa fora do footer e entra nele, quando o gesto é detectado, então o paddle não responde (apenas toques iniciados no footer são válidos)

**Observações:** A sensibilidade de movimento (razão px de paddle por px de arrasto) será calibrada no techspec. O controle deve ter latência ≤ 16ms para parecer imediato.

---

### RF-003: Mecânica da Bolinha — Movimento e Colisões

**Prioridade:** Must Have
**Persona:** Jogador casual mobile

**Descrição:** A bolinha inicia na região superior da área de jogo e se move em trajetória diagonal com ângulo inicial definido. Ela rebate ao contato com as bordas lateral esquerda, lateral direita e superior. Ao contato com o paddle, rebate para cima com variação angular conforme o ponto de impacto. Se atingir a borda inferior, o jogador perde 1 vida. A velocidade da bolinha aumenta progressivamente: a cada ponto marcado via goal zone e a cada rebate no paddle. **Terminologia:** "velocidade base" = `INITIAL_BALL_SPEED` (valor de reset após perda de vida); "velocidade atual" = valor acumulado durante a jogada.

**Critérios de Aceite:**
- [ ] Dado que o overlay de pre-launch está ativo e o jogador toca o botão de lançamento ("iniciar", "continuar" ou "reiniciar"), quando o lançamento é confirmado, então a bolinha parte da região superior da área de jogo com ângulo inicial sorteado aleatoriamente no intervalo [`BALL_LAUNCH_ANGLE_MIN`, `BALL_LAUNCH_ANGLE_MAX`] = [30°, 150°] medidos a partir do eixo horizontal positivo (0° = direita, 90° = baixo) — sempre descendente
- [ ] Dado que uma partida inicia, quando a bolinha é lançada, então a velocidade inicial é exatamente `INITIAL_BALL_SPEED` (padrão: 20 px/s)
- [ ] Dado que a bolinha está em movimento, quando ela toca a borda lateral (esquerda ou direita), então o componente horizontal da velocidade é invertido (rebote físico)
- [ ] Dado que a bolinha está em movimento, quando ela toca a borda superior, então o componente vertical da velocidade é invertido (rebote físico)
- [ ] Dado que a bolinha está em movimento, quando ela colide com o paddle, então a direção vertical é invertida e o ângulo resultante varia conforme o ponto de contato: centro do paddle → `BALL_BOUNCE_ANGLE_CENTER` (quase reto), extremidades → `BALL_BOUNCE_ANGLE_EDGE` (mais agudo/rasante); valores definidos no techspec
- [ ] Dado que a bolinha colide com o paddle, quando o rebate ocorre, então a velocidade da bolinha é incrementada em um valor fixo definido no techspec
- [ ] Dado que um ponto é marcado via goal zone, quando a pontuação é incrementada, então a velocidade da bolinha é incrementada em um valor fixo definido no techspec
- [ ] Dado que a bolinha cruza a borda inferior da área de jogo, quando o evento é detectado, então a bolinha congela exatamente 10 px abaixo da borda inferior e 1 vida é decrementada — o overlay de pre-launch aparece imediatamente e o estado seguinte é determinado por RF-005
- [ ] Dado que o overlay de pre-launch está ativo, quando o jogador toca o botão de lançamento, então a bolinha é removida da posição de congelamento e reiniciada no topo com a velocidade base (`INITIAL_BALL_SPEED`)

- [ ] Dado que a bolinha está em movimento, quando ela toca simultaneamente a borda lateral e a borda superior (colisão de canto), então ambos os componentes de velocidade são invertidos
- [ ] Dado que qualquer overlay está ativo (`LAUNCHING` ou `GAME_OVER`), quando o estado de jogo é observado, então a bolinha está estacionária e nenhum cálculo de movimento é executado

**Fluxo de Erro:**
- [ ] Dado que a bolinha acelera indefinidamente, quando a velocidade atinge `BALL_SPEED_MAX`, então a velocidade para de aumentar (sem ultrapassar o cap)

**Observações:** A implementação usa **Reanimated 3** (worklet-based, UI thread) para garantir 60 FPS. A velocidade inicial é definida por `INITIAL_BALL_SPEED = 20` (px/s). Os valores das constantes a seguir serão calibrados no techspec: `BALL_SPEED_INCREMENT_PADDLE` (incremento por rebate no paddle), `BALL_SPEED_INCREMENT_GOAL` (incremento por ponto na goal zone), `BALL_SPEED_MAX` (cap de velocidade). A bolinha não pode "tunelar" — detecção de colisão deve ser contínua (swept detection ou subdivisão de steps). Todas as referências a "borda lateral", "borda superior" e "borda inferior" neste RF referem-se aos limites da **área de jogo**, não às bordas do dispositivo.

---

### RF-004: Goal Zone — Marcação de Pontos

**Prioridade:** Must Have
**Persona:** Jogador casual mobile

**Descrição:** Existe uma área retangular centralizada na área de jogo denominada goal zone. Quando a bolinha atravessa (pass-through) a goal zone, o jogador recebe +1 ponto. A bola não rebate ao contato com a goal zone — ela passa livremente. A goal zone é visível durante todo o jogo e não tem feedback visual próprio ao marcar ponto (apenas o HUD atualiza).

**Critérios de Aceite:**
- [ ] Dado que o jogo está ativo, quando a tela de jogo é exibida, então a goal zone está visível como uma área demarcada no centro da área de jogo com largura de 60 px
- [ ] Dado que a bolinha está em movimento, quando qualquer parte de seu hitbox intersecciona a goal zone (interseção parcial ou total), então a pontuação é incrementada em +1 e o HUD atualiza imediatamente
- [ ] Dado que a bolinha atravessa a goal zone, quando o ponto é marcado, então a trajetória da bolinha não é alterada (pass-through sem rebate)
- [ ] Dado que a bolinha permanece dentro da goal zone por múltiplos frames, quando ela ainda não saiu completamente, então o ponto é marcado apenas uma vez por travessia

**Fluxo de Erro:**
- [ ] Dado que a bolinha se move em alta velocidade e não intersecciona a goal zone em um frame específico, quando o cálculo de posição é feito, então a detecção usa o mesmo mecanismo de swept detection do RF-003 para evitar falso negativo

**Observações:** A **largura da goal zone é 60 px** (3× o diâmetro da bolinha; raio = 10 px → diâmetro = 20 px). A altura da goal zone e sua posição vertical na área de jogo serão definidas no techspec. A marcação de ponto ocorre no **primeiro frame de interseção** (qualquer sobreposição de hitbox conta), e apenas uma vez por travessia completa (entrada → saída).

---

### RF-005: Sistema de Vidas

**Prioridade:** Must Have
**Persona:** Jogador casual mobile

**Descrição:** O jogador inicia cada partida com 3 vidas. Vidas não são recuperadas durante a partida — apenas diminuem. A cada vez que a bolinha cruza a borda inferior da área de jogo, 1 vida é perdida. A bolinha reinicia do topo após a perda. Quando o contador de vidas chega a 0, o estado de game over é ativado.

**Critérios de Aceite:**
- [ ] Dado que uma nova partida é iniciada, quando o estado de jogo é inicializado, então o contador de vidas é definido como 3
- [ ] Dado que a bolinha cruza a borda inferior, quando o evento é detectado, então o contador de vidas é decrementado em 1
- [ ] Dado que o contador de vidas é decrementado, quando o novo valor é ≥ 1, então o overlay de pre-launch é ativado com botão "continuar" (ver RF-008)
- [ ] Dado que o contador de vidas é decrementado, quando o novo valor chega a 0, então o estado de game over é ativado imediatamente (sem exibir overlay de pre-launch)
- [ ] Dado que o jogo está ativo, quando o HUD é observado, então o número atual de vidas é exibido e reflete o estado corrente

**Fluxo de Erro:**
- [ ] Dado que múltiplos eventos de perda de vida ocorrem no mesmo frame, quando detectados, então apenas 1 vida é decrementada por evento (sem duplo decremento)

---

### RF-006: Game Over e Reinício

**Prioridade:** Must Have
**Persona:** Jogador casual mobile

**Descrição:** Quando o jogador perde a terceira vida, um overlay de game over é exibido sobre a tela de jogo (sem navegação para outra tela). O overlay exibe a pontuação final da sessão e um botão/ação "play again". Ao acionar o reinício, o estado do jogo é completamente resetado (pontuação → 0, vidas → 3, velocidade → base, posição do paddle → centro) e uma nova partida começa imediatamente.

**Critérios de Aceite:**
- [ ] Dado que o contador de vidas chega a 0, quando o game over é ativado, então um overlay é exibido sobre a área de jogo com a pontuação final da sessão
- [ ] Dado que o overlay de game over está ativo, quando o jogador o observa, então a pontuação final está visível em destaque
- [ ] Dado que o overlay de game over está ativo, quando o jogador observa, então existe uma ação clara de "play again" (botão ou texto interativo)
- [ ] Dado que o jogador aciona "play again", quando o reinício é processado, então pontuação → 0, vidas → 3, velocidade da bolinha → `INITIAL_BALL_SPEED`, paddle → posição central
- [ ] Dado que o reinício ocorre, quando o estado é resetado, então o overlay de pre-launch é ativado com vidas = 3 e botão "reiniciar" (ver RF-008)

**Fluxo de Erro:**
- [ ] Dado que o jogador toca a área de jogo durante o overlay, quando o toque ocorre, então o jogo não reinicia (apenas a ação "play again" reinicia)
- [ ] Dado que o jogador toca "play again" múltiplas vezes em rápida sucessão, quando toques duplicados são detectados, então o reinício é processado apenas uma vez (debounce)

**Observações:** O estilo visual do overlay segue a linguagem CRT verde do header. A pontuação máxima (high score) não é persistida nesta feature — apenas a pontuação da sessão atual é exibida. **Distinção de overlays:** o overlay de game over (`GAME_OVER`) exibe pontuação + "play again"; o overlay de pre-launch (`LAUNCHING`) exibe vidas restantes + "iniciar" (primeira partida ou após "play again") ou "continuar" (após perda de vida no meio da partida) — são componentes visuais semelhantes com conteúdo diferente.

---

### RF-007: HUD — Interface de Partida

**Prioridade:** Must Have
**Persona:** Jogador casual mobile

**Descrição:** Durante a partida, o HUD exibe continuamente a pontuação atual e o número de vidas restantes. Ambas as informações são atualizadas em tempo real conforme os eventos de jogo ocorrem. O HUD não interfere com o campo de visão da área de jogo.

**Critérios de Aceite:**
- [ ] Dado que o jogo está ativo, quando a tela de jogo é observada, então a pontuação atual é visível em todo momento
- [ ] Dado que um ponto é marcado, quando a pontuação é incrementada, então o valor no HUD é atualizado imediatamente no mesmo frame
- [ ] Dado que o jogo está ativo, quando a tela de jogo é observada, então o número de vidas restantes é visível em todo momento
- [ ] Dado que uma vida é perdida, quando o contador é decrementado, então o HUD reflete o novo valor imediatamente
- [ ] Dado que a pontuação ultrapassa 4 dígitos, quando o HUD renderiza o valor, então o layout não quebra (suporta pontuações altas)
- [ ] Dado que qualquer overlay está ativo (`LAUNCHING` ou `GAME_OVER`), quando a tela é observada, então o HUD (pontuação e vidas) permanece visível atrás do overlay

**Observações:** O posicionamento exato do HUD (topo da área de jogo, sobreposição no header, etc.) será definido no techspec visual. Estilo visual segue a linguagem CRT verde do projeto.

---

### RF-008: Overlay de Pre-Launch

**Prioridade:** Must Have
**Persona:** Jogador casual mobile

**Descrição:** Um overlay exibido sobre a área de jogo toda vez que o estado `LAUNCHING` é ativado — na primeira abertura do app, após cada perda de vida (respawn) e após "play again". Exibe as vidas restantes e um botão de confirmação cujo rótulo varia conforme a origem do estado. O overlay é o único mecanismo de lançamento/relançamento da bolinha.

**Critérios de Aceite:**
- [ ] Dado que o estado `LAUNCHING` é ativado, quando o overlay é renderizado, então exibe o número de vidas restantes
- [ ] Dado que o estado `LAUNCHING` é ativado pela primeira abertura do app (sem partida anterior na sessão), quando o overlay é renderizado, então o botão exibe o texto "iniciar"
- [ ] Dado que o estado `LAUNCHING` é ativado por perda de vida (origem: RF-005, vidas ≥ 1), quando o overlay é renderizado, então o botão exibe o texto "continuar"
- [ ] Dado que o estado `LAUNCHING` é ativado após "play again" (origem: RF-006), quando o overlay é renderizado, então o botão exibe o texto "reiniciar"
- [ ] Dado que o overlay está ativo, quando o jogador toca o botão de lançamento, então o overlay é fechado e o estado `PLAYING` é ativado (bolinha lançada conforme RF-003)
- [ ] Dado que o overlay está ativo, quando o jogador toca fora do botão, então o overlay permanece sem nenhuma ação
- [ ] Dado que o overlay está ativo, quando a tela é observada, então a bolinha está congelada no topo (conforme RF-003) e o paddle está bloqueado (conforme RF-002)

**Fluxo de Erro:**
- [ ] Dado que o estado `LAUNCHING` é ativado enquanto já está ativo (re-entrada inesperada), quando o estado é avaliado, então apenas um overlay é exibido por vez (sem sobreposição)

**Observações:** O overlay de pre-launch é distinto do overlay de game over (RF-006) — mesmo que visualmente similares, representam estados diferentes do game loop. Posicionamento, dimensões, transparência e animação de entrada/saída do overlay serão definidos no techspec visual. Comportamento ao retornar de background (app minimizado durante `LAUNCHING`) também será especificado no techspec.

---

## 4. Requisitos Não-Funcionais

### RNF-001: Performance de Renderização
- **Requisito:** O jogo deve manter 60 FPS estáveis durante toda a sessão de jogo, incluindo momentos de colisão, atualização de HUD e aceleração da bolinha
- **Métrica:** Frame rate medido via React Native Performance Monitor; para Reanimated 3, verificar também o thread da UI via Systrace (o worklet roda fora do JS thread)
- **Meta:** ≥ 60 FPS em 95% dos frames; sem drops abaixo de 30 FPS em dispositivos-alvo

### RNF-002: Latência de Input
- **Requisito:** O movimento do paddle deve responder ao toque com latência imperceptível ao jogador
- **Métrica:** Tempo entre evento de touch nativo e atualização visual do paddle no UI thread (Reanimated 3 — sem passar pelo JS thread)
- **Meta:** ≤ 16ms (1 frame a 60fps)

### RNF-003: Compatibilidade com Dispositivos Low-End
- **Requisito:** O jogo deve ser funcional e performático em dispositivos Android de entrada
- **Dispositivo de referência mínimo:** Android com 2GB RAM, CPU de 4 núcleos, Android 10+
- **Meta:** Manter ≥ 30 FPS estáveis no dispositivo de referência mínimo

### RNF-004: Escalabilidade de Pontuação
- **Requisito:** O sistema de pontuação não tem limite superior; deve suportar valores arbitrariamente altos
- **Meta:** Suportar pontuações até 999.999 sem overflow ou quebra de layout

### RNF-005: Segurança e Privacidade
- Não aplicável — jogo offline sem coleta de dados ou comunicação com servidores

### RNF-006: Observabilidade (Desenvolvimento)
- Logs de debug apenas em ambiente de desenvolvimento (`__DEV__` guard)
- Nenhum log em produção para eventos de gameplay

---

## 5. Regras de Negócio

| ID | Regra | Impacto em caso de violação | Origem | RF |
|----|-------|----------------------------|--------|----|
| RN-001 | O jogador inicia toda partida com exatamente 3 vidas | Desequilíbrio de dificuldade / experiência injusta | Decisão de design | RF-005 |
| RN-002 | Vidas não são recuperadas durante a partida — apenas diminuem | Remoção do desafio central | Decisão de design | RF-005 |
| RN-003 | A pontuação não tem teto — é ilimitada | Overflow / bug de display | Decisão de design | RF-004, RF-007 |
| RN-004 | A bolinha passa pela goal zone sem rebater (pass-through) | Mudança na dinâmica de jogo esperada | Decisão de design | RF-004 |
| RN-005 | A velocidade da bolinha aumenta a cada ponto marcado e a cada rebate no paddle | Ausência de progressão de dificuldade | Decisão de design | RF-003 |
| RN-006 | A velocidade da bolinha tem um valor máximo (`BALL_SPEED_MAX`) para impedir velocidades incontroláveis | Jogo injogável em pontuações altas | Decisão de design | RF-003 |
| RN-007 | O paddle tem largura fixa de **60 px** (3× diâmetro da bolinha) durante toda a partida | Mudança na dinâmica de jogo | Decisão de design | RF-002 |
| RN-008 | O reinício de partida reseta score → 0, vidas → 3, velocidade → `INITIAL_BALL_SPEED`, paddle → centro | Estado inconsistente entre partidas | Decisão de design | RF-006 |
| RN-009 | O rótulo do botão de lançamento varia por contexto: "iniciar" (1ª abertura), "continuar" (respawn), "reiniciar" (após game over) | UX inconsistente / confusão do jogador | Decisão de design | RF-008 |

---

## 6. Integrações e Dependências Externas

Nenhuma — o jogo é totalmente offline. Não há integração com APIs, SDKs analíticos, redes sociais ou serviços de terceiros nesta feature.

---

## 7. Premissas e Restrições

### Premissas
- O dispositivo suporta touch com precisão suficiente para controle analógico por arrasto
- **Reanimated 3** (worklet-based, UI thread) é suficiente para atingir 60 FPS com a física implementada — sem necessidade de engine externa
- A goal zone será visível suficientemente para o jogador identificá-la sem instrução prévia
- O app exibe o splash screen nativo do React Native durante a inicialização; ao terminar o carregamento, a tela de jogo é renderizada diretamente no estado `LAUNCHING` (sem tela de menu intermediária)

### Restrições
- Stack tecnológica fixada: React Native CLI com TypeScript, sem Expo, sem engine de jogo dedicada
- Sem backend — jogo totalmente offline
- Sem integrações com SDKs ou APIs externas nesta entrega
- Dispositivo mínimo suportado: Android 10+, iOS 14+
- **Orientação fixada em portrait-only** — landscape não é suportado; a orientação será bloqueada via configuração nativa (AndroidManifest / Info.plist)

---

## 8. Métricas de Sucesso

| KPI | Definição | Baseline Atual | Meta | Prazo | Como Medir |
|-----|-----------|----------------|------|-------|------------|
| Frame rate estável | % de frames a ≥ 60 FPS durante gameplay | — (produto novo) | ≥ 95% dos frames | Ao final da sprint | React Native Perf Monitor / Flipper |
| Latência de input do paddle | Tempo entre touch event e update visual | — | ≤ 16ms | Ao final da sprint | Cronometragem manual + Systrace |
| Jogabilidade percebida | Avaliação qualitativa: "o jogo parece responsivo e justo?" | — | Aprovação do PO após teste | Ao final da sprint | Teste manual pelo autor |

---

## 9. Riscos e Mitigações

| # | Risco | Probabilidade | Impacto | Mitigação | Responsável |
|---|-------|---------------|---------|-----------|-------------|
| 1 | ~~React Native Animated não atingir 60 FPS consistentemente para a física da bolinha~~ | ~~Média~~ | ~~Alto~~ | **Mitigado** — Reanimated 3 adotado (worklet-based, UI thread) | Thiago Cavalcante |
| 2 | Detecção de colisão por frame (não contínua) causar "tunneling" da bolinha em alta velocidade | Baixa | Alto | Implementar swept collision detection ou subdivisão de steps por frame | Thiago Cavalcante |

---

## 10. Questões em Aberto

| # | Questão | Impacto se não resolvida | Responsável | Prazo |
|---|---------|--------------------------|-------------|-------|
| 1 | ~~Qual biblioteca usar para a física/animação?~~ | — | — | **Resolvida 2026-05-30** → Reanimated 3 |
| 2 | ~~Velocidade inicial da bolinha?~~ | — | — | **Resolvida 2026-05-30** → `INITIAL_BALL_SPEED = 20 px/s`; incremento/cap como constantes no techspec |
| 3 | ~~Proporção da goal zone?~~ | — | — | **Resolvida 2026-05-30** → largura = 60 px (3× diâmetro); altura e posição Y no techspec |
| 4 | ~~Ângulo inicial fixo ou randomizado?~~ | — | — | **Resolvida 2026-05-30** → aleatório, sempre descendente |
| 5 | ~~Range angular exata do lançamento aleatório~~ | — | — | **Resolvida 2026-05-30** → `BALL_LAUNCH_ANGLE_MIN = 30°`, `BALL_LAUNCH_ANGLE_MAX = 150°` |
| 6 | ~~Ângulo mínimo/máximo do rebate nas extremidades do paddle~~ | — | — | **Resolvida 2026-05-30** → `BALL_BOUNCE_ANGLE_CENTER` e `BALL_BOUNCE_ANGLE_EDGE` como constantes no techspec |
| 7 | ~~Estado visual da bolinha no momento exato da perda de vida~~ | — | — | **Resolvida 2026-05-30** → bolinha congela no último frame visível (na borda inferior) |
| 8 | ~~Orientação de tela suportada (portrait-only ou também landscape)~~ | — | — | **Resolvida 2026-05-30** → portrait-only (bloqueado via nativa) |

---

## 11. Histórico de Revisões

| Versão | Data | Autor | Alterações |
|--------|------|-------|------------|
| 1.0 | 2026-05-29 | Thiago Cavalcante | Versão inicial |
| 1.1 | 2026-05-30 | Thiago Cavalcante | Clarificações: Reanimated 3, INITIAL_BALL_SPEED=20, goal zone 60px, ângulo aleatório descendente, overlay de pre-launch |
| 1.2 | 2026-05-30 | Thiago Cavalcante | Checklist: state machine §2.3, constantes nomeadas, colisão de canto, ball paused/paddle blocked em overlays, HUD em overlays, fix última vida→game over, RNFs Reanimated 3, refs RF em RN, premissa splash |
| 1.3 | 2026-05-30 | Thiago Cavalcante | Portrait-only, ângulo 30°-150°, BALL_BOUNCE_ANGLE_CENTER/EDGE, bolinha congela na borda, RF-008 overlay de pre-launch criado |
| 1.4 | 2026-05-30 | Thiago Cavalcante | Paddle=60px, 3 rótulos do botão (iniciar/continuar/reiniciar), congelamento 10px abaixo da borda, eixo angular explicitado, RF-008 no escopo, RN-009, CHK039/CHK041-CHK046 resolvidos |
