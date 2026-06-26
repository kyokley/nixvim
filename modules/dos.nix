{
  flake.nixvimModules.dos = {
    opts = {
      "fileformat" = "dos";
      "fileformats" = "dos,unix";
      "makeprg" = "dotnet\ build";
    };
  };
}
