return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local icons = {
        -- Mode ikonları (Nerd Font)
        mode = {
          NORMAL   = "  NORMAL",
          INSERT   = "  INSERT",
          VISUAL   = "  VISUAL",
          V_LINE   = " 󰕘 V-LINE",
          V_BLOCK  = " 󰛄 V-BLOCK",
          COMMAND  = "  COMMAND",
          REPLACE  = "  REPLACE",
          TERMINAL = "  TERMINAL",
          SELECT   = "  SELECT",
        },
        -- Durum ikonları
        git    = { branch = "" },
        diff   = { added = " ", modified = "󰝤 ", removed = " " },
        diag   = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
        file   = { readonly = "󰌾 ", modified = "● " },
        loc    = { line = " ", col = " " },
        enc    = { unix = "", dos = "", mac = "" },
      }

      -- Mode renk paleti (Catppuccin Mocha uyumlu)
      local mode_colors = {
        n      = "#cba6f7",  -- mauve   (Normal)
        i      = "#a6e3a1",  -- green   (Insert)
        v      = "#89b4fa",  -- blue    (Visual)
        V      = "#89b4fa",
        ["\22"] = "#89b4fa",
        c      = "#f9e2af",  -- yellow  (Command)
        R      = "#f38ba8",  -- red     (Replace)
        s      = "#94e2d5",  -- teal    (Select)
        S      = "#94e2d5",
        t      = "#fab387",  -- peach   (Terminal)
      }

      -- Mode label helper
      local function mode_label()
        local mode_map = {
          ["n"]   = icons.mode.NORMAL,
          ["no"]  = icons.mode.NORMAL,
          ["nov"] = icons.mode.NORMAL,
          ["i"]   = icons.mode.INSERT,
          ["ic"]  = icons.mode.INSERT,
          ["v"]   = icons.mode.VISUAL,
          ["V"]   = icons.mode.V_LINE,
          ["\22"] = icons.mode.V_BLOCK,
          ["c"]   = icons.mode.COMMAND,
          ["R"]   = icons.mode.REPLACE,
          ["Rv"]  = icons.mode.REPLACE,
          ["s"]   = icons.mode.SELECT,
          ["S"]   = icons.mode.SELECT,
          ["t"]   = icons.mode.TERMINAL,
        }
        return mode_map[vim.fn.mode()] or (" " .. vim.fn.mode():upper())
      end

      -- Dinamik mode rengi
      local function mode_color()
        local col = mode_colors[vim.fn.mode()] or "#cba6f7"
        return { fg = "#1e1e2e", bg = col, gui = "bold" }
      end

      -- Git branch
      local function git_branch()
        local branch = vim.b.gitsigns_head or vim.g.gitsigns_head
        if branch and branch ~= "" then
          return icons.git.branch .. " " .. branch
        end
        return ""
      end

      -- Dosya encoding ikonu
      local function file_encoding()
        local enc = vim.opt.fileencoding:get()
        return (enc ~= "" and enc ~= "utf-8") and enc:upper() or ""
      end

      -- Dosya format ikonu
      local function file_format()
        local fmt = vim.bo.fileformat
        if fmt == "dos"  then return icons.enc.dos  .. " CRLF" end
        if fmt == "mac"  then return icons.enc.mac  .. " CR"   end
        return ""  -- unix için gösterme (varsayılan)
      end

      require("lualine").setup({
        options = {
          theme                = "catppuccin",
          globalstatus         = true,           -- tek statusline (tüm pencereler)
          component_separators = { left = "", right = "" },
          section_separators   = { left = "", right = "" },
          disabled_filetypes   = {
            statusline = { "neo-tree", "lazy", "mason" },
          },
        },

        sections = {
          -- ─── Sol ──────────────────────────────────────────────
          lualine_a = {
            {
              mode_label,
              color       = mode_color,
              padding     = { left = 1, right = 1 },
              separator   = { left = "", right = "" },
            },
          },

          lualine_b = {
            {
              git_branch,
              color   = { fg = "#cdd6f4", bg = "#313244", gui = "bold" },
              padding = { left = 1, right = 1 },
            },
            {
              "diff",
              symbols  = { added = icons.diff.added, modified = icons.diff.modified, removed = icons.diff.removed },
              diff_color = {
                added    = { fg = "#a6e3a1" },
                modified = { fg = "#f9e2af" },
                removed  = { fg = "#f38ba8" },
              },
              padding = { left = 0, right = 1 },
            },
          },

          lualine_c = {
            {
              "filetype",
              icon_only = true,
              padding   = { left = 2, right = 0 },
              colored   = true,
            },
            {
              "filename",
              path          = 1,       -- göreli yol
              symbols       = {
                modified  = icons.file.modified,
                readonly  = icons.file.readonly,
                unnamed   = "[No Name]",
                newfile   = "[New]",
              },
              color   = { fg = "#cdd6f4" },
              padding = { left = 1, right = 1 },
            },
          },

          -- ─── Sağ ──────────────────────────────────────────────
          lualine_x = {
            {
              "diagnostics",
              sources  = { "nvim_lsp" },
              symbols  = {
                error = icons.diag.error,
                warn  = icons.diag.warn,
                info  = icons.diag.info,
                hint  = icons.diag.hint,
              },
              diagnostics_color = {
                error = { fg = "#f38ba8" },
                warn  = { fg = "#f9e2af" },
                info  = { fg = "#89dceb" },
                hint  = { fg = "#94e2d5" },
              },
              padding = { left = 1, right = 1 },
            },
            {
              file_encoding,
              color   = { fg = "#a6adc8" },
              padding = { left = 1, right = 0 },
            },
            {
              file_format,
              color   = { fg = "#a6adc8" },
              padding = { left = 1, right = 1 },
            },
          },

          lualine_y = {
            {
              "progress",
              color   = { fg = "#cdd6f4", bg = "#313244" },
              padding = { left = 1, right = 0 },
            },
            {
              "location",
              color   = { fg = "#cdd6f4", bg = "#313244" },
              padding = { left = 0, right = 1 },
              fmt = function(str)
                -- "10:5" → " 10  5"
                local line, col = str:match("(%d+):(%d+)")
                if line and col then
                  return icons.loc.line .. line .. " " .. icons.loc.col .. col
                end
                return str
              end,
            },
          },

          lualine_z = {
            {
              function()
                -- Toplam satır sayısı
                return "󰦨 " .. vim.api.nvim_buf_line_count(0)
              end,
              color   = { fg = "#1e1e2e", bg = "#cba6f7", gui = "bold" },
              padding = { left = 1, right = 1 },
            },
          },
        },

        -- Deaktif pencereler için pasif bar
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {
            {
              "filename",
              path    = 1,
              color   = { fg = "#6c7086" },
              padding = { left = 2, right = 1 },
            },
          },
          lualine_x = {
            {
              "location",
              color   = { fg = "#6c7086" },
              padding = { left = 1, right = 2 },
            },
          },
          lualine_y = {},
          lualine_z = {},
        },

        extensions = { "neo-tree", "lazy", "mason", "quickfix", "man" },
      })
    end,
  },
}
