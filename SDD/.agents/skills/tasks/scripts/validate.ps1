#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Valida integridade do documento de Tasks — verifica estrutura e arquivos individuais.

.PARAMETER File
    Caminho para o documento principal de tasks.
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

# Estrutura obrigatória
$required = @(
    @{ Pattern = "^## Resumo de Escopo"; Label = "Seção: Resumo de Escopo" },
    @{ Pattern = "^## Épicos";           Label = "Seção: Épicos" },
    @{ Pattern = "EPIC-\d+";             Label = "Pelo menos um EPIC definido" },
    @{ Pattern = "US-\d+";              Label = "Pelo menos uma User Story definida" },
    @{ Pattern = "\*\*Versão:\*\*";      Label = "Metadado: Versão" }
)

foreach ($r in $required) {
    if ($content -notmatch $r.Pattern) {
        $errors += "  ✗ Ausente: $($r.Label)"
    }
}

# Verifica arquivos individuais de task no subdiretório
$baseName = [System.IO.Path]::GetFileNameWithoutExtension($File) -replace "-tasks$", ""
$taskDir = Join-Path (Split-Path $File -Parent) $baseName
$taskCount = 0
$missingTasks = @()

if (Test-Path $taskDir) {
    $taskFiles = Get-ChildItem $taskDir -Filter "task-*.md"
    $taskCount = $taskFiles.Count

    # Verifica tasks referenciadas no documento principal que não têm arquivo individual
    $referencedTasks = [regex]::Matches($content, "task-(\d+\.\d+)\.md") | ForEach-Object { $_.Value }
    foreach ($ref in $referencedTasks) {
        $refPath = Join-Path $taskDir $ref
        if (-not (Test-Path $refPath)) {
            $missingTasks += $ref
        }
    }
} else {
    $errors += "  ✗ Subdiretório de tasks individuais ausente: $taskDir"
}

if ($missingTasks.Count -gt 0) {
    $errors += "  ✗ Tasks referenciadas sem arquivo individual: $($missingTasks -join ', ')"
}

$lines = ($content -split "`n").Count
$sizeKb = [math]::Round((Get-Item $File).Length / 1KB, 1)

if ($errors.Count -eq 0) {
    Write-Output "✅ Tasks válidas — $lines linhas, $sizeKb KB, $taskCount arquivo(s) individual(is): $File"
} else {
    Write-Output "❌ Tasks incompletas — $($errors.Count) problema(s) em: $File"
    $errors | ForEach-Object { Write-Output $_ }
    exit 1
}
