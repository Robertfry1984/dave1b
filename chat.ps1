Param(
    [string]$ModelPath = "$PSScriptRoot/llama-3.2-1b-instruct-q4_k_m.gguf",
    [int]$Threads = -1,
    [int]$Ctx = 4096,
    [int]$NPredict = -1
)

if ($Threads -le 0) {
    try {
        $Threads = (Get-CimInstance -ClassName Win32_Processor | Measure-Object NumberOfLogicalProcessors -Sum).Sum
    } catch {
        $Threads = [Environment]::ProcessorCount
    }
}

$exe = Join-Path $PSScriptRoot 'llama-cli.exe'
if (-not (Test-Path $exe)) { throw "llama-cli.exe not found in $PSScriptRoot" }
if (-not (Test-Path $ModelPath)) { throw "Model file not found: $ModelPath" }

Write-Host "Starting interactive chat on CPU with $Threads threads..." -ForegroundColor Cyan

& $exe `
  -m $ModelPath `
  -ngl 0 `
  -t $Threads `
  -c $Ctx `
  -n $NPredict `
  --color `
  --prompt "" `
  -i `
  -r "</s>" `
  -sys "You are a helpful assistant." 
