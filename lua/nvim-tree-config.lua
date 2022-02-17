local DEFAULT_WINDOW_WIDTH = 50
local nvimTree = require('nvim-tree')
local nvimTreeLib = require('nvim-tree.lib')

nvimTree.setup {
  hijack_cursor = false,
  auto_close = true,
  disable_netrw = false,

  view = {
    width = DEFAULT_WINDOW_WIDTH,
    mappings = {
      list = { { key = "A", cb = ":lua NvimTreeToggleFullscreen()<cr>" } }
    }
  }
}

local function starts_with(String, Start)
  return string.sub(String, 1, string.len(Start)) == Start
end

function FindFileAndChangeCwdIfNeeded()
  local cwd = vim.fn.getcwd()
  local cur_path = vim.fn.expand('%:p:h')

  if starts_with(cur_path, cwd) then
    nvimTree.find_file(true)
  else
    nvimTreeLib.refresh_tree()
    nvimTreeLib.change_dir(cur_path)
    nvimTree.find_file(true)
    vim.cmd('cd ' .. cwd)
  end
end

function NvimTreeToggleFullscreen()
  local curr_width = vim.fn.winwidth(0)

  if curr_width == DEFAULT_WINDOW_WIDTH then
    vim.api.nvim_command('vertical resize "100%"')
  else
    vim.api.nvim_command('vertical resize ' .. DEFAULT_WINDOW_WIDTH)
  end
end

vim.api.nvim_set_keymap('n', '<leader>n', ':NvimTreeToggle<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>N', ':lua FindFileAndChangeCwdIfNeeded()<CR>', { noremap = true })
