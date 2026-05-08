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

      -- <tag>|</tag> veya <>|</> → Enter →
      --   <tag>          veya   <>
      --     |                     |     (cursor + shiftwidth)
      --   </tag>                </>
      vim.keymap.set("i", "<CR>", function()
        local line   = vim.api.nvim_get_current_line()
        local col    = vim.api.nvim_win_get_cursor(0)[2]
        local before = line:sub(1, col)
        local after  = line:sub(col + 1)

        -- Normal tag: <tag>|</tag>  veya  Fragment: <>|</>
        local is_tag_pair = before:match(">$") and (
          after:match("^</[%w%-%.:]+>") or after:match("^</>")
        )

        if is_tag_pair then
          local row    = vim.api.nvim_win_get_cursor(0)[1] - 1  -- 0-indexed
          local indent = line:match("^(%s*)") or ""
          local pad    = string.rep(" ", vim.fn.shiftwidth())

          local middle_line  = indent .. pad
          local closing_line = indent .. after

          -- expr map'te buffer değiştirilemez (E565), sonraki tick'e ertele
          vim.schedule(function()
            vim.api.nvim_buf_set_text(0, row, col, row, #line, {
              "",
              middle_line,
              closing_line,
            })
            vim.api.nvim_win_set_cursor(0, { row + 2, #middle_line })
          end)

          return ""  -- buffer zaten schedule ile halledilecek
        end

        -- Diğer durumlarda sade Enter (map_cr=false olduğundan autopairs çakışmaz)
        return "\r"
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
