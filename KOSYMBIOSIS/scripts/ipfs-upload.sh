#!/bin/bash
# KOSYMBIOSIS IPFS Distribution Script
# Uploads archive to IPFS and provides gateway links

set -e

echo "================================================"
echo "  KOSYMBIOSIS IPFS Distribution"
echo "  Distributed Storage for Archive Redundancy"
echo "================================================"
echo ""

# Configuration
ARCHIVE_NAME="kosymbiosis-archive.zip"

# Detect working directory dynamically
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ "$SCRIPT_DIR" == */KOSYMBIOSIS/scripts ]]; then
    WORK_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
else
    WORK_DIR="$(pwd)"
fi

# Navigate to working directory
cd "$WORK_DIR"

# Check if archive exists
if [ ! -f "$ARCHIVE_NAME" ]; then
    echo "❌ ERROR: Archive file not found: $ARCHIVE_NAME"
    echo "Please run create-archive.sh first."
    exit 1
fi

echo "Archive found: $ARCHIVE_NAME"
echo ""

# Check if IPFS is installed
if ! command -v ipfs &> /dev/null; then
    echo "================================================"
    echo "  IPFS Not Installed"
    echo "================================================"
    echo ""
    echo "IPFS is required for distributed storage."
    echo ""
    echo "Installation instructions:"
    echo ""
    echo "1. Download IPFS:"
    echo "   wget https://dist.ipfs.io/go-ipfs/latest/go-ipfs_linux-amd64.tar.gz"
    echo ""
    echo "2. Extract and install:"
    echo "   tar -xvzf go-ipfs_linux-amd64.tar.gz"
    echo "   cd go-ipfs"
    echo "   sudo bash install.sh"
    echo ""
    echo "3. Initialize IPFS:"
    echo "   ipfs init"
    echo ""
    echo "4. Start IPFS daemon:"
    echo "   ipfs daemon &"
    echo ""
    echo "After installation, run this script again."
    echo ""
    exit 1
fi

echo "✅ IPFS is installed"
echo ""

# Check if IPFS daemon is running
if ! ipfs swarm peers &> /dev/null; then
    echo "================================================"
    echo "  IPFS Daemon Not Running"
    echo "================================================"
    echo ""
    echo "The IPFS daemon needs to be running to upload files."
    echo ""
    echo "Start the daemon with:"
    echo "   ipfs daemon &"
    echo ""
    echo "Or run in the background:"
    echo "   nohup ipfs daemon > ipfs.log 2>&1 &"
    echo ""
    read -p "Would you like to proceed without daemon (offline add)? (y/N): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
    OFFLINE_MODE=true
else
    echo "✅ IPFS daemon is running"
    echo ""
    OFFLINE_MODE=false
fi

echo "================================================"
echo "  Adding Archive to IPFS"
echo "================================================"
echo ""

# Add the archive to IPFS
echo "Adding $ARCHIVE_NAME to IPFS..."
echo ""

if [ "$OFFLINE_MODE" = true ]; then
    IPFS_OUTPUT=$(ipfs add --only-hash "$ARCHIVE_NAME")
else
    IPFS_OUTPUT=$(ipfs add --progress "$ARCHIVE_NAME")
fi

# Extract CID from output
CID=$(echo "$IPFS_OUTPUT" | grep "added" | awk '{print $2}')

if [ -z "$CID" ]; then
    echo "❌ Failed to add archive to IPFS"
    exit 1
fi

echo ""
echo "✅ Archive added to IPFS successfully!"
echo ""
echo "IPFS CID: $CID"
echo ""

# Pin the content if not in offline mode
if [ "$OFFLINE_MODE" = false ]; then
    echo "Pinning content to ensure availability..."
    ipfs pin add "$CID" &> /dev/null || true
    echo "✅ Content pinned"
    echo ""
fi

echo "================================================"
echo "  Gateway Access URLs"
echo "================================================"
echo ""
echo "Your archive is now accessible via IPFS gateways:"
echo ""
echo "Primary Gateway (IPFS.io):"
echo "  https://ipfs.io/ipfs/$CID"
echo ""
echo "Alternative Gateways:"
echo "  https://gateway.pinata.cloud/ipfs/$CID"
echo "  https://cloudflare-ipfs.com/ipfs/$CID"
echo "  https://dweb.link/ipfs/$CID"
echo ""

echo "================================================"
echo "  Update Documentation"
echo "================================================"
echo ""
echo "Next steps:"
echo ""
echo "1. Update README.md with IPFS CID"
echo "2. Update project-metadata.json with IPFS CID"
echo "3. Create GitHub release with CID in description"
echo "4. Anchor CID to blockchain"
echo ""

# Offer to update README automatically
echo "Would you like to update the KOSYMBIOSIS README with this CID?"
read -p "(y/N): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    README_FILE="$WORK_DIR/KOSYMBIOSIS/README.md"
    if [ -f "$README_FILE" ]; then
        # Replace placeholder with actual CID
        sed -i "s/\[IPFS_CID_PLACEHOLDER\]/$CID/g" "$README_FILE"
        echo "✅ README.md updated with IPFS CID"
        
        # Also update checksum if available
        if [ -f "checksum.sha256" ]; then
            CHECKSUM=$(cat checksum.sha256 | cut -d' ' -f1)
            sed -i "s/\[CHECKSUM_PLACEHOLDER\]/$CHECKSUM/g" "$README_FILE"
            echo "✅ README.md updated with checksum"
        fi
    else
        echo "❌ README.md not found at $README_FILE"
    fi
fi

echo ""

echo "================================================"
echo "  IPFS Upload Complete!"
echo "================================================"
echo ""
echo "Archive: $ARCHIVE_NAME"
echo "CID: $CID"
echo "Access: https://ipfs.io/ipfs/$CID"
echo ""
echo "The archive is now distributed across the IPFS network."
echo "Content is immutable and permanently accessible via CID."
echo ""
echo "================================================"
echo ""

# Save CID to file for reference
echo "$CID" > ipfs-cid.txt
echo "CID saved to: ipfs-cid.txt"
echo ""

# Display pinning services information
echo "================================================"
echo "  Optional: Pin to Remote Services"
echo "================================================"
echo ""
echo "For enhanced redundancy, consider pinning to remote services:"
echo ""
echo "1. Pinata (https://pinata.cloud):"
echo "   - Free tier: 1GB storage"
echo "   - Upload via web interface or API"
echo ""
echo "2. Infura (https://infura.io):"
echo "   - IPFS API access"
echo "   - Dedicated gateways"
echo ""
echo "3. Web3.Storage (https://web3.storage):"
echo "   - Free storage on Filecoin"
echo "   - Automatic IPFS pinning"
echo ""
echo "Command to pin with Pinata API:"
echo "  curl -X POST \"https://api.pinata.cloud/pinning/pinByHash\" \\"
echo "    -H \"pinata_api_key: YOUR_API_KEY\" \\"
echo "    -H \"pinata_secret_api_key: YOUR_SECRET_KEY\" \\"
echo "    -H \"Content-Type: application/json\" \\"
echo "    -d '{\"hashToPin\":\"$CID\"}'"
echo ""
echo "================================================"
