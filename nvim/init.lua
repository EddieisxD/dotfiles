
if vim.loader then
  vim.loader.enable()
end

if vim.g.neovide then
    require("modules.neovide")
end

-- require("vim._core.ui2").enable({})
require("autocommands")
require("lazy_plugin_manager")
require("transparent_nvim")
-- require("theme.cursor_mode").setup()

require("options")
require("language_settings")
require("keybinds")

