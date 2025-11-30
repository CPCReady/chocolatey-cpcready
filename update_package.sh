#!/bin/bash

# Script para actualizar el paquete de Chocolatey
# Uso: ./update_package.sh <version>

set -e

VERSION=$1

if [ -z "$VERSION" ]; then
    echo "Error: Version required"
    echo "Usage: ./update_package.sh 1.2.0"
    exit 1
fi

echo "Updating Chocolatey package to version $VERSION"

# Calcular SHA256
TARBALL_URL="https://github.com/CPCReady/cpc/archive/refs/tags/v${VERSION}.tar.gz"
echo "Downloading tarball from $TARBALL_URL"
SHA256=$(curl -sL "$TARBALL_URL" | shasum -a 256 | cut -d' ' -f1)

if [ -z "$SHA256" ]; then
    echo "Error: Failed to calculate SHA256"
    exit 1
fi

echo "SHA256: $SHA256"

# Actualizar nuspec
sed -i.bak "s|<version>.*</version>|<version>${VERSION}</version>|" cpc/cpc.nuspec
sed -i.bak "s|/releases/tag/v.*\"|/releases/tag/v${VERSION}\"|" cpc/cpc.nuspec
rm -f cpc/cpc.nuspec.bak

# Actualizar chocolateyinstall.ps1
sed -i.bak "s|\$version = '.*'|\$version = '${VERSION}'|" cpc/tools/chocolateyinstall.ps1
sed -i.bak "s|\$checksum = '.*'|\$checksum = '${SHA256}'|" cpc/tools/chocolateyinstall.ps1
rm -f cpc/tools/chocolateyinstall.ps1.bak

echo "Package updated to version $VERSION"
echo ""
echo "Next steps:"
echo "1. Review changes: git diff"
echo "2. Commit: git add -A && git commit -m 'chore: update package to v${VERSION}'"
echo "3. Tag: git tag v${VERSION}"
echo "4. Push: git push && git push --tags"
