#Requires -Version 7
<#
.SYNOPSIS
    Inicializa um novo projeto SDD, criando a estrutura de pastas e configurando o toolset.
.DESCRIPTION
    Novo projeto  : cria uma subpasta dentro do clone do SDD e copia o toolset para ela.
    Projeto existente: copia o toolset para o diretorio pai do projeto (o LLM deve ser
                       aberto nesse diretorio pai para ter acesso ao projeto e ao SDD).
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

function Add-GitKeep([string]$Dir) {
    $k = Join-Path $Dir ".gitkeep"
    if (-not (Test-Path $k)) { New-Item -ItemType File -Path $k -Force | Out-Null }
}

function Write-File([string]$Path, [string[]]$Lines) {
    [System.IO.File]::WriteAllText($Path, ($Lines -join "`n"), $utf8NoBom)
}

function Write-Ok([string]$Label)   { Write-Host "  [ok] $Label" -ForegroundColor Green }
function Write-Warn([string]$Msg)   { Write-Host "  [!]  $Msg"   -ForegroundColor Yellow }

# ── Toolset root ──────────────────────────────────────────────────────────────

$toolRoot = Split-Path $PSScriptRoot -Parent   # scripts/../ = SDD/

# ── Coleta de informacoes ─────────────────────────────────────────────────────

Write-Host ""
Write-Host "=== SDD — Inicializacao de Projeto ===" -ForegroundColor Cyan
Write-Host ""

$projName   = (Read-Host "Nome do projeto").Trim()
$isExisting = Ask-YesNo "Projeto ja em andamento (source existente)?" "N"

$projPath = $null
if ($isExisting) {
    $projPath  = Ask-ExistingPath "  Pasta do projeto existente"
    $targetDir = Split-Path $projPath -Parent
} else {
    $targetDir = Join-Path $toolRoot $projName
}

$withDesign = Ask-YesNo "Incluir etapa de design no fluxo?" "S"

$hasGl = Ask-YesNo "Ja existem guidelines de desenvolvimento?" "N"
$glSrc = $null
if ($hasGl) { $glSrc = Ask-ExistingPath "  Pasta com os guidelines existentes" }

Write-Host ""
Write-Host "LLM(s): 1=Claude  2=Gemini  3=Ambos"
do { $llm = (Read-Host "Escolha [1/2/3]").Trim() } while ($llm -notin @("1","2","3"))
$useClaude = $llm -in @("1","3")
$useGemini = $llm -in @("2","3")

# ── Confirmacao ───────────────────────────────────────────────────────────────

$llmLabel = if ($useClaude -and $useGemini) { "Claude + Gemini" } elseif ($useClaude) { "Claude" } else { "Gemini" }

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

New-Dir $targetDir

# Toolset base: skills, scripts
foreach ($f in @("skills", "scripts")) {
    $src = Join-Path $toolRoot $f
    if (Test-Path $src) {
        Copy-Item -Recurse -Force $src $targetDir
        Write-Ok "$f/"
    }
}

# Commands por LLM
if ($useClaude) {
    $src = Join-Path $toolRoot ".claude"
    if (Test-Path $src) { Copy-Item -Recurse -Force $src $targetDir; Write-Ok ".claude/commands/" }
}
if ($useGemini) {
    $src = Join-Path $toolRoot ".gemini"
    if (Test-Path $src) { Copy-Item -Recurse -Force $src $targetDir; Write-Ok ".gemini/commands/" }
}

# comportamento.md
$comp = Join-Path $toolRoot "comportamento.md"
if (Test-Path $comp) { Copy-Item -Force $comp $targetDir; Write-Ok "comportamento.md" }

# ── CLAUDE.md ─────────────────────────────────────────────────────────────────

if ($useClaude) {
    $ignoreGemini = if ($useGemini) { "`nIGNORE o arquivo GEMINI.md." } else { "" }
    Write-File (Join-Path $targetDir "CLAUDE.md") @(
        "# CLAUDE.md$ignoreGemini",
        "",
        "@comportamento.md",
        "@memory/constitution.md",
        "@memory/state.md",
        "@README.md",
        "",
        "> **Economia de tokens**: ao final de cada interacao com o usuario, execute ``scripts/claude_costs.ps1``."
    )
    Write-Ok "CLAUDE.md"
}

# ── GEMINI.md ─────────────────────────────────────────────────────────────────

if ($useGemini) {
    $src = Join-Path $toolRoot "GEMINI.md"
    if (Test-Path $src) { Copy-Item -Force $src $targetDir; Write-Ok "GEMINI.md" }
}

# ── Pastas de artefatos (docs/) ───────────────────────────────────────────────

foreach ($f in @("docs/prd", "docs/techspec", "docs/tasks", "docs/checklists")) {
    $d = Join-Path $targetDir $f
    New-Dir $d; Add-GitKeep $d; Write-Ok "$f/"
}

