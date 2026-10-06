# Nixvim template

This template gives you a good starting point for configuring nixvim standalone.

## Configuring

To start configuring, just add or modify the nix files in `./config`.
If you add a new configuration file, remember to add it to the
[`config/default.nix`](./config/default.nix) file

## Testing your new configuration

To test your configuration simply run the following command

```
nix run .
```

## GitHub Actions build and cache

The `Build and Cache Nixvim` workflow builds the full default configuration for
`x86_64-linux` and caches it to the `horus` Cachix cache on pushes to `main` or
manual runs. Add a repository Actions secret named `CACHIX_AUTH_TOKEN` with a
token that has write access to `horus`. Keep the token out of source code.
