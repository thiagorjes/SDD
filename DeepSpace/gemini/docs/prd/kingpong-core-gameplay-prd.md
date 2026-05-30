# PRD: KingPong Core Gameplay

**Versão:** 1.0
**Data:** 29/05/2026
**Autor:** thiago cavalcante
**Status:** Draft
**Próxima revisão:** 05/06/2026

---

## Clarificações

### Sessão 29/05/2026
- P1: Posição exata da área de goal → Topo da tela (fixo) e centralizado horizontalmente.
- P2: Hitbox de movimento do paddle → Qualquer arraste horizontal em qualquer lugar da tela move o paddle.
- P3: Reinício pós-Game Over → A tela de Game Over terá um botão explícito de "Reiniciar" para iniciar nova rodada.
- P4: Aceleração da bolinha → A velocidade e a direção da bolinha variam de acordo com a posição e ângulo de impacto no paddle (física de desvio/aceleração baseada na zona de contato).
- P5: Estado Inicial e Lançamento → O jogo inicia pausado. Um botão Iniciar (modal) inicia a rodada com a bola saindo a 20px/s em um ângulo aleatório (excluindo a direção direta do gol).
- P6: Cores e Z-Index → Background principal: `rgb(0,0,0)`. Header/Footer: `rgb(25,25,25)`. Elementos principais (bola, texto, paddle, goal): "verde-radioativo" (`#83e509`). Z-index: Bola fica visível *sobre* o Gol. Bola e Paddle *não se sobrepõem* (colidem).
- P7: Especificação do Efeito CRT → Scanline única: barra horizontal de 10px altura cobrindo a tela, verde-radioativo, com gradiente vertical (meio para bordas). Linhas fixas: espaçadas em 2px, espessura de 1px, verde-radioativo com 80% de transparência.
- P8: Detalhes Visuais e Físicos → Paddle ocupa 30% da largura da tela. Bola é lançada a 20% da altura a partir do topo e possui trava de ângulo mínimo (15 graus em relação à horizontal).
- P9: Layout Global → Header possui altura fixa de 50px e Footer (onde o paddle desliza) tem altura fixa de 200px. A Game Area ocupa todo o espaço restante.
- P10: Dimensões da Bola → A bolinha tem um raio fixo de 10px (largura total de 20px). O Goal terá exatos 60px de largura.
- P11: Estilização do Modal (Iniciar/Reiniciar) → Fundo escurecido tela toda, popup na cor do header/footer `rgb(25,25,25)`, botão transparente com borda e texto em `#83e509`.
- P12: Colisões Múltiplas → Se a bola colidir nos cantos (ex: teto e parede ao mesmo tempo), os dois vetores de direção invertem simultaneamente.

---

## 1. Visão Geral

### 1.1 Contexto e Motivação
A necessidade de validar a engine de colisão e a responsividade dos controles touch ("Paddle") em dispositivos móveis, além de ser uma oportunidade prática para aprender React Native e a metodologia SDD (Specification Driven Development). O desenvolvimento deste MVP atende a uma demanda de criação do núcleo do jogo com estética retrô (CRT).

### 1.2 Objetivo
Este projeto tem como objetivo desenvolver o MVP jogável do KingPong para usuários móveis de forma que garanta alta performance e aprendizado prático da stack de tecnologia e fluxo SDD dentro de uma sprint.

### 1.3 Escopo da Entrega

**Em escopo (IN):**
- Tela principal de jogo com estética CRT definida (`rgb(0,0,0)` e verde-radioativo `#83e509`).
- Movimentação do paddle via touch na base da tela (footer fixo em 200px).
- Física e movimentação da bolinha (lançamento aleatório a 20% do topo, raio fixo 10px).
- Sistema de colisão com bordas da tela e com o paddle (evitando sobreposição e bugs de loop).
- Sistema de pontuação contínua através de uma área de "gol" central no header (largura de 60px).
- Sistema de vidas (3) e estado de Game Over ao deixá-la cair na parte inferior da tela com botão modal de reinício.

**Fora do escopo (OUT):**
- Integrações com outros SDKs e APIs externas — o foco atual é 100% no motor local do jogo.

