param (
    [string]$ProjectName = (Get-Item .).Name.ToLower(),
    [string]$CostsFile   = "memory/costs.md"
)

function Fmt([long]$n) {
    [string]::Format([System.Globalization.CultureInfo]::InvariantCulture, "{0:N0}", $n) -replace ',','.'
}

$EM   = [char]0x2014   # em dash
$MDOT = [char]0x00B7   # middle dot
$BT   = [char]96       # backtick

# Walk up the directory tree to find the Claude project log folder
$SearchDir = Get-Item .
$LogPath   = $null
while ($null -ne $SearchDir) {
    $Slug     = $SearchDir.FullName -replace ':','-' -replace '\\','-'
    $TestPath = "$env:USERPROFILE\.claude\projects\$Slug"
    if (Test-Path $TestPath) {
        $LogPath = $TestPath
        break
    }
    $SearchDir = $SearchDir.Parent
}

if ($null -eq $LogPath) {
    Write-Host "ERRO: Nenhuma pasta de logs Claude encontrada para este projeto ou seus ancestrais"
    return
}

$Files = Get-ChildItem -Path $LogPath -Filter "*.jsonl"

$Sessions           = @()
$TotalInput         = [long]0
$TotalOutput        = [long]0
$TotalCacheRead     = [long]0
$TotalCacheCreation = [long]0

foreach ($File in $Files) {
    $SessInput         = [long]0
    $SessOutput        = [long]0
    $SessCacheRead     = [long]0
    $SessCacheCreation = [long]0
    $Models = @()

    $RawLines = Get-Content $File.FullName -ErrorAction SilentlyContinue
    foreach ($Line in $RawLines) {
        if ($Line -match '"type":"assistant"') {
            try {
                $d = $Line | ConvertFrom-Json -ErrorAction SilentlyContinue
                if ($null -ne $d -and $null -ne $d.message -and $null -ne $d.message.usage) {
                    $u = $d.message.usage
                    $SessInput         += [long]$u.input_tokens
                    $SessOutput        += [long]$u.output_tokens
                    $SessCacheRead     += [long]$u.cache_read_input_tokens
                    $SessCacheCreation += [long]$u.cache_creation_input_tokens
                    $m = $d.message.model
                    if ($null -ne $m -and ($Models -notcontains $m)) { $Models += $m }
                }
            } catch {}
        }
    }

    if (($SessInput + $SessOutput) -gt 0) {
        $Sessions += [PSCustomObject]@{
            Date          = $File.LastWriteTime.ToString("yyyy-MM-dd HH:mm")
            Session       = $File.BaseName.Substring(0, [Math]::Min(8, $File.BaseName.Length))
            Models        = if ($Models.Count -gt 0) { $Models -join ", " } else { "-" }
            Input         = $SessInput
            Output        = $SessOutput
            CacheRead     = $SessCacheRead
            CacheCreation = $SessCacheCreation
        }
        $TotalInput         += $SessInput
        $TotalOutput        += $SessOutput
        $TotalCacheRead     += $SessCacheRead
        $TotalCacheCreation += $SessCacheCreation
    }
}

# --- Build Claude section ---
$ClaudeLines = [System.Collections.Generic.List[string]]::new()
$ClaudeLines.Add("<!-- BEGIN:CLAUDE -->")
$ClaudeLines.Add("## Claude")
$ClaudeLines.Add("")
$ClaudeLines.Add("| Data | Sessao | Modelos | Input | Output | Cache Read | Cache Created |")
$ClaudeLines.Add("|------|--------|---------|------:|-------:|-----------:|--------------:|")
foreach ($S in ($Sessions | Sort-Object Date)) {
    $ClaudeLines.Add("| $($S.Date) | $($S.Session) | $($S.Models) | $(Fmt $S.Input) | $(Fmt $S.Output) | $(Fmt $S.CacheRead) | $(Fmt $S.CacheCreation) |")
}
$ClaudeLines.Add("")
$ClaudeLines.Add("**Subtotal:** Input $BT$(Fmt $TotalInput)$BT $MDOT Output $BT$(Fmt $TotalOutput)$BT $MDOT Cache Read $BT$(Fmt $TotalCacheRead)$BT $MDOT Cache Created $BT$(Fmt $TotalCacheCreation)$BT")
$ClaudeLines.Add("<!-- END:CLAUDE -->")
$ClaudeSection = [string]::Join([System.Environment]::NewLine, $ClaudeLines)

