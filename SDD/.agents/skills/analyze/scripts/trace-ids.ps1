#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Verifica rastreabilidade de IDs entre PRD, TechSpec e Tasks.
    Extrai todos os RF-XXX/RNF-XXX do PRD e verifica cobertura nos demais artefatos.

.PARAMETER PrdFile
    Caminho para o PRD.

.PARAMETER TechspecFile
    Caminho para o TechSpec (opcional — omita se não existir ainda).

.PARAMETER TasksFile
    Caminho para o documento de Tasks (opcional — omita se não existir ainda).
#>
param(
    [Parameter(Mandatory)][string]$PrdFile,
    [string]$TechspecFile = "",
    [string]$TasksFile = ""
)

function Get-Ids($text, $pattern) {
    [regex]::Matches($text, $pattern) | ForEach-Object { $_.Value } | Sort-Object -Unique
}

# Lê PRD
if (-not (Test-Path $PrdFile)) {
    Write-Output "❌ PRD não encontrado: $PrdFile"
    exit 1
}
$prdContent = Get-Content $PrdFile -Raw -Encoding UTF8
$rfIds  = Get-Ids $prdContent "RF-\d{3}"
$rnfIds = Get-Ids $prdContent "RNF-\d{3}"
$allIds = $rfIds + $rnfIds

Write-Output "📋 IDs encontrados no PRD: $($allIds.Count) ($($rfIds.Count) RF + $($rnfIds.Count) RNF)"

if ($allIds.Count -eq 0) {
    Write-Output "⚠️  Nenhum RF/RNF numerado encontrado no PRD."
    exit 0
}

# Lê TechSpec
$techContent = ""
if ($TechspecFile -and (Test-Path $TechspecFile)) {
    $techContent = Get-Content $TechspecFile -Raw -Encoding UTF8
} elseif ($TechspecFile) {
    Write-Output "⚠️  TechSpec informado mas não encontrado: $TechspecFile"
}

# Lê Tasks
$tasksContent = ""
if ($TasksFile -and (Test-Path $TasksFile)) {
    $tasksContent = Get-Content $TasksFile -Raw -Encoding UTF8
} elseif ($TasksFile) {
    Write-Output "⚠️  Tasks informado mas não encontrado: $TasksFile"
}

# Verifica cobertura
$uncoveredTech  = @()
$uncoveredTasks = @()

foreach ($id in $allIds) {
    if ($techContent  -and $techContent  -notmatch [regex]::Escape($id)) { $uncoveredTech  += $id }
    if ($tasksContent -and $tasksContent -notmatch [regex]::Escape($id)) { $uncoveredTasks += $id }
}

# Relatório
$hasIssues = $false

if ($techContent) {
    if ($uncoveredTech.Count -eq 0) {
        Write-Output "✅ TechSpec cobre todos os $($allIds.Count) IDs do PRD"
    } else {
        Write-Output "❌ TechSpec não referencia $($uncoveredTech.Count) ID(s): $($uncoveredTech -join ', ')"
        $hasIssues = $true
    }
}

if ($tasksContent) {
    if ($uncoveredTasks.Count -eq 0) {
        Write-Output "✅ Tasks cobrem todos os $($allIds.Count) IDs do PRD"
    } else {
        Write-Output "❌ Tasks não referenciam $($uncoveredTasks.Count) ID(s): $($uncoveredTasks -join ', ')"
        $hasIssues = $true
    }
}

if ($hasIssues) { exit 1 } else { exit 0 }
