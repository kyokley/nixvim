{
    imports = [
        ./minimal.nix
    ];

    extraPython3Packages = p: with p; [
        bandit
    ];

}
