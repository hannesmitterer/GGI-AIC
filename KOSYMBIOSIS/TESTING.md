# KOSYMBIOSIS Archive - Testing Guide

## Overview
This guide provides comprehensive testing procedures for the KOSYMBIOSIS archive creation and verification process.

## Test Scenarios

### 1. Archive Creation Test

**Objective**: Verify that the archive is created successfully with all required files.

**Steps**:
```bash
cd /home/runner/work/GGI-AIC/GGI-AIC
./KOSYMBIOSIS/scripts/create-archive.sh
```

**Expected Results**:
- ✅ Archive file created: `kosymbiosis-archive.zip`
- ✅ Checksum file created: `checksum.sha256`
- ✅ All project artifacts included in archive
- ✅ Checksum verification passes

**Validation**:
```bash
# Check files exist
ls -lh kosymbiosis-archive.zip checksum.sha256

# Verify checksum
sha256sum -c checksum.sha256

# Inspect archive contents
unzip -l kosymbiosis-archive.zip | head -30
```

---

### 2. Signature Creation Test

**Objective**: Verify that mock signatures can be created for development testing.

**Steps**:
```bash
cd /home/runner/work/GGI-AIC/GGI-AIC
echo "y" | ./KOSYMBIOSIS/scripts/sign-archive.sh
```

**Expected Results**:
- ✅ Primary signature created: `kosymbiosis.sig`
- ✅ Co-signatory 1 signature: `kosymbiosis-co1.sig`
- ✅ Co-signatory 2 signature: `kosymbiosis-co2.sig`
- ✅ All signatures contain mock signature markers

**Validation**:
```bash
# Check files exist
ls -lh kosymbiosis*.sig

# Verify they contain mock markers
grep "MOCK SIGNATURE" kosymbiosis.sig
grep "MOCK SIGNATURE" kosymbiosis-co1.sig
grep "MOCK SIGNATURE" kosymbiosis-co2.sig
```

---

### 3. Verification Test

**Objective**: Verify that all integrity checks pass.

**Steps**:
```bash
cd /home/runner/work/GGI-AIC/GGI-AIC
./KOSYMBIOSIS/scripts/verify-archive.sh
```

**Expected Results**:
- ✅ Archive file found
- ✅ Checksum file found
- ✅ All three signature files found
- ✅ Checksum validation passes
- ✅ Mock signatures detected and noted
- ✅ Overall verification passes

**Validation**:
```bash
# Run verification and check exit code
./KOSYMBIOSIS/scripts/verify-archive.sh
echo "Exit code: $?"  # Should be 0
```

---

### 4. Archive Extraction Test

**Objective**: Verify that archive can be extracted and contains expected files.

**Steps**:
```bash
cd /tmp
mkdir kosymbiosis-test
cd kosymbiosis-test
unzip /home/runner/work/GGI-AIC/GGI-AIC/kosymbiosis-archive.zip
```

**Expected Results**:
- ✅ Archive extracts without errors
- ✅ All expected directories present
- ✅ All files readable and intact
- ✅ MANIFEST.txt lists all contents

**Validation**:
```bash
# Check directory structure
ls -la

# Read manifest
cat MANIFEST.txt

# Verify key files exist
test -f KOSYMBIOSIS/README.md && echo "README found"
test -f KOSYMBIOSIS/metadata/project-metadata.json && echo "Metadata found"
test -f KOSYMBIOSIS/declarations/ethical-declarations.md && echo "Declarations found"
```

---

### 5. Script Permissions Test

**Objective**: Verify all scripts are executable.

**Steps**:
```bash
cd /home/runner/work/GGI-AIC/GGI-AIC/KOSYMBIOSIS/scripts
ls -la *.sh
```

**Expected Results**:
- ✅ All `.sh` files have execute permission
- ✅ Scripts can be run directly without `bash` prefix

**Validation**:
```bash
for script in *.sh; do
    if [ -x "$script" ]; then
        echo "✅ $script is executable"
    else
        echo "❌ $script is NOT executable"
    fi
done
```

---

### 6. Documentation Completeness Test