---

## 2. Usuários e Stakeholders

### 2.1 Personas

| Persona | Perfil | Necessidades Principais | Critério de Sucesso |
|---------|--------|------------------------|---------------------|
| Jogador Casual | Leigo em tecnologia, busca entretenimento rápido | Controles responsivos e jogo fluído | O paddle responde instantaneamente ao toque, sem atrasos perceptíveis |

### 2.2 Jornada do Usuário (alto nível)
O usuário abre o aplicativo e visualiza a tela em estado de pausa inicial através de um modal retrô. Após tocar em "Iniciar", ele imediatamente tem acesso à área de jogo interativa. Ao tocar e arrastar na base da tela, o usuário percebe o paddle acompanhando seu dedo. A bolinha desce de uma posição correspondente a 20% do topo da tela com ângulo aleatório. O usuário tenta rebatê-la para evitar que caia no fundo da tela (perdendo vida) e almeja direcioná-la para a área de gol no centro para acumular pontos de forma infinita, até perder suas 3 vidas. Após o Game Over, o usuário pode clicar em reiniciar no modal para começar de novo.

### 2.3 Stakeholders

| Stakeholder | Papel | Interesse no Projeto |
|-------------|-------|---------------------|
| Desenvolvedor | Criador e mantenedor | Aprendizado de React Native, SDD e física básica em JS |

---

## 3. Requisitos Funcionais

> Cada RF deve ter identificador único, descrição clara e critérios de aceite verificáveis no formato Dado/Quando/Então.

### RF-001: Renderização da Área de Jogo e Estética CRT
**Prioridade:** Must Have
**Persona:** Jogador Casual

**Descrição:** A tela deve renderizar a estética de um terminal antigo. O fundo da área de jogo é `rgb(0,0,0)`. O header tem altura fixa de 50px e o footer de 200px, ambos usando `rgb(25,25,25)`. A game area ocupa o restante da altura e 100% da largura. Textos e elementos principais usam "verde-radioativo" (`#83e509`). Os efeitos CRT englobam duas camadas sobrepostas:
1. Linhas fixas: cor `#83e509`, espaçadas por 2px, com 1px de espessura e 80% de transparência.
2. Scanline animada: Uma barra horizontal de 10px de altura atravessando o eixo Y da Game Area, cor `#83e509` com gradiente vertical atenuando para as bordas.

**Critérios de Aceite:**
- [ ] Dado que a tela do jogo foi carregada, quando renderizada, então o background principal deve ser `rgb(0,0,0)` e o header/footer `rgb(25,25,25)` com 50px e 200px respectivamente.
- [ ] Dado a camada visual, quando inspecionada, então deve exibir linhas finas (1px) espaçadas em 2px com 80% de transparência.
- [ ] Dado um erro de renderização, quando o componente falhar, então o aplicativo exibirá a tela de fallback padrão do projeto (Error Boundary).

### RF-002: Controle do Paddle e Colisões
**Prioridade:** Must Have
**Persona:** Jogador Casual

**Descrição:** Um componente de paddle (barra na cor `#83e509` ocupando 30% da largura da tela) posicionado no footer que segue o arrastar do dedo em qualquer parte da tela (controle horizontal relativo). Bola e Paddle operam em lógica de colisão estrita; *não* pode haver sobreposição (Z-index não se aplica entre eles pois não se cruzam graficamente).

**Critérios de Aceite:**
- [ ] Dado que o paddle está na tela, quando o usuário tocar e arrastar o dedo horizontalmente em qualquer lugar, então o paddle deve refletir esse movimento horizontal.
- [ ] Dado o limite da tela, quando o usuário tentar arrastar o paddle para fora das bordas laterais, então o paddle deve parar no limite da margem.
- [ ] Dado que a bola atinge o paddle, quando ocorre a física, então os componentes devem colidir perfeitamente em suas bordas, impedindo sobreposição de pixels.

### RF-003: Lançamento, Movimentação e Colisão da Bolinha
**Prioridade:** Must Have
**Persona:** Jogador Casual

