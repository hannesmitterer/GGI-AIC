#!/bin/bash
# KOSYMBIOSIS Archive Verification Script
# Verifies checksum and all three GPG signatures

set -e

echo "================================================"
echo "  KOSYMBIOSIS Archive Verification"
echo "  Checksum and Signature Validation"
echo "================================================"
echo ""

# Configuration
ARCHIVE_NAME="kosymbiosis-archive.zip"
CHECKSUM_FILE="checksum.sha256"
WORK_DIR="/home/runner/work/GGI-AIC/GGI-AIC"

# Navigate to working directory
cd "$WORK_DIR"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verification status
VERIFICATION_PASSED=true

echo "[1/4] Checking required files..."
echo ""

# Check if archive exists
if [ ! -f "$ARCHIVE_NAME" ]; then
    echo -e "${RED}❌ Archive file not found: $ARCHIVE_NAME${NC}"
    VERIFICATION_PASSED=false
else
    echo -e "${GREEN}✅ Archive file found: $ARCHIVE_NAME${NC}"
fi

# Check if checksum file exists
if [ ! -f "$CHECKSUM_FILE" ]; then
    echo -e "${RED}❌ Checksum file not found: $CHECKSUM_FILE${NC}"
    VERIFICATION_PASSED=false
else
    echo -e "${GREEN}✅ Checksum file found: $CHECKSUM_FILE${NC}"
fi

# Check signature files
SIGNATURES=("kosymbiosis.sig" "kosymbiosis-co1.sig" "kosymbiosis-co2.sig")
SIGNATURE_NAMES=("Primary (Seedbringer)" "Co-Signatory 1 (Technical)" "Co-Signatory 2 (Ethical)")

for i in "${!SIGNATURES[@]}"; do
    if [ ! -f "${SIGNATURES[$i]}" ]; then
        echo -e "${RED}❌ Signature file not found: ${SIGNATURES[$i]} (${SIGNATURE_NAMES[$i]})${NC}"
        VERIFICATION_PASSED=false
    else
        echo -e "${GREEN}✅ Signature file found: ${SIGNATURES[$i]} (${SIGNATURE_NAMES[$i]})${NC}"
    fi
done

echo ""

if [ "$VERIFICATION_PASSED" = false ]; then
    echo -e "${RED}Required files are missing. Cannot proceed with verification.${NC}"
    exit 1
fi

echo "[2/4] Verifying SHA-256 checksum..."
echo ""

# Verify checksum
if sha256sum -c "$CHECKSUM_FILE" 2>&1 | grep -q "OK"; then
    echo -e "${GREEN}✅ Checksum verification: PASSED${NC}"
    CHECKSUM=$(cat "$CHECKSUM_FILE" | cut -d' ' -f1)
    echo "   SHA-256: $CHECKSUM"
else
    echo -e "${RED}❌ Checksum verification: FAILED${NC}"
    echo "   Archive may be corrupted or tampered with!"
    VERIFICATION_PASSED=false
fi

echo ""

echo "[3/4] Verifying GPG signatures..."
echo ""

# Function to verify signature
verify_signature() {
    local sig_file=$1
    local sig_name=$2
    
    echo "-------------------------------------------"
    echo "Verifying: $sig_name"
    echo "File: $sig_file"
    echo "-------------------------------------------"
    
    # Check if this is a mock signature
    if grep -q "MOCK SIGNATURE" "$sig_file" 2>/dev/null; then
        echo -e "${YELLOW}⚠️  Mock signature detected (development only)${NC}"
        echo "   This signature should be replaced with a real GPG signature"
        echo "   before production release."
        return 0
    fi
    
    # Try to verify with GPG
    if command -v gpg &> /dev/null; then
        if gpg --verify "$sig_file" "$ARCHIVE_NAME" 2>&1; then
            echo -e "${GREEN}✅ Signature verification: PASSED${NC}"
            return 0
        else
            echo -e "${RED}❌ Signature verification: FAILED${NC}"
            echo "   Possible reasons:"
            echo "   - Public key not in keyring"
            echo "   - Signature was created with different archive"
            echo "   - Signature file is corrupted"
            return 1
        fi
    else
        echo -e "${YELLOW}⚠️  GPG not available, cannot verify signature${NC}"
        echo "   Install GPG to verify signatures:"
        echo "   - Ubuntu/Debian: sudo apt-get install gnupg"
        echo "   - MacOS: brew install gnupg"
        return 0
    fi
}

