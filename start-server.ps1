Param(
    [string]$ModelPath = "$PSScriptRoot/llama-3.2-1b-instruct-q4_k_m.gguf",
    [int]$Threads = -1,
    [int]$Ctx = 4096,
    [int]$Port = 51113
)

if ($Threads -le 0) {
    try {
        $Threads = (Get-CimInstance -ClassName Win32_Processor | Measure-Object NumberOfLogicalProcessors -Sum).Sum
    } catch {
        $Threads = [Environment]::ProcessorCount
    }
}

$exe = Join-Path $PSScriptRoot 'llama-server.exe'
if (-not (Test-Path $exe)) { throw "llama-server.exe not found in $PSScriptRoot" }
if (-not (Test-Path $ModelPath)) { throw "Model file not found: $ModelPath" }

Write-Host "Starting llama.cpp server on http://localhost:$Port (CPU, $Threads threads)" -ForegroundColor Cyan

$env:LLAMA_LOG_COLORS = 'on'

Start-Process -FilePath $exe -ArgumentList @(
  '-m', $ModelPath,
  '-ngl', '0',
  '-t', $Threads,
  '-c', $Ctx,
  '--host', '127.0.0.1',
  '--port', $Port
) -NoNewWindow

Start-Sleep -Seconds 1

try { Start-Process "http://localhost:$Port" } catch {}