**Objective**: Verify all documentation files exist and are complete.

**Steps**:
```bash
cd /home/runner/work/GGI-AIC/GGI-AIC/KOSYMBIOSIS
```

**Expected Files**:
- ✅ `README.md` - Main project documentation
- ✅ `QUICKSTART.md` - Quick start guide
- ✅ `metadata/project-metadata.json` - Structured metadata
- ✅ `declarations/ethical-declarations.md` - Ethical principles
- ✅ `logs/implementation-log.md` - Implementation audit trail

**Validation**:
```bash
DOCS=(
    "README.md"
    "QUICKSTART.md"
    "metadata/project-metadata.json"
    "declarations/ethical-declarations.md"
    "logs/implementation-log.md"
)

for doc in "${DOCS[@]}"; do
    if [ -f "$doc" ]; then
        echo "✅ Found: $doc ($(wc -l < "$doc") lines)"
    else
        echo "❌ Missing: $doc"
    fi
done
```

---

### 7. Checksum Consistency Test

**Objective**: Verify checksum is consistent across multiple runs.

**Steps**:
```bash
cd /home/runner/work/GGI-AIC/GGI-AIC

# Get current checksum
CHECKSUM1=$(cat checksum.sha256 | cut -d' ' -f1)

# Recalculate checksum
CHECKSUM2=$(sha256sum kosymbiosis-archive.zip | cut -d' ' -f1)

# Compare
if [ "$CHECKSUM1" = "$CHECKSUM2" ]; then
    echo "✅ Checksums match"
else
    echo "❌ Checksums don't match"
fi
```

**Expected Results**:
- ✅ Checksums match exactly
- ✅ No variation between runs

---

### 8. Master Script Test

**Objective**: Verify the master orchestration script works correctly.

**Steps**:
```bash
cd /home/runner/work/GGI-AIC/GGI-AIC/KOSYMBIOSIS/scripts

# Test status check
echo "s" | ./kosymbiosis.sh | head -20

# The script should show current status
```

**Expected Results**:
- ✅ Menu displays correctly
- ✅ Status check works
- ✅ Script can be exited cleanly

---

## Integration Testing

### Full Workflow Test

**Objective**: Run the complete archival process from start to finish.

**Steps**:
```bash
#!/bin/bash
cd /home/runner/work/GGI-AIC/GGI-AIC

# Clean previous artifacts
rm -f kosymbiosis-archive.zip checksum.sha256 kosymbiosis*.sig ipfs-cid.txt

# Run complete workflow
./KOSYMBIOSIS/scripts/create-archive.sh
echo "y" | ./KOSYMBIOSIS/scripts/sign-archive.sh
./KOSYMBIOSIS/scripts/verify-archive.sh

# Verify results
if [ -f "kosymbiosis-archive.zip" ] && \
   [ -f "checksum.sha256" ] && \
   [ -f "kosymbiosis.sig" ] && \
   [ -f "kosymbiosis-co1.sig" ] && \
   [ -f "kosymbiosis-co2.sig" ]; then
    echo "✅ Complete workflow successful!"
else
    echo "❌ Workflow incomplete"
    exit 1
fi
```

---

## Performance Testing

### Archive Size Test

**Objective**: Verify archive size is reasonable.

```bash
cd /home/runner/work/GGI-AIC/GGI-AIC

SIZE=$(du -h kosymbiosis-archive.zip | cut -f1)
SIZE_BYTES=$(stat -f%z kosymbiosis-archive.zip 2>/dev/null || stat -c%s kosymbiosis-archive.zip)

echo "Archive size: $SIZE ($SIZE_BYTES bytes)"

# Verify size is reasonable (should be < 100MB for documentation)
if [ $SIZE_BYTES -lt 104857600 ]; then
    echo "✅ Archive size is reasonable"
else
    echo "⚠️  Archive is larger than expected"
fi
```

---

## Regression Testing

### Archive Content Stability Test

**Objective**: Verify archive contains expected files across multiple runs.

