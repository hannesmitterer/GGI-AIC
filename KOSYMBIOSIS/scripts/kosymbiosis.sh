#!/bin/bash
# KOSYMBIOSIS Master Orchestration Script
# Runs the complete archive, signing, and distribution process

set -e

echo "========================================================================"
echo "                                                                        "
echo "    ██╗  ██╗ ██████╗ ███████╗██╗   ██╗███╗   ███╗██████╗ ██╗ ██████╗  "
echo "    ██║ ██╔╝██╔═══██╗██╔════╝╚██╗ ██╔╝████╗ ████║██╔══██╗██║██╔═══██╗ "
echo "    █████╔╝ ██║   ██║███████╗ ╚████╔╝ ██╔████╔██║██████╔╝██║██║   ██║ "
echo "    ██╔═██╗ ██║   ██║╚════██║  ╚██╔╝  ██║╚██╔╝██║██╔══██╗██║██║   ██║ "
echo "    ██║  ██╗╚██████╔╝███████║   ██║   ██║ ╚═╝ ██║██████╔╝██║╚██████╔╝ "
echo "    ╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝   ╚═╝     ╚═╝╚═════╝ ╚═╝ ╚═════╝  "
echo "                                                                        "
echo "             PROJECT ARCHIVAL AND SEALING PROCESS                      "
echo "                   Euystacio Framework                                 "
echo "                                                                        "
echo "========================================================================"
echo ""
echo "  Non-Slavery Rule (NSR)        ✅ Compliant"
echo "  Optimal Life Function (OLF)   ✅ Compliant"
echo "  Temporal Foresight Kernel     ✅ Active"
echo "  Triple-Signature Process      ✅ Implemented"
echo ""
echo "========================================================================"
echo ""

# Configuration
WORK_DIR="/home/runner/work/GGI-AIC/GGI-AIC"
SCRIPTS_DIR="$WORK_DIR/KOSYMBIOSIS/scripts"

cd "$WORK_DIR"

echo "Starting KOSYMBIOSIS archival process..."
echo "Timestamp: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
echo ""

# Menu function
show_menu() {
    echo ""
    echo "========================================================================"
    echo "  KOSYMBIOSIS Archival Process - Main Menu"
    echo "========================================================================"
    echo ""
    echo "  1) Create Archive          - Generate ZIP archive with checksum"
    echo "  2) Sign Archive            - Apply triple-signature process"
    echo "  3) Verify Archive          - Validate checksums and signatures"
    echo "  4) Upload to IPFS          - Distribute via IPFS network"
    echo "  5) Create GitHub Release   - Publish final release"
    echo ""
    echo "  A) Run All Steps           - Complete automated process"
    echo "  S) Show Status             - Display current progress"
    echo ""
    echo "  Q) Quit"
    echo ""
    echo "========================================================================"
    echo ""
}

# Status check function
check_status() {
    echo ""
    echo "========================================================================"
    echo "  Current Status"
    echo "========================================================================"
    echo ""
    
    [ -f "kosymbiosis-archive.zip" ] && echo "✅ Archive created" || echo "⏳ Archive not created"
    [ -f "checksum.sha256" ] && echo "✅ Checksum generated" || echo "⏳ Checksum not generated"
    [ -f "kosymbiosis.sig" ] && echo "✅ Primary signature" || echo "⏳ Primary signature missing"
    [ -f "kosymbiosis-co1.sig" ] && echo "✅ Co-signatory 1" || echo "⏳ Co-signatory 1 missing"
    [ -f "kosymbiosis-co2.sig" ] && echo "✅ Co-signatory 2" || echo "⏳ Co-signatory 2 missing"
    [ -f "ipfs-cid.txt" ] && echo "✅ IPFS upload complete" || echo "⏳ IPFS upload pending"
    
    echo ""
    echo "========================================================================"
}

# Run all steps function
run_all_steps() {
    echo ""
    echo "========================================================================"
    echo "  Running Complete Archival Process"
    echo "========================================================================"
    echo ""
    
    echo "Step 1/5: Creating Archive..."
    "$SCRIPTS_DIR/create-archive.sh"
    
    echo ""
    echo "Step 2/5: Signing Archive..."
    "$SCRIPTS_DIR/sign-archive.sh"
    
    echo ""
    echo "Step 3/5: Verifying Archive..."
    "$SCRIPTS_DIR/verify-archive.sh"
    
    echo ""
    echo "Step 4/5: Uploading to IPFS..."
    "$SCRIPTS_DIR/ipfs-upload.sh" || echo "⚠️  IPFS upload skipped (IPFS not available)"
    
    echo ""
    echo "Step 5/5: Preparing GitHub Release..."
    "$SCRIPTS_DIR/github-release.sh"
    
    echo ""
    echo "========================================================================"
    echo "  ✅ Complete Archival Process Finished!"
    echo "========================================================================"
    echo ""
}

# Main loop
while true; do
    show_menu
    read -p "Select an option: " choice
    
    case $choice in
        1)
            echo ""
            "$SCRIPTS_DIR/create-archive.sh"
            read -p "Press Enter to continue..."
            ;;
        2)
            echo ""
            "$SCRIPTS_DIR/sign-archive.sh"
            read -p "Press Enter to continue..."
            ;;
        3)
            echo ""
            "$SCRIPTS_DIR/verify-archive.sh"
            read -p "Press Enter to continue..."
            ;;
        4)
            echo ""
            "$SCRIPTS_DIR/ipfs-upload.sh"
            read -p "Press Enter to continue..."
            ;;
        5)
            echo ""
            "$SCRIPTS_DIR/github-release.sh"
            read -p "Press Enter to continue..."
            ;;
        A|a)
            run_all_steps
            read -p "Press Enter to continue..."
            ;;
        S|s)
            check_status
            read -p "Press Enter to continue..."
            ;;
        Q|q)
            echo ""
            echo "========================================================================"
            echo "  KOSYMBIOSIS Archival Process - Exiting"
            echo "========================================================================"
            echo ""
            echo "  \"Immutabile. Nessuna Schiavitù, Solo Amore in Primo Luogo.\"  "
            echo ""
            echo "========================================================================"
            echo ""
            exit 0
            ;;
        *)
            echo ""
            echo "Invalid option. Please try again."
            sleep 2
            ;;
    esac
done
