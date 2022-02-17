local lsp_installer = require('nvim-lsp-installer')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  client.resolved_capabilities.document_formatting = true

  --Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- vim.api.nvim_command('autocmd CursorHold * silent :lua vim.diagnostic.show_line_diagnostics()')
end

vim.o.completeopt = 'menuone,noinsert'

local server_overrides = {
  sumneko_lua = {
    settings = {
      Lua = {
        diagnostics = { globals = { 'vim' } }
      }
    }
  },
  tsserver = {
    on_attach = function(client)
      on_attach(client)
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false
    end
  }
}

local default_server_settings = {
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 400,
  }
}

local function get_server_config(server_name)
  local config = {}
  for key, value in pairs(default_server_settings) do
    config[key] = value
  end

  for key, value in pairs(server_overrides[server_name] and server_overrides[server_name] or {}) do
    config[key] = value
  end
  return config
end

lsp_installer.on_server_ready(function(server)
  local config = get_server_config(server.name)
  server:setup(config)
end)
