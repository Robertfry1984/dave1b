Param(
  [int]$Threads = -1,
  [int]$Ctx = 4096,
  [int]$Port = 51113
)

if ($Threads -le 0) {
  try { $Threads = (Get-CimInstance -ClassName Win32_Processor | Measure-Object NumberOfLogicalProcessors -Sum).Sum } catch { $Threads = [Environment]::ProcessorCount }
}

$root = Split-Path $PSScriptRoot -Parent
$exe = Join-Path $root 'llama-server.exe'
$ggufDir = Join-Path $PSScriptRoot 'gguf'
$gguf = Get-ChildItem -Path $ggufDir -Filter '*.gguf' | Select-Object -First 1
if (-not $gguf) { throw "GGUF model not found in $ggufDir" }
$model = $gguf.FullName

if (-not (Test-Path $exe)) { throw "llama-server.exe not found in $root" }

Write-Host "Starting server for Llama-3.2-1B-Instruct (GGUF) on http://localhost:$Port using $Threads threads" -ForegroundColor Cyan

& $exe `
  -m $model `
  -ngl 0 `
  -t $Threads `
  -c $Ctx `
  --host 127.0.0.1 `
  --port $Port


