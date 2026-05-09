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

        -- Bracket pairs aynı satırda: (|)  {|}  [|]
        local bracket_close = nil
        if not is_tag_pair then
          local open_close = { ["("] = ")", ["{"] = "}", ["["] = "]" }
          local last_open  = before:sub(-1)
          local first_close = after:sub(1, 1)
          if open_close[last_open] and open_close[last_open] == first_close then
            bracket_close = first_close
          end
        end

        -- Bracket pair farklı satırlarda: cursor satır sonunda {, sonraki satır }
        -- function app() {|      →  function app() {
        -- }                              |
        --                            }
        local bracket_next_line = nil
        if not is_tag_pair and not bracket_close and after == "" then
          local open_close = { ["("] = ")", ["{"] = "}", ["["] = "]" }
          local last_open  = before:sub(-1)
          if open_close[last_open] then
            local row       = vim.api.nvim_win_get_cursor(0)[1]  -- 1-indexed
            local buf_lines = vim.api.nvim_buf_get_lines(0, row, row + 1, false)
            local next_line = buf_lines[1] or ""
            local next_trim = next_line:match("^%s*(.-)%s*$") or ""
            if next_trim == open_close[last_open] then
              bracket_next_line = open_close[last_open]
            end
          end
        end

        if is_tag_pair or bracket_close then
          local row    = vim.api.nvim_win_get_cursor(0)[1] - 1  -- 0-indexed
          local indent = line:match("^(%s*)") or ""
          local pad    = string.rep(" ", vim.fn.shiftwidth())

          local middle_line  = indent .. pad
          -- tag için after'ın tamamı kapanış satırı; bracket için sadece after
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

        -- Bracket satır sonunda, kapanış sonraki satırda: {|\n}
        if bracket_next_line then
          local row    = vim.api.nvim_win_get_cursor(0)[1] - 1  -- 0-indexed
          local indent = line:match("^(%s*)") or ""
          local pad    = string.rep(" ", vim.fn.shiftwidth())
          local new_line = indent .. pad

          vim.schedule(function()
            -- Sadece mevcut satırın sonuna "\n  " ekle (kapanışa dokunma)
            vim.api.nvim_buf_set_text(0, row, col, row, #line, {
              "",
              new_line,
            })
            vim.api.nvim_win_set_cursor(0, { row + 2, #new_line })
          end)

          return ""
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
