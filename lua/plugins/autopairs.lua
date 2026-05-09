return {
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      local npairs = require("nvim-autopairs")

      npairs.setup({
        check_ts = true,
        map_cr = false,  -- bizim <CR> mapping'imiz halleder, çakışma olmasın
        ts_config = {
          lua = { "string" },
          javascript = { "template_string" },
        },
      })

      -- <CR> mapping: SADECE pair-split sorumluluğu
      --
      -- Kategori A — Pair Split (same line):
      --   <tag>|</tag>  veya  <>|</>  →  3 satıra böl
      --   {|}  (|)  [|]              →  3 satıra böl
      --
      -- Diğer tüm durumlar (satır sonu indent, kapanış sonraki satırda vb.)
      -- indentexpr (config/indent.lua) tarafından otomatik halledilir.
      vim.keymap.set("i", "<CR>", function()
        local ft = vim.bo.filetype
        local web_fts = {
          html = true, javascript = true, typescript = true,
          javascriptreact = true, typescriptreact = true,
        }

        -- Web olmayan dosyalar: autopairs'in kendi CR mantığını kullan
        if not web_fts[ft] then
          return npairs.autopairs_cr()
        end

        local line   = vim.api.nvim_get_current_line()
        local col    = vim.api.nvim_win_get_cursor(0)[2]
        local before = line:sub(1, col)
        local after  = line:sub(col + 1)

        -- Tag pair aynı satırda: <tag>|</tag>  veya  <>|</>
        local is_tag_pair = before:match(">$") and (
          after:match("^</[%w%-%.:]+>") or after:match("^</>")
        )

        -- Bracket pair aynı satırda: (|)  {|}  [|]
        local is_bracket_pair = false
        if not is_tag_pair then
          local pairs_map = { ["("] = ")", ["{"] = "}", ["["] = "]" }
          local last, first = before:sub(-1), after:sub(1, 1)
          is_bracket_pair = (pairs_map[last] == first)
        end

        -- Pair split: cursor tam ortada → 3 satıra böl
        if is_tag_pair or is_bracket_pair then
          local row    = vim.api.nvim_win_get_cursor(0)[1] - 1  -- 0-indexed
          local indent = line:match("^(%s*)") or ""
          local pad    = string.rep(" ", vim.fn.shiftwidth())

          vim.schedule(function()
            vim.api.nvim_buf_set_text(0, row, col, row, #line, {
              "",
              indent .. pad,   -- cursor buraya: indent + shiftwidth
              indent .. after, -- kapanış: aynı indent
            })
            vim.api.nvim_win_set_cursor(0, { row + 2, #(indent .. pad) })
          end)

          return ""
        end

        -- Fallback: autopairs_cr (bracket completion, undo history vb.)
        -- indentexpr yeni satırın indent'ini otomatik hesaplar
        return npairs.autopairs_cr()
      end, { noremap = true, expr = true })

      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )
    end
  }
}
