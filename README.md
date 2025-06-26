# XVE WSL Patches

This repository contains patches for the XVE WSL environment. These patches are designed to be used with the XVE Patch Management System.

## Repository Structure

```
xve-wsl-patches/
├── README.md                           # This file
├── PATCH_SYSTEM.md                     # Complete documentation of the patch system
├── example-patch-repo-setup.md         # Guide for setting up external patch repositories
└── patches/                            # Patch files directory
    └── 001_zshrc_login_message.sh      # Welcome message patch for .zshrc
```

## Available Patches

### 001_zshrc_login_message.sh
Adds a welcome message to the user's .zshrc file that displays:
- Welcome message for XVE WSL Environment
- Information about available aliases
- Link to detailed documentation

## Usage

This repository is designed to work with the XVE Patch Management System. To use these patches:

1. **Configure your environment** to use this repository:
   ```bash
   export XVE_PATCH_REPO_OWNER="your-username"
   export XVE_PATCH_REPO_NAME="windows-powershell-wsl-distro-patches"
   ```

2. **Apply patches** using the selfupdate command:
   ```bash
   selfupdate
   ```

3. **Use specific release** (optional):
   ```bash
   XVE_PATCH_RELEASE_TAG="v1.0.0" selfupdate
   ```

## Creating Releases

To make patches available for download:

1. **Commit your changes**:
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
   - Go to the repository on GitHub
   - Click "Releases" → "Create a new release"
   - Select the tag you just created
   - Add release notes describing the patches
   - Publish the release

## Documentation

- **[PATCH_SYSTEM.md](PATCH_SYSTEM.md)** - Complete documentation of the XVE Patch Management System
- **[example-patch-repo-setup.md](example-patch-repo-setup.md)** - Guide for setting up external patch repositories

## Patch Development

For information on creating new patches, see the [PATCH_SYSTEM.md](PATCH_SYSTEM.md) documentation, specifically the "Creating Patches" section.

Each patch should:
- Follow the naming convention: `NNN_descriptive_name.sh`
- Include proper metadata (`PATCH_NAME`, `PATCH_DESCRIPTION`)
- Implement `patch_up()` function for applying changes
- Implement `patch_down()` function for rollback (recommended)
- Include `patch_validate()` function for pre-flight checks (optional)