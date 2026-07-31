#Requires -Version 7
<#
.SYNOPSIS
    Atualiza o toolset SDD de um workspace e migra layouts antigos para o formato systems/.
.DESCRIPTION
    Dois modos, executados na ordem:

    1. MIGRACAO (se necessario): detecta o layout antigo (codigo do projeto e
       guidelines/ na raiz, sem systems/) e reorganiza:
         - move a pasta do projeto para systems/<nome>/  (o .git do projeto vai junto, intacto)
         - move guidelines/ da raiz para systems/<nome>/guidelines/
         - cria docs/contracts/ e a tabela "Sistemas" no memory/state.md

    2. SYNC: re-copia .agents/, .claude/, comportamento.md e scripts/ do repositorio
       SDD para o workspace, registrando a nova versao em memory/state.md.

    Execute a partir do repositorio SDD, apontando para o workspace:
      .\update.ps1 -Workspace C:\caminho\do\workspace
    Ou de dentro do workspace (usa o proprio scripts/ como origem apenas se -Source informado):
      pwsh <repo-sdd>\scripts\update.ps1 -Workspace .
#>
param(
    [Parameter(Mandatory)][string]$Workspace,
    [string]$Source  # raiz do repo SDD; default: pasta pai deste script
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function Write-Ok([string]$Label)  { Write-Host "  [ok] $Label" -ForegroundColor Green }
function Write-Warn([string]$Msg)  { Write-Host "  [!]  $Msg"   -ForegroundColor Yellow }
function New-Dir([string]$Path) {
    if (-not (Test-Path $Path)) { New-Item -ItemType Directory -Path $Path -Force | Out-Null }
}

if (-not $Source) { $Source = Split-Path $PSScriptRoot -Parent }
$src = (Resolve-Path $Source).Path
$ws  = (Resolve-Path $Workspace).Path

# Origem = destino acontece quando o script roda da copia do toolset dentro do proprio
# workspace. Nesse caso a migracao de layout ainda e executada; apenas o sync e pulado.
$doSync = $src -ne $ws
if (-not $doSync) {
    Write-Warn "Origem = destino (script rodando de dentro do workspace) — sync do toolset sera pulado."
    Write-Warn "Para atualizar o toolset, aponte a origem: update.ps1 -Workspace . -Source <caminho-do-repo-SDD>"
}
if ($doSync -and -not (Test-Path (Join-Path $src ".agents"))) {
    Write-Host "Origem invalida: $src nao contem .agents/ (aponte -Source para o repositorio SDD)." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=== SDD — Atualizacao de Workspace ===" -ForegroundColor Cyan
Write-Host "  Origem : $src"
Write-Host "  Destino: $ws"
Write-Host ""

# ── 1. Migracao de layout antigo ──────────────────────────────────────────────

$systemsDir  = Join-Path $ws "systems"
$rootGl      = Join-Path $ws "guidelines"
# Layout antigo: sem systems/ OU systems/ vazio (ex: execucao anterior interrompida)
$needsLayout = (-not (Test-Path $systemsDir)) -or (@(Get-ChildItem $systemsDir -Directory -ErrorAction SilentlyContinue).Count -eq 0)

# Guarda: so migra se o destino for de fato um workspace SDD (layout antigo).
# Uma raiz de projeto comum (src/, package.json...) NAO e um workspace — use o init.ps1.
$isSddWorkspace = (Test-Path (Join-Path $ws "memory/state.md")) -or (Test-Path (Join-Path $ws ".agents"))
if ($needsLayout -and -not $isSddWorkspace) {
    Write-Host "Este diretorio nao parece ser um workspace SDD (sem memory/state.md nem .agents/)." -ForegroundColor Red
    Write-Host "Se isto e a raiz de um projeto/repositorio, use o init.ps1 para criar um workspace" -ForegroundColor Yellow
    Write-Host "e registrar este projeto como sistema (cenario 2=existente ou 3=legado)." -ForegroundColor Yellow
    exit 1
}

if ($needsLayout) {
    Write-Host "Layout antigo detectado (sem systems/). Iniciando migracao..." -ForegroundColor Cyan

    # Segunda guarda: se a raiz parece codigo-fonte (nao uma colecao de projetos), aborta.
    $sourceMarkers = @("src", "package.json", "pyproject.toml", "pom.xml", "go.mod", "Cargo.toml", "node_modules")
    $foundMarkers = $sourceMarkers | Where-Object { Test-Path (Join-Path $ws $_) }
    if ($foundMarkers) {
        Write-Host "A raiz contem marcadores de codigo-fonte ($($foundMarkers -join ', '))." -ForegroundColor Red
        Write-Host "Isto parece ser a raiz de um projeto, nao um workspace SDD — migracao abortada." -ForegroundColor Yellow
        Write-Host "Use o init.ps1 para criar o workspace e registrar este projeto como sistema." -ForegroundColor Yellow
        exit 1
    }

    # Candidatos a pasta do projeto: diretorios na raiz que nao sao do toolset/artefatos
    $known = @(".agents", ".claude", ".git", ".test-logs", "docs", "design", "guidelines", "memory", "scripts", "systems")
    $candidates = @(Get-ChildItem -Path $ws -Directory | Where-Object { $known -notcontains $_.Name })

    if ($candidates.Count -eq 0) {
        Write-Warn "Nenhuma pasta de projeto encontrada na raiz — criando systems/ vazio"
        New-Dir $systemsDir
    } else {
        Write-Host "Pastas candidatas a projeto (serao movidas para systems/):"
        $candidates | ForEach-Object { Write-Host "    - $($_.Name)" }
        $confirm = (Read-Host "Confirma mover essas pastas para systems/? [S/n]").Trim()
        if ($confirm -and $confirm.ToUpper() -ne "S") {
            Write-Host "Migracao cancelada." -ForegroundColor Red; exit 0
        }

        New-Dir $systemsDir
        foreach ($c in $candidates) {
            $dest = Join-Path $systemsDir $c.Name
            Move-Item -Path $c.FullName -Destination $dest
            Write-Ok "systems/$($c.Name)/ (movido — repositorio git do projeto preservado)"
        }

        # guidelines/ da raiz -> primeiro sistema (unico caso comum no layout antigo)
        if ((Test-Path $rootGl) -and $candidates.Count -ge 1) {
            $firstSys = Join-Path $systemsDir $candidates[0].Name
            $destGl   = Join-Path $firstSys "guidelines"
            if (Test-Path $destGl) {
                Write-Warn "systems/$($candidates[0].Name)/guidelines/ ja existe — guidelines/ da raiz mantida para revisao manual"
            } else {
                Move-Item -Path $rootGl -Destination $destGl
                Write-Ok "systems/$($candidates[0].Name)/guidelines/ (movido da raiz)"
            }
        }
    }

    New-Dir (Join-Path $ws "docs/contracts")
    Write-Ok "docs/contracts/"

    # Atualiza state.md com a tabela Sistemas, se ausente
    $statePath = Join-Path $ws "memory/state.md"
    if (Test-Path $statePath) {
        $state = Get-Content $statePath -Raw -Encoding UTF8
        if ($state -notmatch "## Sistemas") {
            $today = (Get-Date).ToString("yyyy-MM-dd")
            $tbl = @("", "---", "", "## Sistemas", "", "| Sistema | Caminho | Cenario | Guidelines | Observacoes |", "|---|---|---|---|---|")
            foreach ($c in (Get-ChildItem -Path $systemsDir -Directory)) {
                $glState = if (Test-Path (Join-Path $c.FullName "guidelines")) { "ok" } else { "pendente" }
                $tbl += "| $($c.Name) | ``systems/$($c.Name)/`` | Existente (brownfield) | $glState | migrado do layout antigo |"
            }
            $tbl += @("", "> Migrado para o layout systems/ em $today via update.ps1. Revise o cenario de cada sistema.")
            [System.IO.File]::AppendAllText($statePath, (($tbl -join "`n") + "`n"), $utf8NoBom)
            Write-Ok "memory/state.md (tabela Sistemas adicionada — revise os cenarios)"
        }
    } else {
        Write-Warn "memory/state.md nao encontrado — rode o init.ps1 ou crie manualmente"
    }

    Write-Warn "Revise README.md e CLAUDE.md: caminhos do projeto mudaram para systems/"
}

# ── 2. Sync do toolset ────────────────────────────────────────────────────────

if (-not $doSync) {
    Write-Host ""
    Write-Host "=== Concluido (somente migracao de layout; sync do toolset pulado) ===" -ForegroundColor Cyan
    Write-Host ""
    exit 0
}

Write-Host ""
Write-Host "Sincronizando toolset..." -ForegroundColor Cyan

foreach ($f in @(".agents", "scripts")) {
    $s = Join-Path $src $f
    if (Test-Path $s) {
        if (Test-Path (Join-Path $ws $f)) { Remove-Item -Recurse -Force (Join-Path $ws $f) }
        Copy-Item -Recurse -Force $s $ws
        Write-Ok "$f/"
    }
}
$s = Join-Path $src ".claude"
if ((Test-Path $s) -and (Test-Path (Join-Path $ws "CLAUDE.md"))) {
    if (Test-Path (Join-Path $ws ".claude")) { Remove-Item -Recurse -Force (Join-Path $ws ".claude") }
    Copy-Item -Recurse -Force $s $ws
    Write-Ok ".claude/"
}
$comp = Join-Path $src "comportamento.md"
if (Test-Path $comp) { Copy-Item -Force $comp $ws; Write-Ok "comportamento.md" }

# ── Registro de versao ────────────────────────────────────────────────────────

$toolsetVersion = (Get-Date).ToString("yyyy-MM-dd")
try {
    $hash = (git -C $src rev-parse --short HEAD 2>$null)
    if ($LASTEXITCODE -eq 0 -and $hash) { $toolsetVersion = "$toolsetVersion ($hash)" }
} catch {}

$statePath = Join-Path $ws "memory/state.md"
if (Test-Path $statePath) {
    $state = Get-Content $statePath -Raw -Encoding UTF8
    if ($state -match "(?m)^\*\*Versao:\*\* .*$") {
        $state = $state -replace "(?m)^\*\*Versao:\*\* .*$", "**Versao:** $toolsetVersion — atualize com ``scripts/update.ps1``"
        [System.IO.File]::WriteAllText($statePath, $state, $utf8NoBom)
    } else {
        [System.IO.File]::AppendAllText($statePath, "`n**Toolset atualizado em:** $toolsetVersion`n", $utf8NoBom)
    }
    Write-Ok "memory/state.md (versao: $toolsetVersion)"
}

Write-Host ""
Write-Host "=== Atualizacao concluida ===" -ForegroundColor Cyan
Write-Host ""
