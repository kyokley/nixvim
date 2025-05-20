{
  imports = [
    ./default.nix
  ];
  opts = {
    "fileformat" = "dos";
    "fileformats" = "dos,unix";
    "makeprg" = "dotnet\ build";
  };
}
