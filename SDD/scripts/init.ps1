#Requires -Version 7
<#
.SYNOPSIS
    Inicializa um novo projeto SDD, criando a estrutura de pastas e configurando o toolset.
.DESCRIPTION
    Novo projeto  : cria a pasta do projeto dentro do repositorio clonado e configura a
                    estrutura (docs, design, guidelines, memory) no proprio repositorio.
                    Nenhum arquivo do toolset e copiado.
    Projeto existente: copia o toolset para o diretorio pai do projeto e cria a estrutura
                       la. O LLM deve ser aberto nesse diretorio pai.
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
Write-Host "=== SDD — Inicializacao de Projeto ===" -ForegroundColor Cyan
Write-Host ""

$projName   = (Read-Host "Nome do projeto").Trim()
$isExisting = Ask-YesNo "Projeto ja em andamento (source existente)?" "N"

$projPath  = $null
$targetDir = $null
if ($isExisting) {
    $projPath  = Ask-ExistingPath "  Pasta do projeto existente"
    $targetDir = Split-Path $projPath -Parent
} else {
    $targetDir = $toolRoot
}

$withDesign = Ask-YesNo "Incluir etapa de design no fluxo?" "S"

$hasGl = Ask-YesNo "Ja existem guidelines de desenvolvimento?" "N"
$glSrc = $null
if ($hasGl) { $glSrc = Ask-ExistingPath "  Pasta com os guidelines existentes" }

Write-Host ""
Write-Host "LLM(s): 1=Claude  2=Antigravity (agy)  3=Ambos"
do { $llm = (Read-Host "Escolha [1/2/3]").Trim() } while ($llm -notin @("1","2","3"))
$useClaude = $llm -in @("1","3")
$useAgy    = $llm -in @("2","3")

# ── Confirmacao ───────────────────────────────────────────────────────────────

$llmLabel = @()
if ($useClaude) { $llmLabel += "Claude" }
if ($useAgy)    { $llmLabel += "Antigravity" }
$llmLabel = $llmLabel -join " + "

Write-Host ""
Write-Host ("─── Resumo " + ("─" * 34)) -ForegroundColor Yellow
Write-Host "  Projeto  : $projName"
Write-Host "  Destino  : $targetDir"
if ($projPath) {
Write-Host "  Source   : $projPath"
}
Write-Host "  Design   : $(if ($withDesign) { 'sim' } else { 'nao' })"
Write-Host "  Guideline: $(if ($glSrc) { $glSrc } else { 'nenhum existente' })"
Write-Host "  LLM      : $llmLabel"
Write-Host ("─" * 45) -ForegroundColor Yellow

if (-not (Ask-YesNo "Confirma?" "S")) {
    Write-Host "Cancelado." -ForegroundColor Red; exit 0
}

# ── Criacao da estrutura ──────────────────────────────────────────────────────

Write-Host ""
Write-Host "Criando estrutura..." -ForegroundColor Cyan

# Determina se o toolset precisa ser copiado:
# - novo projeto: targetDir = toolRoot, nada a copiar
# - existente dentro do clone: parent resolve para toolRoot, nada a copiar
# - existente fora do clone: targetDir diferente de toolRoot, copia necessaria
$toolRootFull  = (Resolve-Path $toolRoot).Path
New-Dir $targetDir
$targetDirFull = (Resolve-Path $targetDir).Path
$copyToolset   = $isExisting -and ($targetDirFull -ne $toolRootFull)

# ── Copiar toolset (apenas quando destino e externo ao repositorio) ────────────

if ($copyToolset) {
    foreach ($f in @(".agents", "scripts")) {
        $src = Join-Path $toolRoot $f
        if (Test-Path $src) { Copy-Item -Recurse -Force $src $targetDir; Write-Ok "$f/" }
    }

    if ($useClaude) {
        $src = Join-Path $toolRoot ".claude"
        if (Test-Path $src) { Copy-Item -Recurse -Force $src $targetDir; Write-Ok ".claude/commands/" }
    }

    $comp = Join-Path $toolRoot "comportamento.md"
    if (Test-Path $comp) { Copy-Item -Force $comp $targetDir; Write-Ok "comportamento.md" }
} elseif ($isExisting) {
    Write-Warn "Projeto dentro do repositorio SDD — copia do toolset ignorada"
}

# ── Novo projeto: criar pasta do projeto dentro do repositorio ────────────────

