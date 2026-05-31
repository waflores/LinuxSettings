# Nix for Docker

These configs poke around with how `nix` and `docker` mix.

## Running the tests

We can run the tests by doing the following:

```bash
nom build -f ./hmtest.nix

```

and

```bash
nom build -f ./nixshell-home-manager.nix
docker load -i ./result

# We can see what we've loaded here
docker images

REPOSITORY                        TAG                               IMAGE ID      CREATED       SIZE
localhost/home-manager-testshell  lj3rnyplcjh9jasp1mnq6zx5nhaz4kys  7da0f9751848  56 years ago  466 MB
```

We can run this `docker` image:

```bash
docker run -it localhost/home-manager-testshell:lj3rnyplcjh9jasp1mnq6zx5nhaz4kys

touch: cannot touch '/home/will/test-file': No such file or directory
home directory is not writable
```
