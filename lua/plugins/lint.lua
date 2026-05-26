return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile", "InsertLeave" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        html = { "htmlhint" },
      }

      -- Suppress "doctype-first" error for files under "app/" in Angular projects
      local htmlhint = lint.linters.htmlhint
      if htmlhint then
        local original_parser = htmlhint.parser
        if original_parser then
          htmlhint.parser = function(output, bufnr)
            local diagnostics = original_parser(output, bufnr)
            local filepath = vim.api.nvim_buf_get_name(bufnr or 0)
            if filepath ~= "" and filepath:find("[/\\]app[/\\]") then
              -- Check if this is an Angular project by searching upwards for angular.json or project.json
              local is_angular = #vim.fs.find({ "angular.json", "project.json" }, { path = filepath, upward = true }) > 0
              if is_angular then
                local filtered = {}
                for _, diag in ipairs(diagnostics) do
                  if diag.code ~= "doctype-first" then
                    table.insert(filtered, diag)
                  end
                end
                return filtered
              end
            end
            return diagnostics
          end
        end
      end

      -- Create autocommand to run linter
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  }
}

