# SKILLS.md - Agent Skills Reference

This document lists skills and capabilities that AI agents should have to effectively help with this NixOS/Home Manager configuration project.

## Core Skills Required

### 1. Nix/NixOS Knowledge

**Required:**
- Understanding of Nix expression language
- Knowledge of NixOS configuration options
- Familiarity with Home Manager configuration
- Experience with flakes and flake.nix
- Understanding of ca-derivations

**Tasks:**
- Reading and modifying nix expressions
- Understanding package dependencies
- Configuring system services
- Managing user environments

### 2. Blueprint Framework

**Required:**
- Understanding Blueprint framework concepts
- Knowledge of Blueprint outputs
- Familiarity with Blueprint modules
- Experience with Blueprint devshells

**Tasks:**
- Using Blueprint's configuration structure
- Testing configurations with Blueprint
- Understanding Blueprint's output derivation system

### 3. DevOps/Infrastructure

**Required:**
- Understanding of system administration
- Knowledge of Docker containers
- Familiarity with TPM 2.0 configuration
- Experience with disk partitioning (disko)

**Tasks:**
- Configuring virtual machines
- Setting up network services
- Managing hardware-specific configurations
- Deploying to remote hosts

## Optional Skills (Nice to Have)

### 1. Vim/Editor Configuration

- Vim configuration and plugin management
- Understanding vimrc/vim configuration
- Custom Vim keybindings and settings

### 2. GNOME Desktop

- GNOME desktop environment configuration
- GDM display manager setup
- GNOME extensions management

### 3. Docker/Podman

- Docker container management
- Container build and testing
- Docker Compose configurations

### 4. Print Services

- CUPS printing configuration
- Printer driver management
- Network printing setup

### 5. Development Tools

- OctoPrint configuration (3D printing)
- Development shell setup
- Build system configuration

## Common Agent Tasks

### Task: Add a New Package

**Steps:**
1. Identify if package is system-level or user-level
2. Add to appropriate `host-shared.nix` file
3. Maintain alphabetical order with `keep-sorted` comments
4. Test in VM before deploying

**Example:**
```nix
# In modules/nixos/host-shared.nix
environment.systemPackages = with pkgs; [
  # ... existing packages ...
  new-package,  # Add here, maintain alphabetical order
  # ... more packages ...
];
```

### Task: Add a New Host

**Steps:**
1. Create directory `hosts/<new-host-name>/`
2. Create `configuration.nix` importing shared modules
3. Create `hardware-configuration.nix` (auto-detected)
4. Create `users/will/home-configuration.nix`
5. Add host to `flake.nix` outputs if needed

**Example structure:**
```
hosts/my-new-host/
├── configuration.nix
├── hardware-configuration.nix
└── users/will/home-configuration.nix
```

### Task: Modify Shared Settings

**System-level:**
- Edit `modules/nixos/host-shared.nix`
- Changes apply to all hosts by default
- Host-specific overrides in individual `configuration.nix`

**User-level:**
- Edit `modules/home/host-shared.nix`
- Changes apply to all users by default
- Host-specific overrides in individual `home-configuration.nix`

### Task: Test Configuration Changes

**Quick VM Test:**
```bash
nix run .#nixosConfigurations.<hostname>.config.system.build.vm
```

**Home Manager Test:**
```bash
nom build -f ./docker/hmtest.nix
docker load -i ./result
docker run -it localhost/home-manager-testshell
```

### Task: Format Code

```bash
treefmt
# or specific file
treefmt --glob "*.nix"
```

## Agent Guidelines

### When Helping with NixOS Configurations

1. **Read the relevant files first** - Understand the current configuration before making changes
2. **Check shared vs host-specific** - Know which settings are shared and which are host-specific
3. **Maintain alphabetical order** - Use `keep-sorted` comments to maintain order
4. **Test before deploying** - Always test in VM first
5. **Document changes** - Add comments explaining why changes were made

### When Adding New Features

1. **Check existing configurations** - See if similar features already exist
2. **Follow existing patterns** - Match the style and structure of existing configs
3. **Use shared modules** - Prefer shared modules over duplicating configurations
4. **Update documentation** - Add to appropriate documentation files
5. **Add to devshells** - Consider adding new tools to devshells.nix

### When Troubleshooting

1. **Check hardware configuration** - Hardware-specific issues often need hardware-configuration.nix updates
2. **Review shared modules** - Shared settings might conflict with host-specific settings
3. **Check state versions** - Ensure stateVersion is compatible with NixOS version
4. **Review imports** - Missing imports can cause configuration errors
5. **Use debug commands** - Run `nix flake outputs` to see available configurations

## Documentation Files

| File | Purpose |
|------|---------|
| [`README.md`](README.md) | Main project documentation |
| [`AGENTS.md`](AGENTS.md) | Guide for AI agents |
| [`SKILLS.md`](SKILLS.md) | Skills reference (this file) |
| [`docker/README.md`](docker/README.md) | Docker testing documentation |

## Additional Resources

- [Blueprint Documentation](https://numtide.blueprint/)
- [NixOS Wiki](https://nixos.org/wikis/index.php?title=Main_Page)
- [Home Manager Documentation](https://github.com/nix-community/home-manager)
- [Disko Documentation](https://github.com/nix-community/disko)
- [Srvos Documentation](https://github.com/nix-community/srvos)