if (-not $isExisting) {
    $projDir = Join-Path $targetDir $projName
    New-Dir $projDir
    Write-Ok "$projName/ (pasta do projeto)"
}

# ── CLAUDE.md ─────────────────────────────────────────────────────────────────

if ($useClaude) {
    $tgt = Join-Path $targetDir "CLAUDE.md"
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
    } else {
        Write-Ok "CLAUDE.md (ja existe)"
    }
}

# ── AGENTS.md (Antigravity) ───────────────────────────────────────────────────

if ($useAgy) {
    $tgt = Join-Path $targetDir "AGENTS.md"
    if (-not (Test-Path $tgt)) {
        $src = Join-Path $toolRoot "AGENTS.md"
        if ($copyToolset -and (Test-Path $src)) {
            Copy-Item -Force $src $targetDir
            Write-Ok "AGENTS.md (copiado)"
        } else {
            Write-File $tgt @(
                "# AGENTS.md",
                "IGNORE o arquivo CLAUDE.md.",
                "",
                "Antes de qualquer acao nesta sessao, leia os seguintes arquivos na ordem:",
                "1. ``comportamento.md`` — idioma, comportamento e regras de interacao",
                "2. ``memory/constitution.md`` — principios e decisoes de arquitetura do toolset",
                "3. ``memory/state.md`` — estado operacional atual (features, tasks, qualidade)",
                "4. ``README.md`` — estrutura e pipeline do projeto",
                "",
                "> **Economia de tokens**: ao final de cada interacao com o usuario, execute ``scripts/claude_costs.ps1``."
            )
            Write-Ok "AGENTS.md (criado)"
        }
    } else {
        Write-Ok "AGENTS.md (ja existe)"
    }
}

# ── Pastas de artefatos (docs/) ───────────────────────────────────────────────

foreach ($f in @("docs/prd", "docs/techspec", "docs/tasks", "docs/checklists")) {
    $d = Join-Path $targetDir $f
    New-Dir $d; Write-Ok "$f/"
}

# ── Pastas de design ──────────────────────────────────────────────────────────

if ($withDesign) {
    foreach ($f in @("design/flows", "design/tokens", "design/prototypes")) {
        $d = Join-Path $targetDir $f
        New-Dir $d; Write-Ok "$f/"
    }
}

# ── Guidelines ────────────────────────────────────────────────────────────────

$glDir = Join-Path $targetDir "guidelines"
New-Dir $glDir

if ($glSrc) {
    $glSrcResolved = (Resolve-Path $glSrc).Path
    $glDirResolved = (Resolve-Path $glDir).Path
    if ($glSrcResolved -eq $glDirResolved) {
        Write-Ok "guidelines/ (origem = destino, copia ignorada)"
    } else {
        Get-ChildItem -Path $glSrc -File | ForEach-Object {
            Copy-Item -Force $_.FullName (Join-Path $glDir $_.Name)
        }
        Write-Ok "guidelines/ (importado de $glSrc)"
    }
} else {
    Write-Ok "guidelines/ (vazia)"
}

# ── Memory ────────────────────────────────────────────────────────────────────

$memDir = Join-Path $targetDir "memory"
New-Dir $memDir

$today      = (Get-Date).ToString("yyyy-MM-dd")
$skillCount = if ($withDesign) { 12 } else { 11 }

$pipeline = "/guidelines → /prd → [/clarify] → [/checklist]"
if ($withDesign) { $pipeline += " → [/designer]" }
$pipeline += " → /techspec → /tasks → [/analyze] → /implement (por task)"

# state.md
$statePath = Join-Path $memDir "state.md"
if (-not (Test-Path $statePath)) {
    $stateLines = @(
        "# Estado Operacional — $projName",
        "_Atualizado em: ${today}_",
        "",
        "> Estado atual do toolset e dos projetos em andamento.",
        "> Para principios estaveis e ADRs, veja [memory/constitution.md](constitution.md).",
        "",
        "---",
        "",
        "## Toolset Atual",
        "",
        "| Componente | Qtd | Localizacao |",
        "|---|---|---|",
        "| Skills agnosticos | $skillCount | ``.agents/skills/`` |"
    )
    if ($useClaude) { $stateLines += "| Commands Claude | $skillCount | ``.claude/commands/`` |" }
    if ($useAgy)    { $stateLines += "| Skills Antigravity | $skillCount | ``.agents/skills/`` |" }
    $stateLines += @(
        "",
        "**Pipeline:** $pipeline",
        "",
        "---",
        "",
        "## Features Ativas",
        "",
        "| Feature | PRD | TechSpec | Tasks | Status |",
        "|---|---|---|---|---|",
        "| _(nenhuma ativa)_ | — | — | — | — |",
        "",
        "---",
        "",
        "## Evolucao do SDD",
        "",
        "| Data | Mudanca |",
        "|---|---|",
        "| $today | Projeto inicializado via init.ps1 |"
    )
    Write-File $statePath $stateLines
    Write-Ok "memory/state.md"
} else {
    Write-Warn "memory/state.md ja existe, mantido"
}

