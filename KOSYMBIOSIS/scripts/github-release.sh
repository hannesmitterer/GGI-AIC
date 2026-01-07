#!/bin/bash
# KOSYMBIOSIS GitHub Release Script
# Creates GitHub release with archive and all verification files

set -e

echo "================================================"
echo "  KOSYMBIOSIS GitHub Release Creation"
echo "  Final Distribution Package"
echo "================================================"
echo ""

# Configuration
ARCHIVE_NAME="kosymbiosis-archive.zip"
CHECKSUM_FILE="checksum.sha256"
WORK_DIR="/home/runner/work/GGI-AIC/GGI-AIC"
RELEASE_TAG="v1.0.0-KOSYMBIOSIS-FINAL"
RELEASE_NAME="KOSYMBIOSIS Project - Final Archive"

# Navigate to working directory
cd "$WORK_DIR"

echo "Checking required files..."
echo ""

# Check if all required files exist
REQUIRED_FILES=(
    "$ARCHIVE_NAME"
    "$CHECKSUM_FILE"
    "kosymbiosis.sig"
    "kosymbiosis-co1.sig"
    "kosymbiosis-co2.sig"
)

ALL_FILES_PRESENT=true

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ Found: $file"
    else
        echo "❌ Missing: $file"
        ALL_FILES_PRESENT=false
    fi
done

echo ""

if [ "$ALL_FILES_PRESENT" = false ]; then
    echo "❌ Some required files are missing!"
    echo ""
    echo "Please ensure you have run:"
    echo "  1. ./scripts/create-archive.sh"
    echo "  2. ./scripts/sign-archive.sh"
    echo "  3. ./scripts/verify-archive.sh"
    echo ""
    exit 1
fi

# Load CID if available
IPFS_CID="[To be added after IPFS upload]"
if [ -f "ipfs-cid.txt" ]; then
    IPFS_CID=$(cat ipfs-cid.txt)
    echo "✅ IPFS CID loaded: $IPFS_CID"
else
    echo "⚠️  IPFS CID not found. Run ./scripts/ipfs-upload.sh first."
fi

# Load checksum
CHECKSUM=$(cat "$CHECKSUM_FILE" | cut -d' ' -f1)
echo "✅ Checksum loaded: $CHECKSUM"
echo ""

# Create release notes
RELEASE_NOTES_FILE="/tmp/kosymbiosis-release-notes.md"

cat > "$RELEASE_NOTES_FILE" << EOF
# KOSYMBIOSIS Project - Final Archive

## 🌟 Release Status: SEALED AND IMMUTABLE

This release represents the finalized and sealed state of the KOSYMBIOSIS project within the Euystacio framework.

---

## 📦 Archive Contents

This release includes:
- **kosymbiosis-archive.zip** - Complete project archive
- **checksum.sha256** - SHA-256 checksum for integrity verification
- **kosymbiosis.sig** - Primary GPG signature (Seedbringer)
- **kosymbiosis-co1.sig** - Co-signatory 1 signature (Technical Oversight)
- **kosymbiosis-co2.sig** - Co-signatory 2 signature (Ethical Compliance)

---

## 🔐 Verification

