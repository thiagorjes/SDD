#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Valida integridade do TechSpec gerado — verifica existência, tamanho e seções obrigatórias.

.PARAMETER File
    Caminho para o arquivo TechSpec principal a validar.
#>
param(
    [Parameter(Mandatory)][string]$File
)

$errors = @()

if (-not (Test-Path $File)) {
    Write-Output "❌ Arquivo não encontrado: $File"
    exit 1
}

$content = Get-Content $File -Raw -Encoding UTF8
if ([string]::IsNullOrWhiteSpace($content)) {
    Write-Output "❌ Arquivo existe mas está vazio: $File"
    exit 1
}

# Seções obrigatórias do TechSpec
$required = @(
    @{ Pattern = "^## 1\.";           Label = "Sec 1 — Visão Técnica" },
    @{ Pattern = "^## 2\.";           Label = "Sec 2 — Stack e Dependências" },
    @{ Pattern = "^## 3\.";           Label = "Sec 3 — Arquitetura" },
    @{ Pattern = "^## 4\.";           Label = "Sec 4 — Modelo de Dados" },
    @{ Pattern = "^## 5\.";           Label = "Sec 5 — Contratos de API" },
    @{ Pattern = "\*\*Versão:\*\*";   Label = "Metadado: Versão" },
    @{ Pattern = "\*\*Status:\*\*";   Label = "Metadado: Status" },
    @{ Pattern = "RF-\d{3}|RNF-\d{3}"; Label = "Pelo menos um RF/RNF referenciado" }
)

foreach ($r in $required) {
    if ($content -notmatch $r.Pattern) {
        $errors += "  ✗ Ausente: $($r.Label)"
    }
}

# Verifica artefatos granulares esperados no mesmo diretório
$dir = Split-Path $File -Parent
$artifacts = @("data-model.md", "api-contracts.md")
foreach ($a in $artifacts) {
    $path = Join-Path $dir $a
    if (-not (Test-Path $path)) {
        $errors += "  ✗ Artefato granular ausente: $a"
    }
}

$lines = ($content -split "`n").Count
$sizeKb = [math]::Round((Get-Item $File).Length / 1KB, 1)

if ($errors.Count -eq 0) {
    Write-Output "✅ TechSpec válido — $lines linhas, $sizeKb KB: $File"
} else {
    Write-Output "❌ TechSpec incompleto — $($errors.Count) problema(s) em: $File"
    $errors | ForEach-Object { Write-Output $_ }
    exit 1
}