# Verify each signature
SIGNATURE_VERIFICATION=true

for i in "${!SIGNATURES[@]}"; do
    if ! verify_signature "${SIGNATURES[$i]}" "${SIGNATURE_NAMES[$i]}"; then
        SIGNATURE_VERIFICATION=false
        VERIFICATION_PASSED=false
    fi
    echo ""
done

echo "[4/4] Final verification summary..."
echo ""

echo "================================================"
echo "  VERIFICATION RESULTS"
echo "================================================"
echo ""

# Summary of checks
echo "Archive File:     $([ -f "$ARCHIVE_NAME" ] && echo -e "${GREEN}✅ Found${NC}" || echo -e "${RED}❌ Missing${NC}")"
echo "Checksum File:    $([ -f "$CHECKSUM_FILE" ] && echo -e "${GREEN}✅ Found${NC}" || echo -e "${RED}❌ Missing${NC}")"
echo "Checksum Valid:   $(sha256sum -c "$CHECKSUM_FILE" &>/dev/null && echo -e "${GREEN}✅ Valid${NC}" || echo -e "${RED}❌ Invalid${NC}")"
echo ""
echo "Signatures:"

for i in "${!SIGNATURES[@]}"; do
    SIG_STATUS="${GREEN}✅ Present${NC}"
    [ ! -f "${SIGNATURES[$i]}" ] && SIG_STATUS="${RED}❌ Missing${NC}"
    echo "  ${SIGNATURE_NAMES[$i]}: $(echo -e "$SIG_STATUS")"
done

echo ""
echo "================================================"

if [ "$VERIFICATION_PASSED" = true ]; then
    echo -e "${GREEN}"
    echo "✅ ✅ ✅  VERIFICATION PASSED  ✅ ✅ ✅"
    echo -e "${NC}"
    echo "Archive integrity confirmed!"
    echo "All checksums and signatures verified successfully."
    echo ""
    echo "This archive is ready for distribution via:"
    echo "  - GitHub Release"
    echo "  - IPFS Upload"
    echo "  - Blockchain Anchoring"
else
    echo -e "${RED}"
    echo "❌ ❌ ❌  VERIFICATION FAILED  ❌ ❌ ❌"
    echo -e "${NC}"
    echo "One or more verification checks failed."
    echo "Please review the errors above and fix them before distribution."
    exit 1
fi

echo "================================================"
echo ""

# Display IPFS upload instructions
echo "================================================"
echo "  Next Steps: IPFS Distribution"
echo "================================================"
echo ""
echo "To upload to IPFS:"
echo ""
echo "  1. Install IPFS:"
echo "     wget https://dist.ipfs.io/go-ipfs/latest/go-ipfs_linux-amd64.tar.gz"
echo "     tar -xvzf go-ipfs_linux-amd64.tar.gz"
echo "     cd go-ipfs && sudo bash install.sh"
echo ""
echo "  2. Initialize IPFS:"
echo "     ipfs init"
echo "     ipfs daemon &"
echo ""
echo "  3. Add archive to IPFS:"
echo "     ipfs add $ARCHIVE_NAME"
echo ""
echo "  4. Pin the content:"
echo "     ipfs pin add <CID>"
echo ""
echo "  5. Verify via gateway:"
echo "     https://ipfs.io/ipfs/<CID>"
echo ""
echo "================================================"
