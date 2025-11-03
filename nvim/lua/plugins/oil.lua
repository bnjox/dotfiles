return {
  'stevearc/oil.nvim',
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    keymaps = {
      ["-"] = {
        desc = "Open oil floating window",
        callback = function()
          require("oil").open_float()
        end,
      },
      ["q"] = {
        desc = "Close floating window",
        callback = function()
          require("oil").close()
        end,
      },
      ["C-c"] = {
        desc = "Close float window if open",
        callback = function()
          require("oil").toggle_float()
        end,
      },
      ["C-h"] = {
        desc = "Toggle hidden files",
        callback = function()
          require("oil").toggle_hidden()
        end,
      },

    },
    float = {
      -- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
      max_width = 0.5,
      max_height = 0.5,
    },
  },
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
}
