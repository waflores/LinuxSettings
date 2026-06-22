# LinuxSettings

Personalized NixOS and Home Manager configurations for Will Flores's Linux systems.

This project provides a modular, reproducible, and declarative approach to configuring Linux systems using Nix Flakes.

## 📋 Table of Contents

- [Overview](#overview)
- [Project Structure](#project-structure)
- [Host Configurations](#host-configurations)
- [Shared Modules](#shared-modules)
- [Development Environment](#development-environment)
- [Docker Testing](#docker-testing)
- [Common Commands](#common-commands)
- [Contributing](#contributing)
- [License](#license)

## Overview

This project manages configurations for multiple Linux systems:

| Host | Purpose | Type |
| ---- | ------- | ---- |
| `nixos-thinkpad-01` | Personal ThinkPad T420 | Desktop |
| `hyperv-01` | Hyper-V VM | Server/VM |
| `hyperv-02` | Hyper-V VM with Disko | Server/VM |
| `cheecent-printserver-01` | Print Server | Server |

### Key Features

- **Reproducible**: All configurations are stored in version control
- **Modular**: Shared modules for common settings across hosts
- **Testable**: Docker-based testing for configurations
- **Modern**: Uses latest NixOS features including flakes, ca-derivations

## Project Structure

```bash
LinuxSettings/
├── .gitignore              # Git ignore rules
├── devshell.toml           # Development shell configuration
├── devshells.nix           # DevShell flake definition
├── flake.lock              # Locked flake inputs
├── flake.nix               # Main flake definition
├── formatter.nix           # Code formatting configuration
├── LICENSE                 # License file
├── README.md               # This file
├── docker/                 # Docker testing configurations
│   ├── README.md
│   ├── default.nix
│   ├── hmtest.nix
│   └── nixshell-home-manager.nix
├── hosts/                  # Host-specific configurations
│   ├── cheecent-printserver-01/
│   │   └── configuration.nix
│   ├── hyperv-01/
│   │   └── configuration.nix
│   ├── hyperv-02/
│   │   ├── configuration.nix
│   │   ├── disko-config.nix
│   │   └── hardware-configuration.nix
│   ├── nixos-thinkpad-01/
│   │   ├── configuration.nix
│   │   ├── hardware-configuration.nix
│   │   └── users/will/home-configuration.nix
│   ├── nixos-thinkpad-02/
│   │   ├── configuration.nix
│   │   ├── hardware-configuration.nix
│   │   └── users/will/home-configuration.nix
│   └── nixos-thinkpad-03/
│       ├── configuration.nix
│       ├── hardware-configuration.nix
│       └── users/will/home-configuration.nix
└── modules/                # Shared modules
    ├── home/
    │   └── host-shared.nix
    └── nixos/
        └── host-shared.nix
```

## Host Configurations

### nixos-thinkpad-01

**Purpose**: Personal desktop on Lenovo ThinkPad T420

**Key Features**:

- GNOME Desktop Environment
- CUPS printing support
- Pipewire audio
- Docker virtualization
- OpenSSH server
- Lid switch handling (no suspend on external power)

**System Packages**:

- System monitoring (btop)
- Disk analysis (ncdu)
- Network tools (netsniff-ng)
- Development tools (vim, git)
- TPM 2.0 support for security

```bash
# Test this configuration in a VM
nix run .#nixosConfigurations.nixos-thinkpad-01.config.system.build.vm
```

### hyperv-01

**Purpose**: Hyper-V virtual machine for testing

**Key Features**:

- Systemd-boot bootloader
- GNOME Desktop Environment
- GDM display manager
- TPM 2.0 emulation support

**Note**: Configuration includes testing-specific settings (Grub disabled, null filesystem).

```bash
# Test this configuration in a VM
nix run .#nixosConfigurations.hyperv-01.config.system.build.vm
```

### hyperv-02

**Purpose**: Hyper-V virtual machine with disko partitioning

**Key Features**:

- Disko disk partitioning
- Systemd-boot bootloader
- TPM 2.0 emulation support

**Note**: Uses disko for disk configuration.

```bash
# Test this configuration in a VM
nix run .#nixosConfigurations.hyperv-02.config.system.build.vm
```

### cheecent-printserver-01

**Purpose**: Print server configuration

**Key Features**:

- Systemd-boot bootloader
- GNOME Desktop Environment
- Print services

**Note**: Includes testing-specific settings (Grub disabled, null filesystem).

```bash
# Test this configuration in a VM
nix run .#nixosConfigurations.cheecent-printserver-01.config.system.build.vm
```

## Shared Modules

### NixOS Host Shared (`modules/nixos/host-shared.nix`)

Common NixOS-level settings applied to all hosts:

- **System Packages**:
  - `btop` - System monitoring
  - `dmidecode` - System information
  - `git` - Version control
  - `ncdu` - Disk usage analyzer
  - `netsniff-ng` - Network analysis
  - `nix-output-monitor` - Nix output
  - `pciutils` - PCI device info
  - `screen` - Terminal multiplexer
  - `tree` - Directory tree viewer
  - `usbutils` - USB device info
  - `vim` - Text editor
  - `vscode` - Visual Studio Code

- **Services**:
  - Avahi (mDNS/Zeroconf)
  - TPM 2.0 support with PKCS#11

- **Localization**:
  - Timezone: America/New_York
  - Locale: en_US.UTF-8

### Home Manager Host Shared (`modules/home/host-shared.nix`)

Common Home Manager settings applied to all users:

- **Shell Configuration**:
  - Bash with completion
  - Custom aliases (reload config, direnv)
  - Starship prompt
  - Nix-index database

- **Programs**:
  - direnv (Nix environment management)
  - fzf (Fuzzy finder)
  - git
  - jqp (JSON Query/Printer)
  - navi (File navigation)
  - nix-index-database
  - pay-respects (Git branch management)
  - ripgrep-all (Recursive search)
  - vim with custom settings

- **Vim Settings**:
  - Dark background
  - Syntax highlighting
  - Smart indentation
  - Search highlighting

## Development Environment

### Using DevShells

The project provides devshells for consistent development environments:

```bash
# Start the devshell
nix develop

# Or use devshell command
devshell run --command "nix run .#nixosConfigurations.nixos-thinkpad-01.config.system.build.vm"
```

### Formatting

Code formatting is handled by `treefmt-nix`:

```bash
# Format all files
treefmt

# Format a specific file
treefmt --glob "*.nix"
```

### Running Tests

```bash
# Run all tests
nom test

# Run specific test
nom build -f ./docker/hmtest.nix
```

## Docker Testing

The `docker/` directory contains configurations for testing NixOS configurations in Docker:

### Building Test Images

```bash
# Build home-manager test image
nom build -f ./docker/hmtest.nix

# Build nixshell home-manager test image
nom build -f ./docker/nixshell-home-manager.nix
```

### Loading Images

```bash
# Load the built image
docker load -i ./result
```

### Running Test Images

```bash
# Run a test image
docker run -it localhost/home-manager-testshell
```

### Testing with NixShell

```bash
./result/bin/run-<hostname>-vm
```

## Common Commands

### Testing a Configuration

```bash
# Quick test in VM
nix run .#nixosConfigurations.<hostname>.config.system.build.vm

# Using nix-shell
nix-shell --run "nix run .#nixosConfigurations.<hostname>.config.system.build.vm"
```

### Deploying to a Host

```bash
# Copy configuration to a host
nixos-rebuild switch --flake hosts/<hostname>

# Or using nixos-anywhere
nixos-anywhere --flake .
```

### Reloading Home Manager

```bash
# Reload home-manager configuration
${pkgs.lib.getExe pkgs.home-manager} switch --flake . -b 'bak' && exec bash
```

### Disk Usage Analysis

```bash
# Analyze disk usage with ncdu
ncdu /

# View directory tree
tree -L 2
```

### System Monitoring

```bash
# System monitoring with btop
btop

# View network connections
netsniff-ng -i eth0
```

## Flake Inputs

The project uses the following flake inputs:

| Input | Purpose |
| ----- | ------- |
| `blueprint` | Blueprint flake module system |
| `devshell` | Development shell support |
| `disko` | Disk partitioning and formatting |
| `home-manager` | Home directory configuration |
| `nix-index-database` | Nix file indexing |
| `nixos-anywhere` | Remote NixOS deployment |
| `nixos-hardware` | Hardware-specific configurations |
| `srvos` | Server-oriented NixOS modules |
| `treefmt-nix` | Code formatting and linting |

## Configuration Notes

### Password Hash

All host configurations use a hashed password for the `will` user. To change the password:

1. Generate a new hash:

   ```bash
   nix shell nixpkgs#openssl -c "echo -n 'yourpassword' | openssl passwd -6 -salt"
   ```

2. Replace the `hashedPassword` in each host's `configuration.nix`.

### TPM 2.0 Setup

TPM 2.0 is enabled in shared modules for security features. For production use, ensure:

- TPM hardware is properly initialized
- PKCS#11 module is loaded
- TPM environment variables are set

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run formatting: `treefmt`
5. Test configurations in VM
6. Submit a pull request

### Code Style

- Keep sorted imports (see `keep-sorted` comments)
- Use consistent indentation
- Run `treefmt` before committing

## License

See the `LICENSE` file for details.

## Resources

- [NixOS Wiki](https://nixos.org/wikis/index.php?title=Main_Page)
- [Home Manager Wiki](https://nix-community.github.io/home-manager/index.html)
- [Nix Flakes Documentation](https://nixos.org/manual/nix/stable/language/flakes.html)