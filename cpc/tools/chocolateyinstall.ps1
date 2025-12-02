$ErrorActionPreference = 'Stop'

$packageName = 'cpc'
$version = '1.1.0'
$url = "https://github.com/CPCReady/cpc/archive/refs/tags/v0.1.3.tar.gz"
$checksum = 'df07129b114cc9e3d5e633f54a89a566110c1500f343ca6c17a1db7905ffb0f1'
$checksumType = 'sha256'

# Verificar que Python 3.13 está instalado
$pythonPath = Get-Command python -ErrorAction SilentlyContinue
if (-not $pythonPath) {
    Write-Error "Python 3.13+ is required but not found. Please install Python first."
    exit 1
}

$pythonVersion = & python --version 2>&1
if ($pythonVersion -notmatch "Python 3\.1[3-9]") {
    Write-Error "Python 3.13+ is required. Found: $pythonVersion"
    exit 1
}

Write-Host "Using Python: $pythonVersion" -ForegroundColor Green

# Descargar y extraer el código fuente
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$extractDir = Join-Path $toolsDir "cpc-$version"

$packageArgs = @{
    packageName   = $packageName
    url           = $url
    checksum      = $checksum
    checksumType  = $checksumType
    unzipLocation = $toolsDir
}

Install-ChocolateyZipPackage @packageArgs

# Renombrar el directorio extraído
$extractedDir = Join-Path $toolsDir "cpc-$version"
if (Test-Path $extractedDir) {
    Remove-Item $extractedDir -Recurse -Force -ErrorAction SilentlyContinue
}
Rename-Item (Join-Path $toolsDir "cpc-$version") $extractedDir -Force

# Instalar con pip
Push-Location $extractedDir
try {
    Write-Host "Installing CPCReady with pip..." -ForegroundColor Cyan
    
    # Instalar usando pip
    & python -m pip install --upgrade pip
    & python -m pip install .
    
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to install CPCReady"
    }
    
    Write-Host "CPCReady installed successfully!" -ForegroundColor Green
    
    # Verificar instalación
    $cpcPath = Get-Command cpc -ErrorAction SilentlyContinue
    if ($cpcPath) {
        Write-Host "CPC command available at: $($cpcPath.Source)" -ForegroundColor Green
        & cpc --version
    } else {
        Write-Warning "CPC command not found in PATH. You may need to restart your terminal."
    }
} finally {
    Pop-Location
}

# Crear shim para el ejecutable
$pythonScriptsPath = & python -c "import sysconfig; print(sysconfig.get_path('scripts'))"
$cpcExe = Join-Path $pythonScriptsPath "cpc.exe"

if (Test-Path $cpcExe) {
    Install-BinFile -Name 'cpc' -Path $cpcExe
} else {
    Write-Warning "Could not find cpc.exe at $cpcExe"
}
