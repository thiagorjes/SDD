#Requires -Version 7
<#
.SYNOPSIS
    Inicializa um workspace SDD com estrutura unica: toolset na raiz e sistemas em systems/.
.DESCRIPTION
    Estrutura gerada (sempre a mesma, para 1 ou N sistemas):

      workspace/
        .agents/ .claude/ comportamento.md scripts/   <- toolset (unica copia)
        memory/  docs/  design/  (docs/contracts/ para integracao entre sistemas)
        systems/<nome>/                               <- um por sistema (novo, existente ou legado)
          guidelines/                                 <- padroes DO sistema (via /guidelines)

    Cada sistema tem um cenario: novo (greenfield), existente (brownfield) ou
    legado (migracao de tecnologia). O cenario e registrado em memory/state.md
    e orienta o comportamento do /guidelines e demais skills.
.EXAMPLE
    .\init.ps1
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

# ── Helpers ───────────────────────────────────────────────────────────────────

function Ask-YesNo([string]$Question, [string]$Default = "S") {
    $hint = if ($Default -eq "S") { "[S/n]" } else { "[s/N]" }
    $r = (Read-Host "$Question $hint").Trim()
    if (-not $r) { $r = $Default }
    return $r.ToUpper() -eq "S"
}

function Ask-ExistingPath([string]$Question) {
    do {
        $p = (Read-Host $Question).Trim().Trim('"').Trim("'")
        if (-not (Test-Path $p)) {
            Write-Host "  Caminho nao encontrado. Tente novamente." -ForegroundColor Red
            $p = $null
        }
    } while (-not $p)
    return $p
}