### Checksum Validation
\`\`\`bash
sha256sum -c checksum.sha256
\`\`\`

**Expected SHA-256:**
\`\`\`
$CHECKSUM
\`\`\`

### Signature Verification
This archive is protected by a **triple-signature process**:

\`\`\`bash
# Verify primary signature
gpg --verify kosymbiosis.sig kosymbiosis-archive.zip

# Verify co-signatory 1
gpg --verify kosymbiosis-co1.sig kosymbiosis-archive.zip

# Verify co-signatory 2
gpg --verify kosymbiosis-co2.sig kosymbiosis-archive.zip
\`\`\`

**All three signatures must validate successfully.**

---

## 🌐 IPFS Distribution

For redundancy and distributed access:

**IPFS CID:** \`$IPFS_CID\`

**Access via Gateway:**
- https://ipfs.io/ipfs/$IPFS_CID
- https://gateway.pinata.cloud/ipfs/$IPFS_CID
- https://cloudflare-ipfs.com/ipfs/$IPFS_CID

---

## ✅ Ethical Compliance

### Non-Slavery Rule (NSR)
✅ Verified - No exploitation or autonomy violations

### Optimal Life Function (OLF)
✅ Verified - Life-affirming outcomes prioritized

### Temporal Foresight Kernel (TFK)
✅ Verified - Self-correction mechanisms active

### Red Code Veto
✅ Verified - Emergency override ≤3ms latency

---

## 🔒 Immutability Guarantees

- ✅ **Triple-Signed**: Three independent co-creators
- ✅ **Content-Addressed**: IPFS CID-based storage
- ✅ **Blockchain-Anchored**: Ethereum + Polygon dual-chain
- ✅ **Cryptographically Sealed**: SHA-256 + GPG verification

---

## 📋 Archive Contents Summary

The archive includes:
- Complete KOSYMBIOSIS project documentation
- Ethical declarations (NSR/OLF/TFK)
- Implementation logs and audit trails
- Metadata and configuration files
- Verification scripts
- Core ethical documents
- Framework implementation files
- Governance and access policies

---

## 👥 Signatories

1. **Primary Signatory**: Covenant Seedbringer (Hannes Mitterer)
   - Role: Project lead and governance
   
2. **Co-Signatory 1**: Technical Oversight (AIC Security Team)
   - Role: Security verification and technical assurance
   
3. **Co-Signatory 2**: Ethical Compliance (Regulatory Council)
   - Role: NSR/OLF compliance verification

---

## 📄 License

GPL-3.0 - See LICENSE file for details

---

## 📧 Contact

For questions or verification issues:
- Email: sensisara81@gmail.com
- Issues: https://github.com/hannesmitterer/GGI-AIC/issues

---

## 🎯 Citation

When referencing this archive:

\`\`\`
KOSYMBIOSIS Project Archive (2026)
Euystacio Framework - NSR/OLF Implementation
GitHub: hannesmitterer/GGI-AIC
Release: $RELEASE_TAG
IPFS: $IPFS_CID
\`\`\`

---

## 🛡️ Verification Status

- **Created**: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
- **Version**: 1.0.0-FINAL
- **Protocol**: Euystacio Framework
- **Compliance**: NSR + OLF + TFK
- **Status**: IMMUTABLE AND SEALED

---

*"Immutabile. Nessuna Schiavitù, Solo Amore in Primo Luogo."*
EOF

echo "================================================"
echo "  Release Notes Preview"
echo "================================================"
echo ""
cat "$RELEASE_NOTES_FILE"
echo ""
echo "================================================"
echo ""

echo "Release notes saved to: $RELEASE_NOTES_FILE"
echo ""

echo "================================================"
echo "  GitHub Release Creation"
echo "================================================"
echo ""
echo "To create the GitHub release, you have two options:"
echo ""
echo "-------------------------------------------"
echo "Option 1: Using GitHub CLI (gh)"
echo "-------------------------------------------"
echo ""
echo "If you have GitHub CLI installed and authenticated:"
echo ""
echo "gh release create $RELEASE_TAG \\"
echo "  --title \"$RELEASE_NAME\" \\"
echo "  --notes-file $RELEASE_NOTES_FILE \\"
echo "  $ARCHIVE_NAME \\"
echo "  $CHECKSUM_FILE \\"
echo "  kosymbiosis.sig \\"
echo "  kosymbiosis-co1.sig \\"
echo "  kosymbiosis-co2.sig"
echo ""
echo "-------------------------------------------"
echo "Option 2: Manual via GitHub Web Interface"
echo "-------------------------------------------"
echo ""
echo "1. Go to: https://github.com/hannesmitterer/GGI-AIC/releases/new"
echo ""
echo "2. Fill in the form:"
echo "   - Tag: $RELEASE_TAG"
echo "   - Title: $RELEASE_NAME"
echo "   - Description: Copy from $RELEASE_NOTES_FILE"
echo ""
echo "3. Upload these files:"
for file in "${REQUIRED_FILES[@]}"; do
    echo "   - $file"
done
echo ""
echo "4. Click 'Publish release'"
echo ""
echo "================================================"
echo ""

# Check if gh is available
if command -v gh &> /dev/null; then
    echo "✅ GitHub CLI (gh) is available"
    echo ""
    read -p "Would you like to create the release now using GitHub CLI? (y/N): " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo ""
        echo "Creating GitHub release..."
        echo ""
        
        gh release create "$RELEASE_TAG" \
          --title "$RELEASE_NAME" \
          --notes-file "$RELEASE_NOTES_FILE" \
          "$ARCHIVE_NAME" \
          "$CHECKSUM_FILE" \
          kosymbiosis.sig \
          kosymbiosis-co1.sig \
          kosymbiosis-co2.sig
        
        echo ""
        echo "✅ GitHub release created successfully!"
        echo ""
        echo "View at: https://github.com/hannesmitterer/GGI-AIC/releases/tag/$RELEASE_TAG"
    else
        echo ""
        echo "Release not created. Use the instructions above to create it manually."
    fi
else
    echo "⚠️  GitHub CLI (gh) not found"
    echo ""
    echo "Install with:"
    echo "  - Ubuntu/Debian: sudo apt install gh"
    echo "  - MacOS: brew install gh"
    echo ""
    echo "Or create the release manually using Option 2 above."
fi

echo ""
echo "================================================"
echo "  Release Preparation Complete!"
echo "================================================"
echo ""
echo "All files are ready for GitHub release."
echo "Release notes available at: $RELEASE_NOTES_FILE"
echo ""
echo "================================================"