# --- Read existing file and extract Gemini subtotals ---
$ExistingContent = if (Test-Path $CostsFile) { Get-Content $CostsFile -Raw } else { "" }

$GeminiInput  = [long]0
$GeminiOutput = [long]0
$GeminiCached = [long]0
if ($ExistingContent -match '(?s)<!-- BEGIN:GEMINI -->.*?\*\*Subtotal:\*\* Input `([\d.]+)`[^`]*Output `([\d.]+)`[^`]*Cached `([\d.]+)`') {
    $GeminiInput  = [long]($Matches[1] -replace '\.','')
    $GeminiOutput = [long]($Matches[2] -replace '\.','')
    $GeminiCached = [long]($Matches[3] -replace '\.','')
}

# Preserve Gemini section or initialize empty
$GeminiSection = if ($ExistingContent -match '(?s)(<!-- BEGIN:GEMINI -->.*?<!-- END:GEMINI -->)') {
    $Matches[1].Trim()
} else {
    $EmptyLines = [System.Collections.Generic.List[string]]::new()
    $EmptyLines.Add("<!-- BEGIN:GEMINI -->")
    $EmptyLines.Add("## Gemini")
    $EmptyLines.Add("")
    $EmptyLines.Add("| Data | Sessao | Modelos | Input | Output | Cached |")
    $EmptyLines.Add("|------|--------|---------|------:|-------:|-------:|")
    $EmptyLines.Add("")
    $EmptyLines.Add("**Subtotal:** Input ${BT}0${BT} $MDOT Output ${BT}0${BT} $MDOT Cached ${BT}0${BT}")
    $EmptyLines.Add("<!-- END:GEMINI -->")
    [string]::Join([System.Environment]::NewLine, $EmptyLines)
}

# --- Total Consolidado ---
$ConsolidadoInput         = $TotalInput + $GeminiInput
$ConsolidadoOutput        = $TotalOutput + $GeminiOutput
$ConsolidadoCacheCreation = $TotalCacheCreation   # Gemini nao rastreia cache creation
$ConsolidadoCacheRead     = $TotalCacheRead + $GeminiCached

$ConsolidadoLines = [System.Collections.Generic.List[string]]::new()
$ConsolidadoLines.Add("## Total Consolidado")
$ConsolidadoLines.Add("")
$ConsolidadoLines.Add("| LLM | Input | Output | Cache Creation | Cache Read |")
$ConsolidadoLines.Add("|-----|------:|-------:|---------------:|-----------:|")
$ConsolidadoLines.Add("| Claude | $(Fmt $TotalInput) | $(Fmt $TotalOutput) | $(Fmt $TotalCacheCreation) | $(Fmt $TotalCacheRead) |")
$ConsolidadoLines.Add("| Gemini | $(Fmt $GeminiInput) | $(Fmt $GeminiOutput) | 0 | $(Fmt $GeminiCached) |")
$ConsolidadoLines.Add("| **TOTAL** | **$(Fmt $ConsolidadoInput)** | **$(Fmt $ConsolidadoOutput)** | **$(Fmt $ConsolidadoCacheCreation)** | **$(Fmt $ConsolidadoCacheRead)** |")
$TotalConsolidado = [string]::Join([System.Environment]::NewLine, $ConsolidadoLines)

# --- Write costs.md ---
$Now = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
$ContentLines = [System.Collections.Generic.List[string]]::new()
$ContentLines.Add("# Custos de Tokens $EM Projeto: $ProjectName")
$ContentLines.Add("")
$ContentLines.Add("_Atualizado em: $($Now)_")
$ContentLines.Add("")
$ContentLines.Add("---")
$ContentLines.Add("")
$ContentLines.Add($ClaudeSection)
$ContentLines.Add("")
$ContentLines.Add("---")
$ContentLines.Add("")
$ContentLines.Add($GeminiSection)
$ContentLines.Add("")
$ContentLines.Add("---")
$ContentLines.Add("")
$ContentLines.Add($TotalConsolidado)
[string]::Join([System.Environment]::NewLine, $ContentLines) | Out-File $CostsFile -Encoding UTF8

Write-Host "Custos Claude salvos em: $CostsFile"
Write-Host "Input $(Fmt $TotalInput) $MDOT Output $(Fmt $TotalOutput) $MDOT Cache Read $(Fmt $TotalCacheRead) $MDOT Cache Created $(Fmt $TotalCacheCreation)"
