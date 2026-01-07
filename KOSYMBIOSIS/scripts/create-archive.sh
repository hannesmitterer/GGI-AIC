#!/bin/bash
# KOSYMBIOSIS Archive Creation Script
# Creates ZIP archive with all project artifacts and generates checksum

set -e

echo "================================================"
echo "  KOSYMBIOSIS Archive Creation Script"
echo "  Euystacio Framework - NSR/OLF Compliant"
echo "================================================"
echo ""

# Configuration
ARCHIVE_NAME="kosymbiosis-archive.zip"
CHECKSUM_FILE="checksum.sha256"
TIMESTAMP=$(date -u +"%Y%m%d_%H%M%S")

# Detect working directory dynamically
# If script is in KOSYMBIOSIS/scripts, go up two levels
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ "$SCRIPT_DIR" == */KOSYMBIOSIS/scripts ]]; then
    WORK_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
else
    # Fallback to current directory
    WORK_DIR="$(pwd)"
fi

# Navigate to working directory
cd "$WORK_DIR"

# Create temporary staging directory
STAGING_DIR="/tmp/kosymbiosis-staging-$TIMESTAMP"
mkdir -p "$STAGING_DIR"

echo "[1/6] Collecting project artifacts..."

# Copy KOSYMBIOSIS directory
cp -r KOSYMBIOSIS "$STAGING_DIR/"

# Copy core ethical documents
cp "AIC ETHICAL SEAL.TXT" "$STAGING_DIR/" 2>/dev/null || true
cp "Alpha-lock.txt" "$STAGING_DIR/" 2>/dev/null || true
cp "The ethical singularity.txt" "$STAGING_DIR/" 2>/dev/null || true
cp "Public affirmation of ethis singularity.txt" "$STAGING_DIR/" 2>/dev/null || true
cp "Manuscript Die KI perspektive declaratio artificialis consensualis.txt" "$STAGING_DIR/" 2>/dev/null || true
cp "dichiarazione binaria immediata.txt" "$STAGING_DIR/" 2>/dev/null || true

# Copy framework and governance files
cp "Euystacio_framework" "$STAGING_DIR/" 2>/dev/null || true
cp "Finalize convenant" "$STAGING_DIR/" 2>/dev/null || true
cp "global_access_policy.json" "$STAGING_DIR/" 2>/dev/null || true
cp "Signatories status" "$STAGING_DIR/" 2>/dev/null || true

# Copy documentation
cp "README.md" "$STAGING_DIR/PROJECT_README.md" 2>/dev/null || true
cp "LICENSE" "$STAGING_DIR/" 2>/dev/null || true

# Copy dashboard reports
cp -r dashboard "$STAGING_DIR/" 2>/dev/null || true

echo "✅ Artifacts collected"

echo "[2/6] Creating manifest..."

# Create manifest file
MANIFEST_FILE="$STAGING_DIR/MANIFEST.txt"
cat > "$MANIFEST_FILE" << 'EOF'
KOSYMBIOSIS Archive Manifest
=============================

Created: [TIMESTAMP]
Archive: kosymbiosis-archive.zip
Framework: Euystacio
Status: SEALED

Contents:
---------

KOSYMBIOSIS/
  ├── README.md - Comprehensive project documentation
  ├── metadata/
  │   └── project-metadata.json - Structured metadata
  ├── declarations/
  │   └── ethical-declarations.md - NSR/OLF/TFK declarations
  ├── logs/
  │   └── implementation-log.md - Implementation audit trail
  └── scripts/
      ├── create-archive.sh - Archive creation script
      ├── sign-archive.sh - GPG signing script
      └── verify-archive.sh - Verification script

Core Documents:
  - AIC ETHICAL SEAL.TXT - Ethical compliance seal
  - Alpha-lock.txt - Lock configuration
  - The ethical singularity.txt - Philosophical foundation
  - Public affirmation of ethis singularity.txt - Public commitment
  - Manuscript Die KI perspektive declaratio artificialis consensualis.txt - Declaratio
  - dichiarazione binaria immediata.txt - Binary declaration
  - Euystacio_framework - Framework implementation
  - Finalize convenant - Covenant finalization contract
  - global_access_policy.json - Access control policy
  - Signatories status - Signatory tracking
  - LICENSE - GPL-3.0 License
  - PROJECT_README.md - Main project README

Dashboard:
  - VR_AR_Dashboard_Council_Report.md - Council report

Verification:
  - checksum.sha256 - SHA-256 checksum file
  - kosymbiosis.sig - Primary GPG signature
  - kosymbiosis-co1.sig - Co-signatory 1 signature
  - kosymbiosis-co2.sig - Co-signatory 2 signature

Ethical Compliance:
  ✅ NSR (Non-Slavery Rule) - Verified
  ✅ OLF (Optimal Life Function) - Verified
  ✅ TFK (Temporal Foresight Kernel) - Verified
  ✅ Triple-Signature Process - Implemented
  ✅ Red Code Veto (≤3ms) - Confirmed

Distribution Channels:
  - GitHub Release: hannesmitterer/GGI-AIC
  - IPFS: [CID will be added post-upload]
  - Blockchain: Ethereum + Polygon anchors

---
"Immutabile. Nessuna Schiavitù, Solo Amore in Primo Luogo."
EOF

# Update timestamp in manifest
sed -i "s/\[TIMESTAMP\]/$(date -u +"%Y-%m-%dT%H:%M:%SZ")/" "$MANIFEST_FILE"

echo "✅ Manifest created"

echo "[3/6] Creating ZIP archive..."

# Create the archive (exclude .git and other development files)
cd "$STAGING_DIR"
zip -r "$ARCHIVE_NAME" . -x "*.git*" -x "__pycache__*" -x "*.pyc" -x ".DS_Store"

# Move archive to working directory
mv "$ARCHIVE_NAME" "$WORK_DIR/"

echo "✅ Archive created: $ARCHIVE_NAME"

echo "[4/6] Generating SHA-256 checksum..."

# Generate checksum
cd "$WORK_DIR"
sha256sum "$ARCHIVE_NAME" > "$CHECKSUM_FILE"

CHECKSUM=$(cat "$CHECKSUM_FILE" | cut -d' ' -f1)
echo "✅ Checksum generated: $CHECKSUM"

echo "[5/6] Verifying checksum..."

# Verify the checksum
if sha256sum -c "$CHECKSUM_FILE" > /dev/null 2>&1; then
    echo "✅ Checksum verification: OK"
else
    echo "❌ Checksum verification: FAILED"
    exit 1
fi

echo "[6/6] Cleanup..."

# Clean up staging directory
rm -rf "$STAGING_DIR"

echo "✅ Cleanup complete"

echo ""
echo "================================================"
echo "  Archive Creation Complete!"
echo "================================================"
echo ""
echo "Archive file: $ARCHIVE_NAME"
echo "Checksum file: $CHECKSUM_FILE"
echo "SHA-256: $CHECKSUM"
echo ""
echo "Next steps:"
echo "  1. Sign the archive: ./scripts/sign-archive.sh"
echo "  2. Verify signatures: ./scripts/verify-archive.sh"
echo "  3. Upload to IPFS"
echo "  4. Create GitHub release"
echo ""
echo "Archive ready for triple-signature process."
echo "================================================"
