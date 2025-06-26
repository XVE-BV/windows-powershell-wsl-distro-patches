#!/bin/bash

# Test script for .zshrc login patch
# This script tests both application and removal of the patch

TEST_ZSHRC="/tmp/test_zshrc"
PATCH_MARKER="# XVE WSL Login Patch - DO NOT REMOVE THIS LINE"
LOGIN_MESSAGE='echo "Welcome to XVE WSL Environment! 🚀"
echo "Run '\''als'\'' or '\''aliases'\'' to view available aliases"
echo "Detailed Breakdown: https://github.com/jonasvanderhaegen-xve/developer-kit/blob/main/ALIASES.md"'

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

# Function to print test results
print_result() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✅ PASS${NC}: $2"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}❌ FAIL${NC}: $2"
        ((TESTS_FAILED++))
    fi
}

# Function to simulate patch application
simulate_apply_patch() {
    local zshrc_file="$1"

    # Create .zshrc if it doesn't exist
    if [ ! -f "$zshrc_file" ]; then
        touch "$zshrc_file"
    fi

    # Check if patch is already applied
    if grep -q "$PATCH_MARKER" "$zshrc_file"; then
        return 1  # Already applied
    fi

    # Add the patch
    echo "" >> "$zshrc_file"
    echo "$PATCH_MARKER" >> "$zshrc_file"
    echo "$LOGIN_MESSAGE" >> "$zshrc_file"
    echo "" >> "$zshrc_file"

    return 0  # Successfully applied
}

# Function to simulate patch removal
simulate_remove_patch() {
    local zshrc_file="$1"
    local temp_file="/tmp/zshrc_temp_test"

    if [ ! -f "$zshrc_file" ]; then
        return 1  # File doesn't exist
    fi

    # Check if patch is applied
    if ! grep -q "$PATCH_MARKER" "$zshrc_file"; then
        return 1  # Patch not applied
    fi

    # Remove the patch
    awk -v marker="$PATCH_MARKER" '
    BEGIN { skip = 0 }
    $0 == marker { skip = 1; next }
    skip && /^$/ { skip = 0; next }
    !skip { print }
    ' "$zshrc_file" > "$temp_file"

    mv "$temp_file" "$zshrc_file"
    return 0  # Successfully removed
}

# Function to check if patch is applied
is_patch_applied() {
    local zshrc_file="$1"
    if [ -f "$zshrc_file" ] && grep -q "$PATCH_MARKER" "$zshrc_file"; then
        return 0  # Applied
    else
        return 1  # Not applied
    fi
}

echo "XVE WSL .zshrc Patch Test Suite"
echo "==============================="
echo

# Test 1: Apply patch to non-existent file
echo "Test 1: Apply patch to non-existent file"
rm -f "$TEST_ZSHRC"
simulate_apply_patch "$TEST_ZSHRC"
result=$?
print_result $result "Patch application to new file"

# Test 2: Verify patch was applied
echo "Test 2: Verify patch was applied"
is_patch_applied "$TEST_ZSHRC"
result=$?
print_result $result "Patch detection after application"

# Test 3: Try to apply patch again (should fail/detect existing)
echo "Test 3: Try to apply patch again"
simulate_apply_patch "$TEST_ZSHRC"
result=$?
if [ $result -eq 1 ]; then
    result=0  # Expected to fail (already applied)
else
    result=1  # Unexpected success
fi
print_result $result "Duplicate patch prevention"

# Test 4: Remove patch
echo "Test 4: Remove patch"
simulate_remove_patch "$TEST_ZSHRC"
result=$?
print_result $result "Patch removal"

# Test 5: Verify patch was removed
echo "Test 5: Verify patch was removed"
is_patch_applied "$TEST_ZSHRC"
result=$?
if [ $result -eq 1 ]; then
    result=0  # Expected to not be applied
else
    result=1  # Unexpected detection
fi
print_result $result "Patch detection after removal"

# Test 6: Try to remove patch again (should fail/detect not applied)
echo "Test 6: Try to remove patch again"
simulate_remove_patch "$TEST_ZSHRC"
result=$?
if [ $result -eq 1 ]; then
    result=0  # Expected to fail (not applied)
else
    result=1  # Unexpected success
fi
print_result $result "Remove non-existent patch handling"

# Cleanup
rm -f "$TEST_ZSHRC"

echo
echo "Test Results:"
echo "============="
echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
echo -e "${RED}Failed: $TESTS_FAILED${NC}"

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}All tests passed! 🎉${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed! 😞${NC}"
    exit 1
fi
