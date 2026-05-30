 param (
     [string]$ProjectName = (Get-Item .).Name.ToLower(),
     [string]$ReportFile  = "$($ProjectName)_tokens.json",
     [string]$CostsFile   = "memory/costs.md"
 )

 function Fmt([long]$n) {
     [string]::Format([System.Globalization.CultureInfo]::InvariantCulture, "{0:N0}", $n) -replace ',','.'
 }

 $LogPath = "$env:USERPROFILE\.gemini\tmp\$ProjectName\chats"

 if (-not (Test-Path $LogPath)) {
     Write-Host "ERRO: Pasta de logs nao encontrada em $LogPath"
     return
 }

 $Files = Get-ChildItem -Path $LogPath -Filter "*.jsonl"
 $ConsolidatedData = @{
     Project = $ProjectName
     GeneratedAt = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
     Sessions = @()
     Totals = @{
         InputTokens  = 0
         OutputTokens = 0
         CachedTokens = 0
     }
 }

 foreach ($File in $Files) {
     $SessionInput  = 0
     $SessionOutput = 0
     $SessionCached = 0
     $ModelsUsed    = @()

     $Lines = Get-Content $File.FullName
     foreach ($Line in $Lines) {
         if ($Line -match '"type":"gemini"') {
             try {
                 $Data = $Line | ConvertFrom-Json -ErrorAction SilentlyContinue
                 if ($Data.tokens) {
                     $Model  = $Data.model
                     $Input  = [int]$Data.tokens.input
                     $Output = [int]$Data.tokens.output
                     $Cached = [int]($Data.tokens.cached -or 0)

                     $SessionInput  += $Input
                     $SessionOutput += $Output
                     $SessionCached += $Cached

                     if ($ModelsUsed -notcontains $Model) { $ModelsUsed += $Model }
                 }
             } catch {}
         }
     }

     if ($SessionInput -gt 0) {
         $ConsolidatedData.Sessions += [PSCustomObject]@{
             Date   = $File.LastWriteTime.ToString("yyyy-MM-dd HH:mm")
             File   = $File.Name
             Models = $ModelsUsed -join ", "
             Input  = $SessionInput
             Output = $SessionOutput
             Cached = $SessionCached
         }
         $ConsolidatedData.Totals.InputTokens  += $SessionInput
         $ConsolidatedData.Totals.OutputTokens += $SessionOutput
         $ConsolidatedData.Totals.CachedTokens += $SessionCached
     }
 }

 $ConsolidatedData | ConvertTo-Json -Depth 10 | Out-File $ReportFile -Encoding UTF8

 Write-Host "===================================================="
 Write-Host " CONSUMO DE TOKENS - PROJETO: $ProjectName"
 Write-Host "===================================================="
 $ConsolidatedData.Sessions | Sort-Object Date | Select-Object Date, Input, Output, Cached | Format-Table -AutoSize

 Write-Host "RESUMO CONSOLIDADO:"
 Write-Host "Total Input Tokens:  $($ConsolidatedData.Totals.InputTokens)"
 Write-Host "Total Output Tokens: $($ConsolidatedData.Totals.OutputTokens)"
 Write-Host "Total Cached Tokens: $($ConsolidatedData.Totals.CachedTokens)"
 Write-Host "----------------------------------------------------"
 Write-Host "Detalhes salvos em: $ReportFile"

 # --- Write costs.md ---
 $EM   = [char]0x2014   # em dash
 $MDOT = [char]0x00B7   # middle dot
 $BT   = [char]96       # backtick

 $TotInput  = [long]$ConsolidatedData.Totals.InputTokens
 $TotOutput = [long]$ConsolidatedData.Totals.OutputTokens
 $TotCached = [long]$ConsolidatedData.Totals.CachedTokens

 $GeminiLines = [System.Collections.Generic.List[string]]::new()
 $GeminiLines.Add("<!-- BEGIN:GEMINI -->")
 $GeminiLines.Add("## Gemini")
 $GeminiLines.Add("")
 $GeminiLines.Add("| Data | Sessao | Modelos | Input | Output | Cached |")
 $GeminiLines.Add("|------|--------|---------|------:|-------:|-------:|")
 foreach ($S in ($ConsolidatedData.Sessions | Sort-Object Date)) {
     $FileBase = [System.IO.Path]::GetFileNameWithoutExtension($S.File)
     $SessId   = $FileBase.Substring(0, [Math]::Min(8, $FileBase.Length))
     $GeminiLines.Add("| $($S.Date) | $SessId | $($S.Models) | $(Fmt ([long]$S.Input)) | $(Fmt ([long]$S.Output)) | $(Fmt ([long]$S.Cached)) |")
 }
 $GeminiLines.Add("")
 $GeminiLines.Add("**Subtotal:** Input $BT$(Fmt $TotInput)$BT $MDOT Output $BT$(Fmt $TotOutput)$BT $MDOT Cached $BT$(Fmt $TotCached)$BT")
 $GeminiLines.Add("<!-- END:GEMINI -->")
 $GeminiSection = [string]::Join([System.Environment]::NewLine, $GeminiLines)

 $ExistingContent = if (Test-Path $CostsFile) { Get-Content $CostsFile -Raw } else { "" }

 $ClaudeInput         = [long]0
 $ClaudeOutput        = [long]0
 $ClaudeCacheRead     = [long]0
 $ClaudeCacheCreation = [long]0
 if ($ExistingContent -match '(?s)<!-- BEGIN:CLAUDE -->.*?\*\*Subtotal:\*\* Input `([\d.]+)`[^`]*Output `([\d.]+)`[^`]*Cache Read `([\d.]+)`[^`]*Cache Created `([\d.]+)`') {
     $ClaudeInput         = [long]($Matches[1] -replace '\.','')
     $ClaudeOutput        = [long]($Matches[2] -replace '\.','')
     $ClaudeCacheRead     = [long]($Matches[3] -replace '\.','')
     $ClaudeCacheCreation = [long]($Matches[4] -replace '\.','')
 }

 $ClaudeSection = if ($ExistingContent -match '(?s)(<!-- BEGIN:CLAUDE -->.*?<!-- END:CLAUDE -->)') {
     $Matches[1].Trim()
 } else {
     $EmptyLines = [System.Collections.Generic.List[string]]::new()
     $EmptyLines.Add("<!-- BEGIN:CLAUDE -->")
     $EmptyLines.Add("## Claude")
     $EmptyLines.Add("")
     $EmptyLines.Add("| Data | Sessao | Modelos | Input | Output | Cache Read | Cache Created |")
     $EmptyLines.Add("|------|--------|---------|------:|-------:|-----------:|--------------:|")
     $EmptyLines.Add("")
     $EmptyLines.Add("**Subtotal:** Input ${BT}0${BT} $MDOT Output ${BT}0${BT} $MDOT Cache Read ${BT}0${BT} $MDOT Cache Created ${BT}0${BT}")
     $EmptyLines.Add("<!-- END:CLAUDE -->")
     [string]::Join([System.Environment]::NewLine, $EmptyLines)
 }

 $ConsolidadoInput         = $ClaudeInput + $TotInput
 $ConsolidadoOutput        = $ClaudeOutput + $TotOutput
 $ConsolidadoCacheCreation = $ClaudeCacheCreation   # Gemini nao rastreia cache creation
 $ConsolidadoCacheRead     = $ClaudeCacheRead + $TotCached

 $ConsolidadoLines = [System.Collections.Generic.List[string]]::new()
 $ConsolidadoLines.Add("## Total Consolidado")
 $ConsolidadoLines.Add("")
 $ConsolidadoLines.Add("| LLM | Input | Output | Cache Creation | Cache Read |")
 $ConsolidadoLines.Add("|-----|------:|-------:|---------------:|-----------:|")
 $ConsolidadoLines.Add("| Claude | $(Fmt $ClaudeInput) | $(Fmt $ClaudeOutput) | $(Fmt $ClaudeCacheCreation) | $(Fmt $ClaudeCacheRead) |")
 $ConsolidadoLines.Add("| Gemini | $(Fmt $TotInput) | $(Fmt $TotOutput) | 0 | $(Fmt $TotCached) |")
 $ConsolidadoLines.Add("| **TOTAL** | **$(Fmt $ConsolidadoInput)** | **$(Fmt $ConsolidadoOutput)** | **$(Fmt $ConsolidadoCacheCreation)** | **$(Fmt $ConsolidadoCacheRead)** |")
 $TotalConsolidado = [string]::Join([System.Environment]::NewLine, $ConsolidadoLines)

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

 Write-Host "Custos Gemini salvos em: $CostsFile"