# constitution.md
$constPath = Join-Path $memDir "constitution.md"
if (-not (Test-Path $constPath)) {
    Write-File $constPath @(
        "# Constituicao — $projName",
        "_Criado em: ${today}_",
        "",
        "> Principios estaveis, ADRs e decisoes de design do toolset.",
        "> Atualizado apenas quando os fundamentos do projeto mudarem.",
        "",
        "---",
        "",
        "## Decisoes de Arquitetura (ADRs)",
        "",
        "_(a registrar conforme o projeto evoluir)_",
        "",
        "---",
        "",
        "## Principios Estaveis",
        "",
        "_(a registrar conforme o projeto evoluir)_"
    )
    Write-Ok "memory/constitution.md"
} else {
    Write-Warn "memory/constitution.md ja existe, mantido"
}

# costs.md
$costsPath = Join-Path $memDir "costs.md"
if (-not (Test-Path $costsPath)) {
    Write-File $costsPath @(
        "# Custos de Tokens — $projName",
        "_Atualizado automaticamente por scripts/claude_costs.ps1_",
        "",
        "| Data | LLM | Input tokens | Output tokens | Custo estimado |",
        "|---|---|---|---|---|"
    )
    Write-Ok "memory/costs.md"
} else {
    Write-Warn "memory/costs.md ja existe, mantido"
}

# ── README.md ─────────────────────────────────────────────────────────────────

$readmeLines = @(
    "# Processo de Desenvolvimento SDD — $projName",
    "",
    "## Estrutura",
    "",
    "- **``.agents/skills/``** — Skills do pipeline SDD (agnosticos ao LLM, descobertos nativamente pelo Antigravity)"
)
if ($useClaude) { $readmeLines += "- **``.claude/commands/``** — Commands Claude" }
if ($useAgy)    { $readmeLines += "- **``.agents/agents/``** — Subagentes do Comite de Analise (architect, security, database)" }
$readmeLines += @(
    "- **``guidelines/``** — Padroes tecnicos deste projeto",
    "- **``docs/prd/``** — Product Requirements Documents",
    "- **``docs/techspec/``** — Especificacoes tecnicas",
    "- **``docs/tasks/``** — Plano de tasks",
    "- **``docs/checklists/``** — Checklists de qualidade"
)
if ($withDesign) {
    $readmeLines += "- **``design/flows/``** — Diagramas de jornada e navegacao (Mermaid)"
    $readmeLines += "- **``design/tokens/``** — Design system tokens (JSON)"
    $readmeLines += "- **``design/prototypes/``** — Prototipos de alta fidelidade (HTML)"
}
if (-not $isExisting) {
    $readmeLines += "- **``$projName/``** — Source do projeto"
} else {
    $readmeLines += "- **``$(Split-Path $projPath -Leaf)/``** — Source do projeto"
}
$readmeLines += @(
    "- **``memory/constitution.md``** — Principios estaveis e ADRs. Leia antes de qualquer acao.",
    "- **``memory/state.md``** — Estado operacional atual. Atualizado a cada interacao.",
    "- **``scripts/``** — Scripts utilitarios",
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
    "## Projeto",
    "",
    "**Nome:** $projName",
    "**Iniciado em:** $today"
)
if ($projPath) { $readmeLines += "**Source:** $projPath" }

Write-File (Join-Path $targetDir "README.md") $readmeLines
Write-Ok "README.md"

# ── Conclusao ─────────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "=== Projeto criado com sucesso ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "  $targetDir"
Write-Host ""
Write-Host "Proximo passo:" -ForegroundColor Yellow
Write-Host "  Abra o LLM na pasta: $targetDir"
$firstStep = if ($hasGl) { "/prd  (guidelines importadas, pode pular /guidelines)" } else { "/guidelines" }
Write-Host "  Execute: $firstStep"
Write-Host ""
