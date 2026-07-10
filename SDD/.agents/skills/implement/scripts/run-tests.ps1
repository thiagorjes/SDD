#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Executa os testes do projeto e retorna um sumário.
    Logs completos são salvos sempre e apagados apenas se todos os testes passarem.

.PARAMETER Command
    Comando de teste a executar (ex: "npm test", "pytest", "dotnet test").
    Se omitido, tenta detectar automaticamente pelo projeto.

.PARAMETER LogDir
    Diretório onde os logs serão salvos. Padrão: .test-logs na raiz do projeto.

.OUTPUTS
    Sumário em stdout. Em caso de falha, inclui o caminho do log para consulta.
#>
param(
    [string]$Command = "",
    [string]$LogDir = ".test-logs"
)

# --- Detecção automática do runner ---
if (-not $Command) {
    if (Test-Path "package.json") {
        $pkg = Get-Content "package.json" -Raw | ConvertFrom-Json
        if ($pkg.scripts.test) { $Command = "npm test" }
        elseif ($pkg.scripts."test:ci") { $Command = "npm run test:ci" }
    } elseif (Test-Path "pytest.ini" -or Test-Path "pyproject.toml" -or Test-Path "setup.py") {
        $Command = "pytest"
    } elseif (Test-Path "*.csproj" -or Test-Path "*.sln") {
        $Command = "dotnet test"
    } elseif (Test-Path "go.mod") {
        $Command = "go test ./..."
    } elseif (Test-Path "Cargo.toml") {
        $Command = "cargo test"
    } else {
        Write-Output "❌ Não foi possível detectar o runner de testes. Passe -Command explicitamente."
        exit 1
    }
}

# --- Prepara diretório de log ---
if (-not (Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir | Out-Null
}

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$logFile = Join-Path $LogDir "test-run-$timestamp.log"

# --- Executa os testes, captura output completo ---
$header = @"
Test Run: $timestamp
Command:  $Command
WorkDir:  $(Get-Location)
$(("-" * 60))

"@
$header | Set-Content $logFile -Encoding UTF8

$output = & cmd /c "$Command 2>&1"
$exitCode = $LASTEXITCODE
$output | Add-Content $logFile -Encoding UTF8

# --- Tenta extrair sumário do output ---
$outputText = $output -join "`n"

# Padrões comuns de sumário por runner
$summary = ""
if ($outputText -match "(\d+) passed") { $passed = $Matches[1] } else { $passed = "?" }
if ($outputText -match "(\d+) failed") { $failed = $Matches[1] } else { $failed = "0" }
if ($outputText -match "(\d+) skipped") { $skipped = $Matches[1] } else { $skipped = "0" }

# Jest / Vitest
if ($outputText -match "Tests:\s+(.+)") { $summary = $Matches[1] }
# pytest
elseif ($outputText -match "=+\s+(.+\d+ passed.+)\s+=+") { $summary = $Matches[1] }
# dotnet test
elseif ($outputText -match "Passed:\s*(\d+).*Failed:\s*(\d+)") { $summary = "Passed: $($Matches[1]), Failed: $($Matches[2])" }
# go test
elseif ($outputText -match "ok\s+|FAIL\s+") {
    $okCount = ([regex]::Matches($outputText, "^ok\s+", "Multiline")).Count
    $failCount = ([regex]::Matches($outputText, "^FAIL\s+", "Multiline")).Count
    $summary = "Packages OK: $okCount, FAIL: $failCount"
}
# fallback genérico
else { $summary = "exit code: $exitCode" }

# --- Decide o que fazer com o log ---
if ($exitCode -eq 0) {
    Remove-Item $logFile -Force
    Write-Output "✅ Testes passaram — $summary"
} else {
    Write-Output "❌ Falhas detectadas — $summary"
    Write-Output "📄 Log completo: $logFile"
    Write-Output "   (Use a ferramenta Read para inspecionar as falhas)"
    exit 1
}
