#!/bin/bash

# WSL .zshrc Login Message Patch
# This script adds a welcome message to the user's .zshrc file
# It includes detection to prevent duplicate applications

ZSHRC_FILE="$HOME/.zshrc"
PATCH_MARKER="# XVE WSL Login Patch - DO NOT REMOVE THIS LINE"
LOGIN_MESSAGE='echo "Welcome to XVE WSL Environment! 🚀"
echo "Run '\''als'\'' or '\''aliases'\'' to view available aliases"
echo "Detailed Breakdown: https://github.com/jonasvanderhaegen-xve/developer-kit/blob/main/ALIASES.md"'

# Function to check if patch is already applied
is_patch_applied() {
    if [ -f "$ZSHRC_FILE" ] && grep -q "$PATCH_MARKER" "$ZSHRC_FILE"; then
        return 0  # Patch already applied
    else
        return 1  # Patch not applied
    fi
}

# Function to apply the patch
apply_patch() {
    echo "Applying .zshrc login message patch..."

    # Create .zshrc if it doesn't exist
    if [ ! -f "$ZSHRC_FILE" ]; then
        touch "$ZSHRC_FILE"
        echo "Created new .zshrc file"
    fi

    # Add the patch with marker
    echo "" >> "$ZSHRC_FILE"
    echo "$PATCH_MARKER" >> "$ZSHRC_FILE"
    echo "$LOGIN_MESSAGE" >> "$ZSHRC_FILE"
    echo "" >> "$ZSHRC_FILE"

    echo "✅ Patch applied successfully!"
    echo "The welcome message will appear on your next WSL login."
}

# Main execution
echo "XVE WSL .zshrc Login Patch Installer"
echo "===================================="

if is_patch_applied; then
    echo "⚠️  Patch is already applied to $ZSHRC_FILE"
    echo "No action needed."
    exit 0
else
    echo "📝 Patch not detected in $ZSHRC_FILE"
    apply_patch
fi
