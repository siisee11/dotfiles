return {
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup({
        mappings = { basic = false, extra = false },
      })

      local api = require("Comment.api")
      local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
      local toggle_visual = function()
        vim.api.nvim_feedkeys(esc, "nx", false)
        api.toggle.linewise(vim.fn.visualmode())
      end

      vim.keymap.set("n", "<leader>c/", api.toggle.linewise.current, { desc = "Toggle comment (current line)" })
      vim.keymap.set("x", "<leader>c/", toggle_visual, { desc = "Toggle comment (visual)" })
    end,
  },
}
