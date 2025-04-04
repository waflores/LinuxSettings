# LinuxSettings

Personalized settings for my linux rigs.

Personalizations include:

- vim settings
- bash settings
- git settings

## Testing NixOS Configs
We can try things out by running the config in a VM like so:

```bash
nix run .#nixosConfigurations.<hostname>.config.system.build.vm

# or in 2 parts
nom build .#nixosConfigurations.<hostname>.config.system.build.vm
./result/bin/run-<hostname>-vm  # We can add qemu specific options here
```