# ── Pastas de design ──────────────────────────────────────────────────────────

if ($withDesign) {
    foreach ($f in @("design/flows", "design/tokens", "design/prototypes")) {
        $d = Join-Path $targetDir $f
        New-Dir $d; Add-GitKeep $d; Write-Ok "$f/"
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
    Add-GitKeep $glDir
    Write-Ok "guidelines/ (vazia)"
}

# Template de design system (se design ativo e sem import)
if ($withDesign -and -not $glSrc) {
    Write-File (Join-Path $glDir "GUIDELINE_DESIGN_SYSTEM.md") @(
        "# Guideline: Design System",
        "",
        "> Padrao tecnico para a etapa de design no fluxo SDD.",
        "> Preencha conforme as decisoes tomadas durante o /designer.",
        "",
        "## Stack de Prototipagem",
        "",
        "| Camada | Tecnologia | Entrega |",
        "|---|---|---|",
        "| Markup | HTML5 semantico | via CDN |",
        "| Estilos | Tailwind CSS | via CDN |",
        "| Icones | Phosphor Icons | via CDN |",
        "| Interacoes | Alpine.js ou Vanilla JS | via CDN / inline |",
        "| Imagens | placehold.co | placeholder em desenvolvimento |",
        "",
        "## Acessibilidade",
        "",
        "- Contraste minimo WCAG AA (4.5:1 para texto normal, 3:1 para texto grande)",
        "- Atributos ``aria-*`` obrigatorios em componentes interativos",
        "- Navegacao por teclado funcional",
        "",
        "## design-tokens.json — Campos Obrigatorios",
        "",
        "```json",
        "{",
        '  "colors": { "primary": "", "secondary": "", "background": "", "surface": "", "text": "", "error": "" },',
        '  "typography": { "fontFamily": "", "scale": { "xs": "", "sm": "", "base": "", "lg": "", "xl": "", "2xl": "" } },',
        '  "spacing": { "unit": "4px", "scale": [0, 4, 8, 12, 16, 24, 32, 48, 64] },',
        '  "breakpoints": { "sm": "640px", "md": "768px", "lg": "1024px", "xl": "1280px" },',
        '  "borderRadius": { "sm": "", "md": "", "lg": "", "full": "9999px" }',
        "}",
        "```",
        "",
        "## Convencoes de Prototipo",
        "",
        "- Respeitar o dispositivo-alvo (Mobile First ou Desktop) definido no PRD",
        "- Um arquivo HTML por tela mapeada no fluxo (Etapa 1)",
        "- Nomenclatura: ``[numero]-[nome-da-tela].html`` (ex: ``01-login.html``)",
        "- Tokens importados via tag ``<script>`` no inicio de cada prototipo",
        "",
        "## Heuristicas de Referencia",
        "",
        "- Nielsen 10 Heuristics",
        "- Mobile First (Luke Wroblewski)",
        "- Gestalt (proximidade, similaridade, continuidade)"
    )
    Write-Ok "guidelines/GUIDELINE_DESIGN_SYSTEM.md (template)"
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
    "| Skills agnosticos | $skillCount | ``skills/`` |"
)
if ($useClaude) { $stateLines += "| Commands Claude | $skillCount | ``.claude/commands/`` |" }
if ($useGemini) { $stateLines += "| Commands Gemini | $skillCount | ``.gemini/commands/`` |" }
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
Write-File (Join-Path $memDir "state.md") $stateLines
Write-Ok "memory/state.md"

# constitution.md
Write-File (Join-Path $memDir "constitution.md") @(
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

# costs.md
Write-File (Join-Path $memDir "costs.md") @(
    "# Custos de Tokens — $projName",
    "_Atualizado automaticamente por scripts/claude_costs.ps1 ou scripts/gemini_costs.ps1_",
    "",
    "| Data | LLM | Input tokens | Output tokens | Custo estimado |",
    "|---|---|---|---|---|"
)
Write-Ok "memory/costs.md"

# ── README.md ─────────────────────────────────────────────────────────────────

$readmeLines = @(
    "# Processo de Desenvolvimento SDD — $projName",
    "",
    "## Estrutura",
    "",
    "- **``skills/``** — Skills do pipeline SDD (agnosticos ao LLM)"
)
if ($useClaude) { $readmeLines += "- **``.claude/commands/``** — Commands Claude" }
if ($useGemini) { $readmeLines += "- **``.gemini/commands/``** — Commands Gemini" }
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
if ($projPath) {
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
$firstStep = if ($hasGl) { "/prd  (guidelines importadas, pode pular /guidelines)" } else { "/guidelines" }
Write-Host "  Abra o LLM na pasta: $targetDir"
Write-Host "  Execute: $firstStep"
Write-Host ""
