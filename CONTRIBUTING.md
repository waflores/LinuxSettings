# CONTRIBUTING.md - Extending the Configuration System

This document provides guidance for extending and modifying this NixOS/Home Manager configuration system.

## Table of Contents

- [Adding New Packages](#adding-new-packages)
- [Adding New Hosts](#adding-new-hosts)
- [Modifying Shared Modules](#modifying-shared-modules)
- [Testing Changes](#testing-changes)
- [Best Practices](#best-practices)
- [Code Style](#code-style)

## Adding New Packages

### System-Level Packages

Add packages to `modules/nixos/host-shared.nix` in `environment.systemPackages`:

```nix
environment.systemPackages = with pkgs; [
  # keep-sorted start
  another-package,
  existing-package,
  new-package,  # Add here, maintaining alphabetical order
  # keep-sorted end
];
```

### User-Level Packages

Add user-level packages to `modules/home/host-shared.nix` in `home.packages`:

```nix
home.packages = [
  # keep-sorted start
  another-package,
  existing-package,
  new-package,  # Add here, maintaining alphabetical order
  # keep-sorted end
];
```

### Host-Specific Packages

For packages specific to a host, add directly to the host's `configuration.nix`:

```nix
# In hosts/<host>/configuration.nix
environment.systemPackages = with pkgs; [
  # Host-specific packages
  host-only-package,
];
```

## Adding New Hosts

### Step 1: Create Directory Structure

```bash
mkdir -p hosts/<new-host-name>/users/will
```

### Step 2: Create configuration.nix

```nix
{
  inputs,
  pkgs,
  flake,
  ...
}:
{
  imports = [
    inputs.srvos.nixosModules.desktop
    inputs.nixos-hardware.nixosModules.<hardware-module>
    flake.nix.nixosModules.host-shared
    ./hardware-configuration.nix
  ];

  networking.hostName = "<hostname>";

  nix = {
    enable = true;
    settings.trusted-users = [ "@wheel" ];
    settings.extra-experimental-features = [
      "nix-command"
      "flakes"
      "ca-derivations"
    ];
  };

  system.stateVersion = pkgs.lib.versions.majorMinor pkgs.lib.version;

  users.users.will = {
    isNormalUser = true;
    description = "Will Flores";
    hashedPassword = "<password-or-empty>";
    extraGroups = [ "wheel" ];
  };

  # Add host-specific configurations here
};
```

### Step 3: Create hardware-configuration.nix

This file is typically auto-detected by `nixos-anywhere`. Copy from an existing host and adjust hardware detection as needed.

### Step 4: Create home-configuration.nix

```nix
{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../../modules/home/host-shared.nix
  ];

  home.stateVersion = "26.05";

  programs = {
    bash.enable = true;
    # Add host-specific user configurations
  };
};
```

### Step 5: Update flake.nix (if needed)

Add the new host to `flake.nix` outputs if you want to expose it:

```nix
outputs = inputs:
  inputs.blueprint {
    # ... existing configuration ...
  };

# Add host-specific outputs if needed
# outputs.hosts.<hostname> = inputs.nixpkgs.lib.nixosSystem {
#   system = "x86_64-linux";
#   modules = [
#     ./hosts/<hostname>/configuration.nix
#   ];
# };
```

## Modifying Shared Modules

### System-Level Changes

Edit `modules/nixos/host-shared.nix`:

- **System packages**: Add/remove from `environment.systemPackages`
- **Services**: Configure shared services like Avahi, TPM
- **Localization**: Set default timezone and locale

### Home-Manager Changes

Edit `modules/home/host-shared.nix`:

- **Shell configuration**: Modify bash settings, aliases
- **User programs**: Add/remove from `home.packages`
- **Programs**: Configure vim, git, starship, etc.

### Best Practices for Shared Modules

1. **Keep settings generic**: Avoid host-specific configurations
2. **Document overrides**: Add comments when hosts override shared settings
3. **Use imports**: Import shared modules rather than duplicating code
4. **Test thoroughly**: Test changes across multiple hosts before committing

## Testing Changes

### Quick VM Test

Test a specific host configuration in a VM:

```bash
nix run .#nixosConfigurations.<hostname>.config.system.build.vm
```

### Home Manager Test

Test home-manager changes:

```bash
nom build -f ./docker/hmtest.nix
docker load -i ./result
docker run -it localhost/home-manager-testshell
```

### Full Test Suite

Run all tests:

```bash
nom test
```

### Format Code

Format all Nix files:

```bash
treefmt
```

## Best Practices

### Code Organization

1. **Use shared modules**: Prefer shared modules over duplicating configurations
2. **Keep sorted**: Maintain alphabetical order with `keep-sorted` comments
3. **Document changes**: Add comments explaining why changes were made
4. **Use ca-derivations**: Enable ca-derivations for better build performance

### Configuration Patterns

```nix
# Good: Host-specific override
{ config, pkgs, ... }:
{
  imports = [ ../../modules/nixos/host-shared.nix ];

  # Override shared setting
  services.printing = {
    enable = config.services.printing.enable;  # Keep shared setting
    drivers = config.services.printing.drivers ++ [ pkgs.cups-drivers ];  # Add host-specific
  };
}

# Good: Add to shared module
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # ...
    new-package,
    # ...
  ];
}
```

### Version Management

- **Track NixOS versions**: Use `pkgs.lib.version` for stateVersion
- **Document dependencies**: Add version comments in `flake.nix`
- **Lock inputs**: Use `flake.lock` for reproducible builds

## Code Style

### Nix Expression Style

1. **Use let bindings**: Group related configurations
2. **Comment imports**: Document why each import is needed
3. **Use consistent indentation**: 2 spaces for Nix
4. **Quote strings**: Use double quotes for strings with spaces
5. **Sort imports**: Keep imports alphabetically sorted

### Example Good Style

```nix
{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.<hardware>
    flake.nix.nixosModules.host-shared
    ./hardware-configuration.nix
  ];

  networking.hostName = "my-host";

  # Enable flakes and ca-derivations
  nix = {
    enable = true;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "ca-derivations"
      ];
    };
  };

  # System packages (sorted alphabetically)
  environment.systemPackages = with pkgs; [
    # keep-sorted start
    btop,
    git,
    vim,
    # keep-sorted end
  ];

  # Services
  services = {
    # Shared service
    avahi.enable = true;

    # Host-specific service
    printing.enable = true;
  };
};
```

## Common Tasks Reference

### Adding a Service

```nix
# 1. Add to shared module (if applicable)
# In modules/nixos/host-shared.nix
services.<service-name>.enable = true;

# 2. Or add to host-specific config
# In hosts/<host>/configuration.nix
services.<service-name>.enable = true;
```

### Adding a User

```nix
# In hosts/<host>/configuration.nix
users.users.<username> = {
  isNormalUser = true;
  description = "User description";
  extraGroups = [ "wheel" "docker" ];
};
```

### Enabling a Desktop Environment

```nix
# In hosts/<host>/configuration.nix
services.xserver.enable = true;
services.displayManager.gdm.enable = true;
services.desktopManager.gnome.enable = true;
```

### Configuring Audio

```nix
# In hosts/<host>/configuration.nix
services.pulseaudio.enable = false;
security.rtkit.enable = true;
services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
};
```

## Troubleshooting

### Configuration Doesn't Apply

1. **Check imports**: Ensure shared modules are imported
2. **Check stateVersion**: Ensure compatibility with NixOS version
3. **Rebuild**: Run `sudo nix-collect-garbage -d`
4. **Check logs**: Review `/var/log/nixos/switch.log`

### Home Manager Errors

1. **Check imports**: Ensure `modules/home/host-shared.nix` is imported
2. **Check stateVersion**: Verify it matches NixOS stateVersion
3. **Verbose mode**: Use `nom switch -v` for detailed output
4. **Backup**: Home Manager creates `.bak` files on errors

### Build Failures

1. **Clean rebuild**: `nix-collect-garbage -d && nix flake lock && nix flake develop`
2. **Check inputs**: Run `nix flake lock --update-input <input-name>`
3. **Format code**: Run `treefmt` to fix formatting issues

## Resources

- [Blueprint Documentation](https://numtide.blueprint/)
- [NixOS Wiki](https://nixos.org/wikis/index.php?title=Main_Page)
- [Home Manager Documentation](https://github.com/nix-community/home-manager)
- [Nix Expression Language](https://nixos.org/manual/nix/stable/language/expressions.html)
