-- lua/config/indent.lua
-- VSCode onEnterRules mantığıyla custom indentexpr
-- html / javascript / typescript / jsx / tsx için Treesitter indent'in yerine geçer

local M = {}

-- Kural tablosu — ilk eşleşen kural kazanır
-- before      : önceki satıra uygulanan Lua pattern (eşleşmeli)
-- before_not  : önceki satıra uygulanan Lua pattern (eşleşmemeli)
-- current     : hesaplanan yeni satıra uygulanan Lua pattern (eşleşmeli)
-- action      : "indent" | "outdent" | "none"
local rules = {
  -- ── Boş Bloklar → none ───────────────────────────────────────────────────
  -- Eğer önceki satır açılışla bitiyor ve mevcut satır kapanışla başlıyorsa,
  -- aynı hizada kalmalıdır (outdent uygulanmaz).
  {
    before     = ">%s*$",
    before_not = { "/>%s*$", "</[%w%-%.:]+>%s*$" },
    current    = "^%s*</",
    action     = "none",
  },
  { before = "{%s*$",  current = "^%s*}",  action = "none" },
  { before = "%(%-*$", current = "^%s*%)", action = "none" },
  { before = "%[%s*$", current = "^%s*%]", action = "none" },

  -- ── Kapanış → outdent ────────────────────────────────────────────────────
  -- Mevcut satır kapanış ile başlıyorsa bir seviye geri al (outdent)
  { current = "^%s*</", action = "outdent" },
  { current = "^%s*}",  action = "outdent" },
  { current = "^%s*%)", action = "outdent" },
  { current = "^%s*%]", action = "outdent" },

  -- ── Açılış → indent ──────────────────────────────────────────────────────
  -- Önceki satır açık tag ile bitiyorsa: <head>, <div class="x">
  -- Hariç: /> (self-closing)  ve  </tag> (closing tag)
  {
    before     = ">%s*$",
    before_not = { "/>%s*$", "</[%w%-%.:]+>%s*$" },
    action     = "indent",
  },
  -- Önceki satır { ile bitiyorsa
  { before = "{%s*$",  action = "indent" },
  -- Önceki satır ( ile bitiyorsa
  { before = "%(%-*$", action = "indent" },
  -- Önceki satır [ ile bitiyorsa
  { before = "%[%s*$", action = "indent" },
}

function M.get_indent()
  local lnum      = vim.v.lnum
  local prev_lnum = vim.fn.prevnonblank(lnum - 1)
  if prev_lnum == 0 then return 0 end

  local prev_line    = vim.fn.getline(prev_lnum)
  local current_line = vim.fn.getline(lnum)
  local base_indent  = vim.fn.indent(prev_lnum)
  local sw           = vim.fn.shiftwidth()

  for _, rule in ipairs(rules) do
    -- before: eşleşmeli
    local before_ok = (rule.before == nil) or (prev_line:match(rule.before) ~= nil)

    -- before_not: hiçbiri eşleşmemeli (tablo veya string kabul eder)
    local before_not_ok = true
    if rule.before_not ~= nil then
      local patterns = type(rule.before_not) == "table"
        and rule.before_not
        or { rule.before_not }
      for _, pat in ipairs(patterns) do
        if prev_line:match(pat) then
          before_not_ok = false
          break
        end
      end
    end

    -- current: eşleşmeli
    local current_ok = (rule.current == nil) or (current_line:match(rule.current) ~= nil)

    if before_ok and before_not_ok and current_ok then
      if rule.action == "indent"  then return base_indent + sw end
      if rule.action == "outdent" then return math.max(0, base_indent - sw) end
      if rule.action == "none"    then return base_indent end
    end
  end

  return base_indent  -- default: önceki satırla aynı hiza (autoindent)
end

return M