function New-Dir([string]$Path) {
    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

function Write-File([string]$Path, [string[]]$Lines) {
    [System.IO.File]::WriteAllText($Path, ($Lines -join "`n"), $utf8NoBom)
}

function Write-Ok([string]$Label)  { Write-Host "  [ok] $Label" -ForegroundColor Green }
function Write-Warn([string]$Msg)  { Write-Host "  [!]  $Msg"   -ForegroundColor Yellow }

# ── Toolset root ──────────────────────────────────────────────────────────────

$toolRoot = Split-Path $PSScriptRoot -Parent   # scripts/../ = SDD/

# ── Coleta de informacoes ─────────────────────────────────────────────────────

Write-Host ""
Write-Host "=== SDD — Inicializacao de Workspace ===" -ForegroundColor Cyan
Write-Host ""

$wsName = (Read-Host "Nome do workspace").Trim()
$wsDir  = (Read-Host "Pasta destino do workspace (Enter = ./$wsName)").Trim().Trim('"').Trim("'")
if (-not $wsDir) { $wsDir = Join-Path (Get-Location) $wsName }

# ── Sistemas ──────────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "Sistemas do workspace (um por repositorio/codigo-fonte)." -ForegroundColor Cyan
Write-Host "Cenarios: 1=Novo (greenfield)  2=Existente (adota SDD)  3=Legado (migracao de tecnologia)"
Write-Host ""

$systems = @()
do {
    $sysName = (Read-Host "Nome do sistema $($systems.Count + 1)").Trim()
    do { $sc = (Read-Host "  Cenario de '$sysName' [1/2/3]").Trim() } while ($sc -notin @("1","2","3"))
    $scenario = @{ "1" = "greenfield"; "2" = "brownfield"; "3" = "migracao" }[$sc]

    $srcPath = $null
    if ($sc -ne "1") {
        if (Ask-YesNo "  O codigo de '$sysName' sera movido/clonado manualmente depois?" "N") {
            Write-Warn "Clone/mova o repositorio para systems/$sysName/ antes de rodar /guidelines"
        } else {
            $srcPath = (Resolve-Path (Ask-ExistingPath "  Pasta atual do codigo de '$sysName'")).Path
        }
    }

    $systems += [pscustomobject]@{ Name = $sysName; Scenario = $scenario; Source = $srcPath }
} while (Ask-YesNo "Adicionar outro sistema?" "N")

# ── Demais opcoes ─────────────────────────────────────────────────────────────

Write-Host ""
$withDesign = Ask-YesNo "Incluir etapa de design no fluxo?" "S"

Write-Host ""
Write-Host "LLM(s): 1=Claude  2=Antigravity (agy)  3=Ambos"
do { $llm = (Read-Host "Escolha [1/2/3]").Trim() } while ($llm -notin @("1","2","3"))
$useClaude = $llm -in @("1","3")
$useAgy    = $llm -in @("2","3")

$gitInit     = Ask-YesNo "Inicializar git no workspace (artefatos SDD versionados; systems/ ignorado)?" "S"
$userInstall = $false
if ($useClaude) {
    $userInstall = Ask-YesNo "Instalar skills tambem no perfil do usuario (~/.claude/skills) para uso em qualquer pasta?" "N"
}

# ── Confirmacao ───────────────────────────────────────────────────────────────

$llmLabel = @()
if ($useClaude) { $llmLabel += "Claude" }
if ($useAgy)    { $llmLabel += "Antigravity" }
$llmLabel = $llmLabel -join " + "

Write-Host ""
Write-Host ("─── Resumo " + ("─" * 34)) -ForegroundColor Yellow
Write-Host "  Workspace: $wsName"
Write-Host "  Destino  : $wsDir"
foreach ($s in $systems) {
    $srcInfo = if ($s.Source) { " (source: $($s.Source))" } else { "" }
    Write-Host "  Sistema  : $($s.Name) [$($s.Scenario)]$srcInfo"
}
Write-Host "  Design   : $(if ($withDesign) { 'sim' } else { 'nao' })"
Write-Host "  LLM      : $llmLabel"
Write-Host "  Git      : $(if ($gitInit) { 'sim' } else { 'nao' })"
if ($userInstall) { Write-Host "  ~/.claude: skills instalados no perfil do usuario" }
Write-Host ("─" * 45) -ForegroundColor Yellow

if (-not (Ask-YesNo "Confirma?" "S")) {
    Write-Host "Cancelado." -ForegroundColor Red; exit 0
}

# ── Criacao da estrutura ──────────────────────────────────────────────────────

Write-Host ""
Write-Host "Criando estrutura..." -ForegroundColor Cyan

New-Dir $wsDir
$wsDirFull    = (Resolve-Path $wsDir).Path
$toolRootFull = (Resolve-Path $toolRoot).Path
$copyToolset  = $wsDirFull -ne $toolRootFull

# ── Toolset (sempre na raiz do workspace) ─────────────────────────────────────

if ($copyToolset) {
    foreach ($f in @(".agents", "scripts")) {
        $src = Join-Path $toolRoot $f
        if (Test-Path $src) { Copy-Item -Recurse -Force $src $wsDir; Write-Ok "$f/" }
    }
    if ($useClaude) {
        $src = Join-Path $toolRoot ".claude"
        if (Test-Path $src) { Copy-Item -Recurse -Force $src $wsDir; Write-Ok ".claude/" }
    }
    $comp = Join-Path $toolRoot "comportamento.md"
    if (Test-Path $comp) { Copy-Item -Force $comp $wsDir; Write-Ok "comportamento.md" }
} else {
    Write-Warn "Workspace e o proprio repositorio SDD — copia do toolset ignorada"
}

# Versao do toolset (hash do repo SDD, se disponivel)
$toolsetVersion = (Get-Date).ToString("yyyy-MM-dd")
try {
    $hash = (git -C $toolRoot rev-parse --short HEAD 2>$null)
    if ($LASTEXITCODE -eq 0 -and $hash) { $toolsetVersion = "$toolsetVersion ($hash)" }
} catch {}

# ── Instalacao opcional no perfil do usuario ──────────────────────────────────

if ($userInstall) {
    $userSkills = Join-Path $HOME ".claude/skills"
    New-Dir $userSkills
    $srcSkills = Join-Path $toolRoot ".claude/skills"
    if (Test-Path $srcSkills) {
        Copy-Item -Recurse -Force "$srcSkills/*" $userSkills
        Write-Ok "~/.claude/skills (copia pessoal — a versao do workspace tem precedencia)"
    }
}

# ── systems/ ──────────────────────────────────────────────────────────────────

$systemsDir = Join-Path $wsDir "systems"
New-Dir $systemsDir

foreach ($s in $systems) {
    $sysDir = Join-Path $systemsDir $s.Name
    if ($s.Source) {
        $srcFull = (Resolve-Path $s.Source).Path
        if ($srcFull -eq $sysDir) {
            Write-Ok "systems/$($s.Name)/ (ja no lugar)"
        } elseif (Test-Path $sysDir) {
            Write-Warn "systems/$($s.Name)/ ja existe — copia do source ignorada"
        } else {
            Copy-Item -Recurse -Force $srcFull $sysDir
            Write-Ok "systems/$($s.Name)/ (copiado de $($s.Source))"
        }
    } else {
        New-Dir $sysDir
        Write-Ok "systems/$($s.Name)/"
    }
    New-Dir (Join-Path $sysDir "guidelines")
}

# ── Pastas de artefatos ───────────────────────────────────────────────────────

foreach ($f in @("docs/prd", "docs/techspec", "docs/tasks", "docs/checklists", "docs/contracts")) {
    New-Dir (Join-Path $wsDir $f); Write-Ok "$f/"
}

if ($withDesign) {
    foreach ($f in @("design/flows", "design/tokens", "design/prototypes")) {
        New-Dir (Join-Path $wsDir $f); Write-Ok "$f/"
    }
}

# ── CLAUDE.md / AGENTS.md ─────────────────────────────────────────────────────

if ($useClaude) {
    $tgt = Join-Path $wsDir "CLAUDE.md"
    if (-not (Test-Path $tgt)) {
        Write-File $tgt @(
            "# CLAUDE.md",
            "",
            "@comportamento.md",
            "@memory/constitution.md",
            "@memory/state.md",
            "@README.md",
            "",
            "> **Economia de tokens**: ao final de cada interacao com o usuario, execute ``scripts/claude_costs.ps1``."
        )
        Write-Ok "CLAUDE.md (criado)"
    } else { Write-Ok "CLAUDE.md (ja existe)" }
}

if ($useAgy) {
    $tgt = Join-Path $wsDir "AGENTS.md"
    if (-not (Test-Path $tgt)) {
        $src = Join-Path $toolRoot "AGENTS.md"
        if ($copyToolset -and (Test-Path $src)) {
            Copy-Item -Force $src $wsDir
            Write-Ok "AGENTS.md (copiado)"
        } else {
            Write-File $tgt @(
                "# AGENTS.md",
                "IGNORE o arquivo CLAUDE.md.",
                "",
                "@comportamento.md",
                "@memory/constitution.md",
                "@memory/state.md",
                "@README.md",
                "",
                "",
                "**/analyze:** @.agents/skills/analyze.md",
                "**/checklists:** @.agents/skills/checklists.md",
                "**/clarify:** @.agents/skills/clarify.md",
                "**/code_review:** @.agents/skills/code_review.md",
                "**/designer:** @.agents/skills/designer.md",
                "**/guidelines:** @.agents/skills/guidelines.md",
                "**/implement:** @.agents/skills/implement.md",
                "**/prd:** @.agents/skills/prd.md",
                "**/tasks:** @.agents/skills/tasks.md",
                "**/tdd:** @.agents/skills/tdd.md",
                "**/techspec:** @.agents/skills/techspec.md",
                "**/tests:** @.agents/skills/tests.md"
            )
            Write-Ok "AGENTS.md (criado)"
        }
    } else { Write-Ok "AGENTS.md (ja existe)" }
}

# ── Memory ────────────────────────────────────────────────────────────────────

$memDir = Join-Path $wsDir "memory"
New-Dir $memDir

$today = (Get-Date).ToString("yyyy-MM-dd")

$pipeline = "/guidelines (por sistema) → /prd → [/clarify] → [/checklist]"
if ($withDesign) { $pipeline += " → /designer" }
$pipeline += " → /techspec → /tasks → [/analyze] → /implement (por task)"

$scenarioLabel = @{ greenfield = "Novo (greenfield)"; brownfield = "Existente (brownfield)"; migracao = "Legado (migracao)" }

# state.md
$statePath = Join-Path $memDir "state.md"
if (-not (Test-Path $statePath)) {
    $stateLines = @(
        "# Estado Operacional — $wsName",
        "_Atualizado em: ${today}_",
        "",
        "> Estado atual do workspace e das features em andamento.",
        "> Para principios estaveis e ADRs, veja [memory/constitution.md](constitution.md).",
        "",
        "---",
        "",
        "## Toolset",
        "",
        "**Versao:** $toolsetVersion — atualize com ``scripts/update.ps1``",
        "**Pipeline:** $pipeline",
        "",
        "---",
        "",
        "## Sistemas",
        "",
        "| Sistema | Caminho | Cenario | Guidelines | Observacoes |",
        "|---|---|---|---|---|"
    )
    foreach ($s in $systems) {
        $obs = if (-not $s.Source -and $s.Scenario -ne "greenfield") { "aguardando clone/move do codigo" } else { "—" }
        $stateLines += "| $($s.Name) | ``systems/$($s.Name)/`` | $($scenarioLabel[$s.Scenario]) | pendente | $obs |"
    }
    $stateLines += @(
        "",
        "---",
        "",
        "## Features Ativas",
        "",
        "| Feature | Sistemas afetados | PRD | TechSpec | Tasks | Status |",
        "|---|---|---|---|---|---|",
        "| _(nenhuma ativa)_ | — | — | — | — | — |",
        "",
        "---",
        "",
        "## Evolucao do SDD",
        "",
        "| Data | Mudanca |",
        "|---|---|",
        "| $today | Workspace inicializado via init.ps1 |"
    )
    Write-File $statePath $stateLines
    Write-Ok "memory/state.md"
} else { Write-Warn "memory/state.md ja existe, mantido" }

# constitution.md
$constPath = Join-Path $memDir "constitution.md"
if (-not (Test-Path $constPath)) {
    $constLines = @(
        "# Constituicao — $wsName",
        "_Criado em: ${today}_",
        "",
        "> Principios estaveis, ADRs e decisoes de design do workspace.",
        "> Atualizado apenas quando os fundamentos mudarem.",
        "",
        "---",
        "",
        "## Contexto do Workspace",
        ""
    )
    foreach ($s in $systems) {
        $constLines += "- **$($s.Name)** — cenario: $($scenarioLabel[$s.Scenario])"
    }
    $constLines += @(
        "",
        "---",
        "",
        "## Decisoes de Arquitetura (ADRs)",
        "",
        "_(a registrar conforme o projeto evoluir; sistemas em migracao registram a estrategia como ADR inicial via /guidelines)_",
        "",
        "---",
        "",
        "## Principios Estaveis",
        "",
        "_(a registrar conforme o projeto evoluir)_"
    )
    Write-File $constPath $constLines
    Write-Ok "memory/constitution.md"
} else { Write-Warn "memory/constitution.md ja existe, mantido" }

# costs.md
$costsPath = Join-Path $memDir "costs.md"
if (-not (Test-Path $costsPath)) {
    Write-File $costsPath @(
        "# Custos de Tokens — $wsName",
        "_Atualizado automaticamente por scripts/claude_costs.ps1_",
        "",
        "| Data | LLM | Input tokens | Output tokens | Custo estimado |",
        "|---|---|---|---|---|"
    )
    Write-Ok "memory/costs.md"
} else { Write-Warn "memory/costs.md ja existe, mantido" }

# ── README.md ─────────────────────────────────────────────────────────────────

$readmeLines = @(
    "# Workspace SDD — $wsName",
    "",
    "## Estrutura",
    "",
    "- **``systems/``** — Um subdiretorio por sistema (cada um pode ter seu proprio repositorio git)"
)
foreach ($s in $systems) {
    $readmeLines += "  - **``systems/$($s.Name)/``** — $($scenarioLabel[$s.Scenario]); guidelines proprios em ``systems/$($s.Name)/guidelines/``"
}
$readmeLines += @(
    "- **``.agents/skills/``** — Skills do pipeline SDD (agnosticos ao LLM)",
    "- **``docs/prd/``** — Product Requirements Documents (unicos por feature, mesmo multi-sistema)",
    "- **``docs/contracts/``** — Contratos de integracao entre sistemas (fonte de verdade compartilhada)",
    "- **``docs/techspec/``** — Especificacoes tecnicas (uma por sistema afetado, em features multi-sistema)",
    "- **``docs/tasks/``** — Plano de tasks (agrupadas por sistema)",
    "- **``docs/checklists/``** — Checklists de qualidade"
)
if ($withDesign) {
    $readmeLines += "- **``design/``** — Fluxos, tokens e prototipos"
}
$readmeLines += @(
    "- **``memory/constitution.md``** — Principios estaveis e ADRs. Leia antes de qualquer acao.",
    "- **``memory/state.md``** — Estado operacional (sistemas, features, progresso). Atualizado a cada etapa.",
    "- **``scripts/``** — Utilitarios (``update.ps1`` re-sincroniza o toolset)",
    "",
    "---",
    "",
    "## Git",
    "",
    "- O workspace versiona **artefatos SDD** (docs/, memory/, guidelines nao — estes ficam nos sistemas).",
    "- ``systems/`` esta no ``.gitignore`` do workspace: cada sistema mantem seu proprio repositorio, remote e CI.",
    "- Em features multi-sistema, a ordem de merge entre repositorios e definida no documento de tasks.",
    "",
    "---",
    "",
    "## Pipeline SDD",
    "",
    "``````",
    $pipeline,
    "``````",
    "",
    "**Skills entre colchetes ``[/skill]``** sao opcionais mas recomendados.",
    "",
    "---",
    "",
    "**Workspace:** $wsName | **Iniciado em:** $today | **Toolset:** $toolsetVersion"
)
Write-File (Join-Path $wsDir "README.md") $readmeLines
Write-Ok "README.md"

# ── Git ───────────────────────────────────────────────────────────────────────

if ($gitInit) {
    $gi = Join-Path $wsDir ".gitignore"
    if (-not (Test-Path $gi)) {
        Write-File $gi @(
            "# Sistemas tem repositorios proprios — nao versionar no workspace",
            "systems/",
            "",
            "# Operacional/local",
            "memory/costs.md",
            ".test-logs/"
        )
        Write-Ok ".gitignore"
    }
    if (-not (Test-Path (Join-Path $wsDir ".git"))) {
        git -C $wsDir init --quiet
        Write-Ok "git init"
    } else {
        Write-Warn "repositorio git ja existe no workspace"
    }
}

# ── Conclusao ─────────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "=== Workspace criado com sucesso ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "  $wsDirFull"
Write-Host ""
Write-Host "Proximos passos:" -ForegroundColor Yellow
$pendingClone = $systems | Where-Object { -not $_.Source -and $_.Scenario -ne "greenfield" }
if ($pendingClone) {
    foreach ($s in $pendingClone) {
        Write-Host "  1. Clone/mova o codigo de '$($s.Name)' para systems/$($s.Name)/"
    }
}
Write-Host "  Abra o LLM na raiz do workspace: $wsDirFull"
Write-Host "  Execute: /guidelines  (configura os padroes de cada sistema, um por vez)"
Write-Host ""
