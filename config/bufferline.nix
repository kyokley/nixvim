{
  plugins.bufferline = {
    enable = true;
    numbers = "buffer_id";
    separatorStyle = "slant";
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
}