```bash
cd /home/runner/work/GGI-AIC/GGI-AIC

# Create two archives
./KOSYMBIOSIS/scripts/create-archive.sh
mv kosymbiosis-archive.zip archive1.zip

./KOSYMBIOSIS/scripts/create-archive.sh
mv kosymbiosis-archive.zip archive2.zip

# Compare file listings
unzip -l archive1.zip | sort > /tmp/files1.txt
unzip -l archive2.zip | sort > /tmp/files2.txt

if diff /tmp/files1.txt /tmp/files2.txt; then
    echo "✅ Archive content is stable"
else
    echo "⚠️  Archive content varies between runs"
fi

# Restore original
mv archive2.zip kosymbiosis-archive.zip
rm archive1.zip
```

---

## Error Handling Tests

### Missing Archive Test

**Objective**: Verify scripts handle missing files gracefully.

```bash
cd /home/runner/work/GGI-AIC/GGI-AIC

# Remove archive temporarily
mv kosymbiosis-archive.zip kosymbiosis-archive.zip.bak

# Try to verify (should fail gracefully)
./KOSYMBIOSIS/scripts/verify-archive.sh
EXIT_CODE=$?

# Restore archive
mv kosymbiosis-archive.zip.bak kosymbiosis-archive.zip

if [ $EXIT_CODE -ne 0 ]; then
    echo "✅ Script correctly handles missing archive"
else
    echo "❌ Script should fail when archive is missing"
fi
```

---

## Security Testing

### Checksum Tampering Test

**Objective**: Verify that checksum validation detects tampering.

```bash
cd /home/runner/work/GGI-AIC/GGI-AIC

# Backup original checksum
cp checksum.sha256 checksum.sha256.bak

# Tamper with checksum file
echo "0000000000000000000000000000000000000000000000000000000000000000  kosymbiosis-archive.zip" > checksum.sha256

# Try to verify (should fail)
if sha256sum -c checksum.sha256 2>&1 | grep -q "FAILED"; then
    echo "✅ Tampering detected correctly"
else
    echo "❌ Tampering not detected"
fi

# Restore original
mv checksum.sha256.bak checksum.sha256
```

---

## Cleanup

After all tests, clean up temporary files:

```bash
cd /home/runner/work/GGI-AIC/GGI-AIC
rm -rf /tmp/kosymbiosis-test
rm -f /tmp/files1.txt /tmp/files2.txt
```

---

## Test Summary

Create a test report:

```bash
#!/bin/bash
echo "KOSYMBIOSIS Archive Test Report"
echo "================================"
echo "Date: $(date)"
echo ""
echo "Files:"
echo "  Archive: $(ls -lh kosymbiosis-archive.zip 2>/dev/null || echo 'NOT FOUND')"
echo "  Checksum: $(ls -lh checksum.sha256 2>/dev/null || echo 'NOT FOUND')"
echo "  Signatures: $(ls kosymbiosis*.sig 2>/dev/null | wc -l) of 3"
echo ""
echo "Integrity:"
echo -n "  Checksum valid: "
sha256sum -c checksum.sha256 &>/dev/null && echo "YES" || echo "NO"
echo ""
echo "Status: All tests complete"
```

---

## Continuous Testing

For CI/CD integration, create a test script:

```bash
#!/bin/bash
# tests/test-kosymbiosis.sh

set -e

cd /home/runner/work/GGI-AIC/GGI-AIC

echo "Running KOSYMBIOSIS archive tests..."

# Test 1: Archive creation
echo "Test 1: Archive creation"
./KOSYMBIOSIS/scripts/create-archive.sh > /dev/null
test -f kosymbiosis-archive.zip
echo "✅ Passed"

# Test 2: Signature creation
echo "Test 2: Signature creation"
echo "y" | ./KOSYMBIOSIS/scripts/sign-archive.sh > /dev/null
test -f kosymbiosis.sig
echo "✅ Passed"

# Test 3: Verification
echo "Test 3: Verification"
./KOSYMBIOSIS/scripts/verify-archive.sh > /dev/null
echo "✅ Passed"

echo ""
echo "All tests passed!"
```

---

**Note**: These tests are designed for development and validation. For production releases, replace mock signatures with real GPG signatures from all three signatories.
