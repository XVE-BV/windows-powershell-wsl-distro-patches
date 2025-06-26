#!/bin/bash

# WSL .zshrc Login Message Patch Remover
# This script removes the welcome message from the user's .zshrc file

ZSHRC_FILE="$HOME/.zshrc"
PATCH_MARKER="# XVE WSL Login Patch - DO NOT REMOVE THIS LINE"
TEMP_FILE="/tmp/.zshrc_temp"

# Function to check if patch is applied
is_patch_applied() {
    if [ -f "$ZSHRC_FILE" ] && grep -q "$PATCH_MARKER" "$ZSHRC_FILE"; then
        return 0  # Patch is applied
    else
        return 1  # Patch not applied
    fi
}

# Function to remove the patch
remove_patch() {
    echo "Removing .zshrc login message patch..."
    
    # Create a temporary file without the patch lines
    if [ -f "$ZSHRC_FILE" ]; then
        # Remove lines from the patch marker to the next empty line
        awk -v marker="$PATCH_MARKER" '
        BEGIN { skip = 0 }
        $0 == marker { skip = 1; next }
        skip && /^$/ { skip = 0; next }
        !skip { print }
        ' "$ZSHRC_FILE" > "$TEMP_FILE"
        
        # Replace the original file
        mv "$TEMP_FILE" "$ZSHRC_FILE"
        
        echo "✅ Patch removed successfully!"
        echo "The welcome message will no longer appear on WSL login."
    else
        echo "❌ .zshrc file not found"
        exit 1
    fi
}

# Main execution
echo "XVE WSL .zshrc Login Patch Remover"
echo "=================================="

if is_patch_applied; then
    echo "📝 Patch detected in $ZSHRC_FILE"
    remove_patch
else
    echo "⚠️  Patch is not applied to $ZSHRC_FILE"
    echo "No action needed."
    exit 0
fi