**Descrição:** O aplicativo inicia em um estado "Pausado", exibindo um modal "Iniciar". Ao iniciar, a bolinha (`#83e509`, raio de 10px / largura total 20px) surge em uma posição correspondente a 20% da altura da área de jogo a partir do topo e é lançada a uma velocidade fixa (default: 20px/s) em um ângulo aleatório (sendo vedado direcionar diretamente para cima/gol). Durante o jogo, há colisão elástica simples nas paredes/teto (invertendo o vetor) e colisão com ângulo dinâmico ao atingir o paddle. A bolinha deve manter um ângulo mínimo de 15 graus com a horizontal em todos os rebatimentos para evitar loops infinitos nas paredes laterais. Colisões simultâneas nos cantos devem inverter ambos os vetores (X e Y).

**Critérios de Aceite:**
- [ ] Dado que o aplicativo acabou de ser aberto, quando terminar o loading, então deve exibir o modal de "Iniciar" com a física pausada.
- [ ] Dado o clique em "Iniciar", quando a rodada começar, então a bolinha deve partir de 20% da altura do topo, com velocidade de 20px/s e vetor angular aleatório (exceto direção exata para cima).
- [ ] Dado o movimento da bola, quando ela for rebatida, então seu ângulo deve ter no mínimo 15 graus de inclinação em relação ao eixo horizontal.
- [ ] Dado que a bola atinge o canto da tela, quando ocorrer a colisão, então ambos os vetores (X e Y) devem ser invertidos simultaneamente.
- [ ] Dado que a bola colide com o paddle, quando a colisão ocorrer nas bordas, então o vetor X resultante deve refletir uma variação acentuada simulando "efeito".

### RF-004: Sistema de Pontuação (Goal) e Z-Index
**Prioridade:** Must Have
**Persona:** Jogador Casual

**Descrição:** Deve existir um "buraco" verde-radioativo demarcado (goal) com largura de exatos 60px (3x o diâmetro da bolinha de 20px), fixado no topo da tela (centralizada horizontalmente). O jogador ganha 1 ponto sempre que a bola atravessar a área do gol em direção ao teto. O gol não causa colisão, permitindo que a bola "atravesse" a tela, sendo renderizada *sobre* a área do gol (Z-index superior).

**Critérios de Aceite:**
- [ ] Dado que a bola passa ou colide com a área de goal (topo central), quando isso ocorrer, então o contador de pontos do jogador deve ser incrementado em 1 e a bola não deve ricochetear.
- [ ] Dado o momento exato em que a bola entra na área do gol, quando renderizado, então a bola deve permanecer visível passando por cima da demarcação do gol.

### RF-005: Sistema de Vidas, Modais e Fim de Jogo
**Prioridade:** Must Have
**Persona:** Jogador Casual

**Descrição:** O jogador inicia com 3 vidas. Caso a bolinha atinja o limite inferior da tela (abaixo do paddle), uma vida é subtraída e o jogo retorna ao estado de pausa aguardando clique no modal "Iniciar". Ao perder a 3ª vida, uma tela modal de Game Over é exibida. Os modais (Iniciar/Reiniciar) compartilham a mesma UI: fundo escurecido preenchendo a tela, um popup flutuante cor `rgb(25,25,25)`, com botão transparente de borda `#83e509` e texto verde-radioativo.

**Critérios de Aceite:**
- [ ] Dado que a bolinha passa o limite inferior da tela, quando isso ocorrer, então 1 vida deve ser subtraída e a partida deve pausar retornando ao estado inicial de saque.
- [ ] Dado que o jogador tem 1 vida restante, quando a bola cair no limite inferior, então as vidas chegam a 0, a movimentação para e o modal de Game Over com botão "Reiniciar" é exibido usando a estética `#83e509`.
- [ ] Dado que a tela de Game Over está visível, quando o jogador clicar no botão "Reiniciar", então os pontos devem ser zerados, as vidas restauradas para 3 e o estado volta para a pausa padrão do modal "Iniciar".

---

## 4. Requisitos Não-Funcionais

