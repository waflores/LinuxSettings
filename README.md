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

If you want to mount a folder from the host to the VM, we can do this:
```bash
./result/bin/run-hyperv-01-vm -virtfs local,path=$PWD,security_model=none,mount_tag=host0

# and on the VM we can do this:
mkdir -p /mount/point
mount -t 9p -o trans=virtio host0 /mount/point -oversion=9p2000.L
```