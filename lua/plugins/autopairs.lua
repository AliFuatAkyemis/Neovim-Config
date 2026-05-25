return {
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      local npairs = require("nvim-autopairs")

      npairs.setup({
        check_ts = true,
        map_cr = true,  -- Kendi <CR> mapping'imiz nvim-cmp ile çakıştığından map_cr aktif edildi.
        ts_config = {
          lua = { "string" },
          javascript = { "template_string" },
          typescript = { "template_string" },
        },
      })

      -- <CR> mapping'deki "<80>ýal! ====" hatası (cmp fallback bug) nedeniyle
      -- custom vim.keymap.set kaldırıldı. npairs.autopairs_cr() map_cr=true ile
      -- otomatik ve sorunsuz bir şekilde pair-split işlemini yönetir.
      -- indentexpr (config/indent.lua) kaldığı yerden çalışmaya devam eder.

      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )
    end
  }
}
