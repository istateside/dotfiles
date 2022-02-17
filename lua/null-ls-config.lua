local nls = require('null-ls')
require('null-ls.helpers')
local lsputil = require('lspconfig.util')

local function check_dir_for_eslint(dir)
  return (
    string.find(dir, 'squarespace%-v6') or
    lsputil.path.exists(lsputil.path.join(dir, '.eslintrc')) or
    lsputil.path.exists(lsputil.path.join(dir, '.eslintrc.js')) or
    lsputil.path.exists(lsputil.path.join(dir, '.eslintrc.cjs')) or
    lsputil.path.exists(lsputil.path.join(dir, '.eslintrc.yaml')) or
    lsputil.path.exists(lsputil.path.join(dir, '.eslintrc.yml')) or
    lsputil.path.exists(lsputil.path.join(dir, '.eslintrc.json'))
  )
end

local function eslint_condition()
  local filepath = vim.fn.fnamemodify(vim.fn.expand('%'), ':p:h')

  return check_dir_for_eslint(filepath) or lsputil.path.traverse_parents(filepath, check_dir_for_eslint)
end

local sources = {
  nls.builtins.diagnostics.eslint.with({
    condition = eslint_condition
  }),
  nls.builtins.formatting.eslint.with({
    condition = eslint_condition
  }),

  nls.builtins.formatting.stylelint.with({
      extra_args = { "--config", "/Users/kfleischman/.stylelintrc.yaml" }
  }),
  nls.builtins.diagnostics.stylelint.with({
      extra_args = { "--config", "/Users/kfleischman/.stylelintrc.yaml" }
  }),
}

nls.setup({ sources = sources })
