-- return {
--   "catppuccin/nvim",
--   opts = {
--     transparent_background = "true",
--     terminal_colors = true,
--   },
--   config = function(_, opts)
--     require("catppuccin").setup(opts) -- calling setup is optional
--     vim.cmd([[colorscheme catppuccin]])
--   end,
-- }

return {
  "rebelot/kanagawa.nvim",
  opts = {
    transparent_background = "true",
    terminal_colors = true,
  },
  config = function(_, opts)
    require("kanagawa").setup(opts) -- calling setup is optional
    vim.cmd([[colorscheme kanagawa-dragon ]])
  end,
}
