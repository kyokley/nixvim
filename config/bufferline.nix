{
  plugins.bufferline = {
    enable = true;
    themable = true;
    numbers = "buffer_id";
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
}
