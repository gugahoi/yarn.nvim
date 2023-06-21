-- make sure to ':so %' to get the following benefit while developing
-- leader + enter to reload and run the plugin
vim.keymap.set("n", "<leader><enter>", function()
  package.loaded.yarn = nil
  require("yarn").setup()
  require("yarn").run()
end, {})
