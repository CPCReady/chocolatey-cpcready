$ErrorActionPreference = 'Stop'

$packageName = 'cpc'

Write-Host "Uninstalling CPCReady..." -ForegroundColor Cyan

# Desinstalar con pip
try {
    & python -m pip uninstall -y cpcready
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "CPCReady uninstalled successfully!" -ForegroundColor Green
    }
} catch {
    Write-Warning "Failed to uninstall CPCReady: $_"
}

# Eliminar shim
Uninstall-BinFile -Name 'cpc'

Write-Host "CPCReady has been removed." -ForegroundColor Green
