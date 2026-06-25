# AGENTS.md - Guide for AI Agents

This document provides essential information for AI agents to effectively help with this NixOS/Home Manager configuration project.

## Quick Start for Agents

### Understanding the Project

This project uses **Blueprint** (by numtide) as its core framework for managing NixOS and Home Manager configurations across multiple hosts.

### Key Files to Reference

| File | Purpose |
|------|---------|
| [`flake.nix`](flake.nix) | Main flake definition with all inputs and outputs |
| [`modules/nixos/host-shared.nix`](modules/nixos/host-shared.nix) | Shared NixOS-level settings |
| [`modules/home/host-shared.nix`](modules/home/host-shared.nix) | Shared Home Manager settings |
| [`hosts/*/configuration.nix`](hosts/nixos-thinkpad-01/configuration.nix) | Host-specific NixOS configs |
| [`hosts/*/hardware-configuration.nix`](hosts/nixos-thinkpad-01/hardware-configuration.nix) | Hardware detection configs |
| [`hosts/*/users/will/home-configuration.nix`](hosts/nixos-thinkpad-01/users/will/home-configuration.nix) | Host-specific home configs |
| [`devshells.nix`](devshells.nix) | Development environment definition |

### Common Commands

```bash
# Start development shell
nix develop

# Test a configuration in VM
nix run .#nixosConfigurations.<hostname>.config.system.build.vm

# Build and test home-manager
nom build -f ./docker/hmtest.nix
docker load -i ./result
docker run -it localhost/home-manager-testshell

# Format code
treefmt

# Deploy to host (requires nixos-anywhere)
nixos-anywhere --flake ./<hostname>.nix /path/to/target
```

## Project Structure

```
LinuxSettings/
├── flake.nix                    # Main flake with inputs/outputs
├── devshells.nix                # Development environment
├── modules/
│   ├── nixos/host-shared.nix    # Shared NixOS settings
│   └── home/host-shared.nix      # Shared Home Manager settings
├── hosts/                       # Host-specific configurations
│   ├── nixos-thinkpad-01/       # Personal ThinkPad T420
│   ├── hyperv-01/               # Hyper-V VM
│   ├── hyperv-02/               # Hyper-V VM with Disko
│   └── cheecent-printserver-01/ # Print server
├── docker/                      # Testing infrastructure
│   ├── default.nix
│   ├── hmtest.nix
│   └── nixshell-home-manager.nix
├── formatter.nix                # Code formatting config
├── devshell.toml                # DevShell configuration
└── README.md                    # Main documentation
```

## Host Configurations Overview

| Host | Purpose | Key Features |
|------|---------|--------------|
| `nixos-thinkpad-01` | Personal Desktop | GNOME, PipeWire, Docker, OctoPrint, Lid switch handling |
| `hyperv-01` | Hyper-V VM | Systemd-boot, TPM 2.0 emulation, GNOME/GDM |
| `hyperv-02` | Hyper-V VM | Disko partitioning, Systemd-boot, TPM 2.0 |
| `cheecent-printserver-01` | Print Server | CUPS, Systemd-boot, GNOME |

## Shared Modules

### System-Level (`modules/nixos/host-shared.nix`)

Common settings applied to all hosts:

- **System Packages**: `btop`, `vim`, `git`, `ncdu`, `vscode`, `treefmt`, `dmidecode`, etc.
- **Services**: Avahi (mDNS), TPM 2.0 with PKCS#11
- **Localization**: America/New_York timezone, en_US.UTF-8 locale

### Home-Manager Level (`modules/home/host-shared.nix`)

Common user environment settings:

- **Shell**: Bash with completion, Starship prompt
- **Tools**: direnv, fzf, git, ripgrep, navi, jqp, pay-respects
- **Vim**: Dark background, syntax highlighting, smart indentation
- **Git**: Configured with name "Will Flores"

## Common Tasks for Agents

### Adding a New Package

1. Add to `modules/nixos/host-shared.nix` in `environment.systemPackages`
2. Add to `modules/home/host-shared.nix` in `home.packages` (if user-level)
3. Keep alphabetical order (marked by `keep-sorted` comments)

### Modifying a Host Configuration

1. Edit the appropriate `hosts/<host>/configuration.nix`
2. For user-specific settings, edit `hosts/<host>/users/will/home-configuration.nix`
3. For hardware-specific settings, edit `hosts/<host>/hardware-configuration.nix`

### Adding a New Host

1. Create directory `hosts/<new-host-name>/`
2. Create `configuration.nix` with imports from `host-shared`
3. Create `hardware-configuration.nix` (auto-detected by nix)
4. Create `users/will/home-configuration.nix`
5. Add host to `flake.nix` outputs if needed

### Testing Changes

```bash
# Quick test in VM
nix run .#nixosConfigurations.<hostname>.config.system.build.vm

# Test home-manager
nom build -f ./docker/hmtest.nix
docker load -i ./result
docker run -it localhost/home-manager-testshell
```

### Formatting Code

```bash
treefmt
# or for specific files
treefmt --glob "*.nix"
```

## Blueprint Framework

This project uses the **Blueprint** framework which provides:

- Modular configuration structure
- Automatic outputs for VM testing
- Integration with Home Manager
- DevShell support
- Treefmt for formatting

See the [Blueprint documentation](https://numtide.blueprint/) for more details.

## Dependencies

The project uses these key inputs in [`flake.nix`](flake.nix):

- `blueprint` - Core framework
- `nixpkgs` - Nix packages (master branch)
- `devshell` - Development environment management
- `disko` - Declarative disk partitioning
- `home-manager` - User environment management
- `nix-index-database` - Nix store indexing
- `nixos-anywhere` - Remote deployment
- `srvos` - Server OS module
- `treefmt-nix` - Code formatting

## Security Notes

- TPM 2.0 is enabled with PKCS#11 support
- SSH agent forwarding is enabled
- GnuPG agent with SSH support is enabled
- Firewall is disabled by default (commented out)

## Troubleshooting

### Common Issues

1. **VM doesn't boot**: Check hardware-configuration.nix for correct hardware detection
2. **Home Manager errors**: Check host-specific home-configuration.nix
3. **Formatting issues**: Run `treefmt` to format all files
4. **Docker test failures**: Ensure Docker daemon is running

### Debug Commands

```bash
# Show nixpkgs version
nix eval .#nixpkgs

# Show blueprint version
nix eval .#blueprint

# List all outputs
nix flake outputs
```

## License

See [`LICENSE`](LICENSE) file for project license.
