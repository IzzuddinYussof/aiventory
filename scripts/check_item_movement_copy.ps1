param(
  [string]$TargetFile = "lib/item_movement_history/item_movement_history_widget.dart"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $TargetFile)) {
  Write-Error "Target file not found: $TargetFile"
  exit 2
}

# Legacy EN literals that should not reappear in user-visible copy.
$denyList = @(
  'Item Movement History',
  'Swipe left on a movement row to delete.',
  'Retry',
  'No movement history found.',
  'Previous',
  'Next',
  'Delete failed',
  'Movement not found',
  'Invalid delete request',
  'Request ID',
  'Delete movement?',
  'Unable to load item movement history.',
  'No expiry',
  'Movement #',
  'records'
)

# Identifier/token strings that are allowed and should not fail this check.
$allowTokenPattern = '^(nextPage|_nextPage|canGoNext|next_page)$'

$content = Get-Content -LiteralPath $TargetFile -Raw

# Match quoted string literals only.
$literalRegex = '(?<q>["''])[\s\S]*?\k<q>'
$literals = [regex]::Matches($content, $literalRegex)

$violations = @()

foreach ($m in $literals) {
  $raw = $m.Value
  if ($raw.Length -lt 2) { continue }

  $unquoted = $raw.Substring(1, $raw.Length - 2)
  $normalized = $unquoted.Trim()

  if ([string]::IsNullOrWhiteSpace($normalized)) { continue }
  if ($normalized -match $allowTokenPattern) { continue }

  if ($denyList -contains $normalized) {
    $prefix = $content.Substring(0, $m.Index)
    $line = ($prefix -split "`n").Length

    $contextStart = [Math]::Max(0, $m.Index - 40)
    $contextLength = [Math]::Min($content.Length - $contextStart, $m.Length + 80)
    $context = $content.Substring($contextStart, $contextLength).Replace("`r", ' ').Replace("`n", ' ')

    $violations += [pscustomobject]@{
      line = $line
      literal = $normalized
      context = $context
    }
  }
}

if ($violations.Count -gt 0) {
  Write-Host "[FAIL] Copy regression detected in $TargetFile" -ForegroundColor Red
  $violations | Sort-Object line | ForEach-Object {
    Write-Host ("- line {0}: `"{1}`"" -f $_.line, $_.literal)
    Write-Host ("  context: {0}" -f $_.context)
  }
  exit 1
}

Write-Host "[PASS] No denied EN UI literals detected in $TargetFile"
exit 0
