return {
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      local npairs = require("nvim-autopairs")

      npairs.setup({
        check_ts = true,
        ts_config = {
          lua = { "string" },
          javascript = { "template_string" },
        },
      })

      -- Düzeltme: <tag>|</tag> → Enter →
      --   <tag>
      --     |        (cursor + shiftwidth)
      --   </tag>
      vim.keymap.set("i", "<CR>", function()
        local line = vim.api.nvim_get_current_line()
        local col  = vim.api.nvim_win_get_cursor(0)[2]
        local before = line:sub(1, col)
        local after  = line:sub(col + 1)

        if before:match(">$") and after:match("^</[%w%-%.:]+>") then
          local row    = vim.api.nvim_win_get_cursor(0)[1] - 1  -- 0-indexed
          local indent = line:match("^(%s*)") or ""
          local sw     = vim.fn.shiftwidth()
          local pad    = string.rep(" ", sw)

          local middle_line  = indent .. pad
          local closing_line = indent .. after

          -- Cursor'dan satır sonuna kadar sil, yerine iki yeni satır ekle
          vim.api.nvim_buf_set_text(0, row, col, row, #line, {
            "",
            middle_line,
            closing_line,
          })

          -- Cursor'u orta satırın sonuna taşı (insert modunda kalır)
          vim.api.nvim_win_set_cursor(0, { row + 2, #middle_line })
          return
        end

        -- Diğer durumlarda normal autopairs CR
        local keys = vim.api.nvim_replace_termcodes(npairs.autopairs_cr(), true, true, true)
        vim.api.nvim_feedkeys(keys, "n", false)
      end, { noremap = true })

      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )
    end
  }
}