### RNF-001: Performance (Responsividade do Paddle)
- **Requisito:** A movimentação do paddle não pode ter atraso (lag) perceptível em relação ao toque do dedo, garantindo 60 FPS na animação de input (medição baseada em percepção de usuários).
- **Métrica:** Opinião e testes em devices físicos por usuários.
- **Meta:** >= 60 FPS na interação.

### RNF-002: Performance (Dispositivos Low-End)
- **Requisito:** A engine de cálculo de física e colisão deve ser leve o suficiente para rodar em dispositivos móveis antigos (processadores armeabi-v7a com 2GB de RAM).
- **Métrica:** Consumo de CPU.
- **Meta:** Consumo de CPU médio abaixo de 15% em tempo de execução nesses hardwares.

### RNF-003: Segurança
- **Autenticação:** Não aplicável (acesso livre).
- **Autorização:** Não aplicável.
- **Proteção de dados:** Dados salvos localmente apenas (se houver recordes futuros).
- **Conformidade:** Padrão das lojas de apps (sem coleta de dados sensíveis).

### RNF-004: Disponibilidade
- **SLA:** Best effort (aplicação 100% offline).
- **RTO:** Não aplicável.
- **RPO:** Não aplicável.

### RNF-005: Observabilidade
- **Logs:** Logs padrão de crash do React Native em dev.
- **Métricas:** Não se aplica no MVP offline.
- **Alertas:** Não aplicável.

---

## 5. Regras de Negócio

| ID     | Regra | Impacto em caso de violação | Origem |
|--------|-------|----------------------------|--------|
| RN-001 | O jogo nunca encerra por pontos máximos | Se o jogo parar de contabilizar pontos ou travar ao chegar num teto, frustrará o objetivo de "infinito" | Core Gameplay |
| RN-002 | Vidas são estritamente limitadas a 3 por rodada | Falha no sistema de dano impede que o estado de Game Over seja alcançado | Core Gameplay |
| RN-003 | A área de gol é estritamente 3x a largura da bola (60px fixos) | Facilidade desbalanceada ou impossibilidade de pontuar caso não implementado com precisão matemática | User Spec |

---

## 6. Integrações e Dependências Externas

| Sistema/Serviço | Tipo | Descrição da Integração | Responsável | Risco |
|-----------------|------|------------------------|-------------|-------|
| N/A | N/A | Toda a lógica rodará localmente sem integrações externas. | thiago | Baixo |

---

## 7. Premissas e Restrições

### Premissas (assumimos como verdadeiro)
- A lógica de renderização 2D do React Native (Views ou SVG/Canvas) será rápida o suficiente sem precisar de uma engine dedicada em C++ para este MVP.
- A física pode ser construída via cálculos iterativos no thread principal de JavaScript do React Native.

### Restrições (limites que devem ser respeitados)
- Nenhum SDK externo de gameplay ou análise deve ser importado para manter o foco isolado e limpo.

---

## 8. Métricas de Sucesso

| KPI | Definição | Baseline Atual | Meta | Prazo | Como Medir |
|-----|-----------|----------------|------|-------|------------|
| Estabilidade Visual | Manutenção de 60 Frames per Second durante o gameplay ativo | N/A | 60 FPS contínuos | Sprint 1 | Teste empírico em dispositivos físicos alvo |
| Latência do Touch | Tempo entre o arraste do dedo e a UI refletir a nova posição do paddle | N/A | Percepção instantânea | Sprint 1 | Teste empírico por usuários |

---

## 9. Riscos e Mitigações

| # | Risco | Probabilidade | Impacto | Mitigação | Responsável |
|---|-------|---------------|---------|-----------|-------------|
| 1 | Ponte de comunicação do React Native (JS <-> Native) gerar gargalos na atualização física | Alta | Alto | Utilizar Reanimated/Gesture Handler se a renderização puramente baseada em state no JS ficar lenta | thiago |

---

## 10. Questões em Aberto

*(Nenhuma questão em aberto remanescente)*

---

## 11. Histórico de Revisões

| Versão | Data | Autor | Alterações |
|--------|------|-------|------------|
| 1.0 | 29/05/2026 | thiago cavalcante | Versão inicial completa com detalhamento do checklist de qualidade |