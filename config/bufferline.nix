{
  plugins.bufferline = {
    enable = true;
    settings.options = {
      themable = true;
      numbers = "buffer_id";
      sort_by = "id";
      separatorStyle = "thick";
      showBufferCloseIcons = false;
      enforceRegularTabs = true;
      diagnostics = "nvim_lsp";
      diagnosticsIndicator = ''
        function(count, level, diagnostics_dict, context)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end
      '';
    };
  };
}
