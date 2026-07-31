#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Valida integridade do TechSpec gerado — verifica existência, seções obrigatórias
    e presença dos artefatos granulares (data-model, quickstart, contracts).

.PARAMETER File
    Caminho para o arquivo TechSpec principal a validar (ex: docs/techspec/auth-techspec.md).
#>
param(
    [Parameter(Mandatory)][string]$File
)

$errors = @()
$warnings = @()

if (-not (Test-Path $File)) {
    Write-Output "❌ Arquivo não encontrado: $File"
    exit 1
}

$content = Get-Content $File -Raw -Encoding UTF8
if ([string]::IsNullOrWhiteSpace($content)) {
    Write-Output "❌ Arquivo existe mas está vazio: $File"
    exit 1
}

# Seções obrigatórias do TechSpec (template techspec-template.md)
$required = @(
    @{ Pattern = "(?m)^## 1\.";            Label = "Sec 1 — Visão Técnica" },
    @{ Pattern = "(?m)^## 2\.";            Label = "Sec 2 — Arquitetura" },
    @{ Pattern = "(?m)^## 3\.";            Label = "Sec 3 — Modelagem de Dados (resumo)" },
    @{ Pattern = "(?m)^## 4\.";            Label = "Sec 4 — Especificação de APIs (resumo)" },
    @{ Pattern = "(?m)^## 5\.";            Label = "Sec 5 — Segurança" },
    @{ Pattern = "(?m)^## 12\.";           Label = "Sec 12 — Matriz de Rastreabilidade" },
    @{ Pattern = "\*\*Versão:\*\*";    Label = "Metadado: Versão" },
    @{ Pattern = "\*\*Status:\*\*";    Label = "Metadado: Status" },
    @{ Pattern = "RF-\d{3}|RNF-\d{3}"; Label = "Pelo menos um RF/RNF referenciado" }
)

foreach ($r in $required) {
    if ($content -notmatch $r.Pattern) {
        $errors += "  ✗ Ausente: $($r.Label)"
    }
}

# Artefatos granulares em docs/techspec/[nome]/ (nome = arquivo sem sufixo -techspec.md)
$dir = Split-Path $File -Parent
$baseName = [IO.Path]::GetFileNameWithoutExtension($File) -replace '-techspec$', ''
$featureDir = Join-Path $dir $baseName

foreach ($a in @("data-model.md", "quickstart.md")) {
    $path = Join-Path $featureDir $a
    if (-not (Test-Path $path)) {
        $errors += "  ✗ Artefato granular ausente: $baseName/$a"
    }
}

# Contratos: obrigatórios apenas se a feature expõe API (heurística: seção 4 não é N/A)
$contractsDir = Join-Path $featureDir "contracts"
$hasContracts = (Test-Path $contractsDir) -and @(Get-ChildItem $contractsDir -Filter *.md -ErrorAction SilentlyContinue).Count -gt 0
if (-not $hasContracts) {
    if ($content -match "(?m)^## 4\.[\s\S]{0,400}?N/A") {
        $warnings += "  ⚠ Sem contratos — seção 4 marcada como N/A (ok se a feature não expõe API)"
    } else {
        $errors += "  ✗ Nenhum contrato em $baseName/contracts/ e a seção 4 não está marcada como N/A"
    }
}

$lines = ($content -split "`n").Count
$sizeKb = [math]::Round((Get-Item $File).Length / 1KB, 1)

$warnings | ForEach-Object { Write-Output $_ }
if ($errors.Count -eq 0) {
    Write-Output "✅ TechSpec válido — $lines linhas, $sizeKb KB: $File"
} else {
    Write-Output "❌ TechSpec incompleto — $($errors.Count) problema(s) em: $File"
    $errors | ForEach-Object { Write-Output $_ }
    exit 1
}
