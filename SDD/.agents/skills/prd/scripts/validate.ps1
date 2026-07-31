#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Valida integridade do PRD gerado — verifica existência, tamanho e seções obrigatórias.

.PARAMETER File
    Caminho para o arquivo PRD a validar.
#>
param(
    [Parameter(Mandatory)][string]$File
)

$errors = @()

# Existência e conteúdo
if (-not (Test-Path $File)) {
    Write-Output "❌ Arquivo não encontrado: $File"
    exit 1
}

$content = Get-Content $File -Raw -Encoding UTF8
if ([string]::IsNullOrWhiteSpace($content)) {
    Write-Output "❌ Arquivo existe mas está vazio: $File"
    exit 1
}

# Seções obrigatórias (presentes independente da fase negocio/ti/full)
$required = @(
    @{ Pattern = "(?m)^## 1\."; Label = "Cap 1 — Visão Geral" },
    @{ Pattern = "(?m)^## 2\."; Label = "Cap 2 — Usuários e Stakeholders" },
    @{ Pattern = "(?m)^## 3\."; Label = "Cap 3 — Requisitos Funcionais" },
    @{ Pattern = "(?m)^## 8\."; Label = "Cap 8 — Métricas de Sucesso" },
    @{ Pattern = "\*\*Versão:\*\*";  Label = "Metadado: Versão" },
    @{ Pattern = "\*\*Status:\*\*";  Label = "Metadado: Status" },
    @{ Pattern = "RF-\d{3}";         Label = "Pelo menos um RF numerado (RF-XXX)" }
)

foreach ($r in $required) {
    if ($content -notmatch $r.Pattern) {
        $errors += "  ✗ Ausente: $($r.Label)"
    }
}

# Resultado
$lines = ($content -split "`n").Count
$sizeKb = [math]::Round((Get-Item $File).Length / 1KB, 1)

if ($errors.Count -eq 0) {
    Write-Output "✅ PRD válido — $lines linhas, $sizeKb KB: $File"
} else {
    Write-Output "❌ PRD incompleto — $($errors.Count) problema(s) em: $File"
    $errors | ForEach-Object { Write-Output $_ }
    exit 1
}
