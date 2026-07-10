#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Lista arquivos modificados para code review, usando git diff.
    Filtra arquivos irrelevantes (locks, gerados, binários).

.PARAMETER Base
    Referência base para o diff. Padrão: HEAD (alterações não commitadas).
    Use "HEAD~1" para o último commit, ou um hash específico.

.PARAMETER Extensions
    Filtrar por extensões (ex: "ts,tsx,js"). Padrão: todas as extensões de código.
#>
param(
    [string]$Base = "HEAD",
    [string]$Extensions = ""
)

# Extensões de código relevantes para review
$codeExtensions = @(
    "ts", "tsx", "js", "jsx", "mjs", "cjs",
    "py", "rb", "go", "rs", "java", "kt", "swift",
    "cs", "fs", "cpp", "c", "h",
    "php", "scala", "ex", "exs",
    "sql", "graphql", "proto",
    "sh", "ps1", "bash"
)

# Extensões a ignorar sempre
$ignorePatterns = @(
    "*.lock", "*.sum", "*.snap",
    "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "Cargo.lock",
    "*.min.js", "*.min.css", "*.map",
    "*.pb.go", "*_generated.*", "*.g.dart"
)

# Obtém lista do git
$gitOutput = & git diff --name-only $Base 2>&1
if ($LASTEXITCODE -ne 0) {
    # Tenta staged + unstaged
    $gitOutput = & git diff --name-only HEAD 2>&1
}

# Se ainda vazio, pega arquivos do último commit
if (-not $gitOutput -or $gitOutput.Count -eq 0) {
    $gitOutput = & git diff --name-only HEAD~1 HEAD 2>&1
}

if (-not $gitOutput -or $gitOutput.Count -eq 0) {
    Write-Output "⚠️  Nenhuma alteração detectada em relação a: $Base"
    exit 0
}

$files = $gitOutput | Where-Object { $_ -and (Test-Path $_) }

# Filtra por extensão de código
if ($Extensions) {
    $extList = $Extensions -split "," | ForEach-Object { $_.Trim().TrimStart(".") }
} else {
    $extList = $codeExtensions
}

$filtered = $files | Where-Object {
    $ext = [System.IO.Path]::GetExtension($_).TrimStart(".")
    $name = [System.IO.Path]::GetFileName($_)
    $isCode = $extList -contains $ext
    $isIgnored = $ignorePatterns | Where-Object { $name -like $_ }
    $isCode -and -not $isIgnored
}

if ($filtered.Count -eq 0) {
    Write-Output "⚠️  Nenhum arquivo de código encontrado nas alterações (total alterado: $($files.Count))."
    exit 0
}

Write-Output "📂 $($filtered.Count) arquivo(s) para review:"
$filtered | ForEach-Object { Write-Output "  $_" }
