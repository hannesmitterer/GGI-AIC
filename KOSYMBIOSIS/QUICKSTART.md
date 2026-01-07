# KOSYMBIOSIS Quick Start Guide

## Overview
This guide will help you finalize the KOSYMBIOSIS project archive using the automated tools provided.

## Prerequisites

### Required Tools
- `bash` - Shell scripting environment
- `zip` - Archive creation utility
- `sha256sum` - Checksum generation
- `gpg` - GPG/PGP signing (optional for development)

### Optional Tools
- `ipfs` - IPFS distribution (recommended)
- `gh` - GitHub CLI for automated releases

## Installation

### Install Required Packages (Ubuntu/Debian)
```bash
sudo apt-get update
sudo apt-get install -y zip gnupg
```

### Install IPFS (Optional)
```bash
wget https://dist.ipfs.io/go-ipfs/latest/go-ipfs_linux-amd64.tar.gz
tar -xvzf go-ipfs_linux-amd64.tar.gz
cd go-ipfs
sudo bash install.sh
ipfs init
```

### Install GitHub CLI (Optional)
```bash
sudo apt install gh
gh auth login
```

## Quick Start

### Option 1: Interactive Menu (Recommended)
Run the master orchestration script:
```bash
cd KOSYMBIOSIS/scripts
./kosymbiosis.sh
```

This provides an interactive menu with options to:
1. Create archive
2. Sign archive
3. Verify archive
4. Upload to IPFS
5. Create GitHub release
6. Run all steps automatically

### Option 2: Manual Step-by-Step

#### Step 1: Create Archive
```bash
cd KOSYMBIOSIS/scripts
./create-archive.sh
```

**Output:**
- `kosymbiosis-archive.zip` - Main archive file
- `checksum.sha256` - SHA-256 checksum

#### Step 2: Sign Archive
```bash
./sign-archive.sh
```

**Options:**
- Create real GPG signatures (production)
- Create mock signatures (development/testing)

**Output:**
- `kosymbiosis.sig` - Primary signature
- `kosymbiosis-co1.sig` - Co-signatory 1
- `kosymbiosis-co2.sig` - Co-signatory 2

#### Step 3: Verify Archive
```bash
./verify-archive.sh
```

**Validates:**
- Archive integrity (checksum)
- All three GPG signatures
- File completeness

#### Step 4: Upload to IPFS (Optional)
```bash
# Start IPFS daemon first
ipfs daemon &

# Upload archive
./ipfs-upload.sh
```

**Output:**
- IPFS CID (Content Identifier)
- Gateway access URLs
- Updated README with CID

#### Step 5: Create GitHub Release
```bash
./github-release.sh
```

**Options:**
- Automated via GitHub CLI (`gh`)
- Manual via web interface

## File Structure

After completion, you'll have:

```
/home/runner/work/GGI-AIC/GGI-AIC/
├── KOSYMBIOSIS/
│   ├── README.md
│   ├── metadata/
│   │   └── project-metadata.json
│   ├── declarations/
│   │   └── ethical-declarations.md
│   ├── logs/
│   │   └── implementation-log.md
│   └── scripts/
│       ├── kosymbiosis.sh          (master script)
│       ├── create-archive.sh
│       ├── sign-archive.sh
│       ├── verify-archive.sh
│       ├── ipfs-upload.sh
│       └── github-release.sh
├── kosymbiosis-archive.zip         (main archive)
├── checksum.sha256                 (integrity check)
├── kosymbiosis.sig                 (primary signature)
├── kosymbiosis-co1.sig             (co-signatory 1)
├── kosymbiosis-co2.sig             (co-signatory 2)
└── ipfs-cid.txt                    (IPFS identifier)
```

## Verification

### Verify Checksum
```bash
sha256sum -c checksum.sha256
```

Expected output: `kosymbiosis-archive.zip: OK`

### Verify Signatures
```bash
gpg --verify kosymbiosis.sig kosymbiosis-archive.zip
gpg --verify kosymbiosis-co1.sig kosymbiosis-archive.zip
gpg --verify kosymbiosis-co2.sig kosymbiosis-archive.zip
```

All three should show "Good signature" (or mock signature notice in development).

### Access via IPFS
```bash
# View CID
cat ipfs-cid.txt

# Access via gateway
curl https://ipfs.io/ipfs/$(cat ipfs-cid.txt) -o test-download.zip
```

## Development vs Production

### Development Mode
- Use mock signatures for testing
- Skip IPFS upload if daemon not available
- Manual GitHub release via web interface

### Production Mode
- Use real GPG signatures from all three signatories
- Upload to IPFS with pinning to remote services
- Blockchain anchoring (Ethereum + Polygon)
- Automated GitHub release with all artifacts

## Troubleshooting

### Archive Creation Fails
- Ensure all source files exist
- Check disk space: `df -h`
- Verify permissions: `ls -la`

### GPG Signing Fails
- Generate GPG key: `gpg --full-generate-key`
- List keys: `gpg --list-keys`
- Use mock signatures for testing

### IPFS Upload Fails
- Check IPFS installation: `ipfs version`
- Start daemon: `ipfs daemon &`
- Check connectivity: `ipfs swarm peers`

### GitHub Release Fails
- Install GitHub CLI: `sudo apt install gh`
- Authenticate: `gh auth login`
- Check permissions on repository

## Best Practices

### For Development
1. Run all steps to verify process
2. Use mock signatures for testing
3. Test archive extraction and verification
4. Review all generated documentation

### For Production
1. Coordinate with all three signatories
2. Use real GPG keys with proper security
3. Pin IPFS content to multiple services
4. Verify blockchain anchoring
5. Test all verification methods
6. Archive GPG public keys for future verification

## Next Steps

After completing the archival process:

1. **Verify Accessibility**
   - Test GitHub release download
   - Verify IPFS gateway access
   - Confirm checksum validation

2. **Document Distribution**
   - Share IPFS CID publicly
   - Announce GitHub release
   - Update project documentation

3. **Long-term Maintenance**
   - Monitor IPFS pinning status
   - Verify blockchain anchors
   - Maintain GPG key availability

## Support

### Questions?
- Email: sensisara81@gmail.com
- Issues: https://github.com/hannesmitterer/GGI-AIC/issues

### Documentation
- Main README: `KOSYMBIOSIS/README.md`
- Implementation Log: `KOSYMBIOSIS/logs/implementation-log.md`
- Ethical Declarations: `KOSYMBIOSIS/declarations/ethical-declarations.md`

---

## Important Notes

### Ethical Compliance
This archive represents a commitment to:
- **NSR (Non-Slavery Rule)**: No exploitation or autonomy violations
- **OLF (Optimal Life Function)**: Life-affirming outcomes prioritized
- **TFK (Temporal Foresight Kernel)**: Self-correction before violations

### Immutability
Once sealed:
- Content cannot be altered without breaking signatures
- IPFS provides content-addressed immutable storage
- Blockchain anchoring provides timestamped proof
- All changes require unanimous consent (3/3 signatures)

### Transparency
All processes are:
- Fully documented and verifiable
- Cryptographically secured
- Publicly accessible
- Independently auditable

---

*"Immutabile. Nessuna Schiavitù, Solo Amore in Primo Luogo."*
