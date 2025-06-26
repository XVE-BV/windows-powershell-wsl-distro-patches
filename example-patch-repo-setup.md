# Example External Patch Repository Setup

This document shows how to set up an external GitHub repository for XVE WSL patches.

## Repository Structure

Create a GitHub repository with this structure:

```
xve-wsl-patches/
├── README.md
├── patches/
│   ├── 001_welcome_message.sh
│   ├── 002_install_tools.sh
│   └── 003_configure_aliases.sh
└── .github/
    └── workflows/
        └── release.yml (optional - for automated releases)
```

## Example Patch Files

### patches/001_welcome_message.sh
```bash
#!/bin/bash

PATCH_NAME="001_welcome_message"
PATCH_DESCRIPTION="Add welcome message to .zshrc"

patch_up() {
    local target_file="/home/xve/.zshrc"
    local backup_path
    backup_path=$(create_backup "$target_file" "$PATCH_NAME")

    if ! grep -q "# XVE Welcome Message" "$target_file"; then
        cat >> "$target_file" << 'EOF'

# XVE Welcome Message
echo "🚀 Welcome to XVE WSL Environment!"
echo "Type 'help' for available commands"
EOF
        echo "Added welcome message to $target_file"
    fi

    return 0
}

patch_down() {
    local target_file="/home/xve/.zshrc"
    sed -i '/# XVE Welcome Message/,+2d' "$target_file"
    return 0
}
```

### patches/002_install_tools.sh
```bash
#!/bin/bash

PATCH_NAME="002_install_tools"
PATCH_DESCRIPTION="Install essential development tools"

patch_up() {
    echo "Installing development tools..."

    local tools=("htop" "tree" "curl" "wget")
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" >/dev/null 2>&1; then
            sudo apk add --no-cache "$tool"
            echo "Installed: $tool"
        else
            echo "Already installed: $tool"
        fi
    done

    return 0
}

patch_down() {
    echo "Removing development tools..."
    sudo apk del htop tree curl wget
    return 0
}

patch_validate() {
    if ! command -v apk >/dev/null 2>&1; then
        echo "Error: apk package manager not found"
        return 1
    fi
    return 0
}
```

## Creating Releases

1. **Commit your patches**:
   ```bash
   git add patches/
   git commit -m "Add new patches v1.0.0"
   git push origin main
   ```

2. **Create a release tag**:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

3. **Create GitHub release**:
   - Go to your repository on GitHub
   - Click "Releases" → "Create a new release"
   - Select the tag you just created
   - Add release notes describing the patches
   - Publish the release

## Using the External Repository

Once your repository is set up with releases, users can configure their XVE WSL environment:

```bash
# Use your repository
export XVE_PATCH_REPO_OWNER="your-username"
export XVE_PATCH_REPO_NAME="xve-wsl-patches"

# Use latest release
selfupdate

# Or use specific release
XVE_PATCH_RELEASE_TAG="v1.0.0" selfupdate
```

## Automated Release Workflow (Optional)

Create `.github/workflows/release.yml` for automated releases:

```yaml
name: Create Release

on:
  push:
    tags:
      - 'v*'

permissions:
  contents: write

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3

    - name: Create Release
      uses: softprops/action-gh-release@v1
      with:
        tag_name: ${{ github.ref_name }}
        name: Release ${{ github.ref_name }}
        body: |
          Patches included in this release:
          - Check the patches/ directory for all available patches
        draft: false
        prerelease: false
```

## Testing Your Setup

1. Create a test repository with the structure above
2. Add some simple patches
3. Create a release
4. Test the download:
   ```bash
   XVE_PATCH_REPO_OWNER="your-username" XVE_PATCH_REPO_NAME="your-repo" selfupdate --help
   ```

This setup allows you to manage patches centrally and distribute them to multiple XVE WSL environments without rebuilding the distro.
