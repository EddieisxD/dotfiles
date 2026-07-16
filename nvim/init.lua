
if vim.loader then
  vim.loader.enable()
end


if vim.g.neovide then
    require("modules.neovide")
end

-- require("vim._core.ui2").enable({})
require("autocommands")
require("options")
require("keybinds")
require("transparent_nvim")

require("lazy_plugin_manager")
