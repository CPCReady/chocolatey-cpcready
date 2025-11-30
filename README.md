# Chocolatey CPCReady Package

This repository contains the Chocolatey package for CPCReady.

## Installation

```powershell
choco install cpc
```

## Verify Installation

```powershell
cpc --version
```

## Usage

```powershell
# Create a new disk
cpc disc new mydisk.dsk

# Insert disk in drive A
cpc drive A mydisk.dsk

# List files
cpc cat

# Save a file to disk
cpc save myfile.bas

# Run in emulator
cpc run
```

## Requirements

- Windows 10 or later
- Python 3.13+
- Chocolatey package manager

## Package Structure

```
cpc/
├── cpc.nuspec                      # Package metadata
└── tools/
    ├── chocolateyinstall.ps1       # Installation script
    └── chocolateyuninstall.ps1     # Uninstallation script
```

## Building the Package

```powershell
# From the cpc directory
choco pack

# Test locally
choco install cpc -source .

# Uninstall
choco uninstall cpc
```

## Publishing

```powershell
# Push to Chocolatey Community Repository
choco push cpc.1.1.0.nupkg --source https://push.chocolatey.org/
```

## Updating the Package

1. Update version in `cpc.nuspec`
2. Update version and checksum in `tools/chocolateyinstall.ps1`
3. Update release notes URL in `cpc.nuspec`
4. Build and test the package
5. Push to Chocolatey repository

## Links

- [CPCReady on GitHub](https://github.com/CPCReady/cpc)
- [Chocolatey Package Guidelines](https://docs.chocolatey.org/en-us/create/create-packages)
- [CPCReady Documentation](https://github.com/CPCReady/cpc#readme)

## License

MIT License - See [LICENSE](https://github.com/CPCReady/cpc/blob/main/LICENSE.md)
