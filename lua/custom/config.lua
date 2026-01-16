-- Neovide config
if vim.g.neovide then
  vim.g.neovide_cursor_animation_length = 0
  vim.o.guifont = 'Ubuntu Mono:h13'
end

vim.opt.clipboard = 'unnamedplus'

if vim.fn.has 'wsl' == 1 then
  vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('Yank', { clear = true }),
    callback = function()
      vim.fn.system('clip.exe', vim.fn.getreg '"')
    end,
  })
end

-- Disable builtins plugins
local disabled_built_ins = {
  'gzip',
  'zip',
  'zipPlugin',
  'tar',
  'tarPlugin',
  'getscript',
  'getscriptPlugin',
  'vimball',
  'vimballPlugin',
  '2html_plugin',
  'logipat',
  'shada_plugin',
  'spellfile_plugin',
  'rrhelper',
}

for _, plugin in pairs(disabled_built_ins) do
  vim.g['loaded_' .. plugin] = 1
end

-- Black background
vim.opt.background = 'dark'
vim.cmd 'highlight Normal guibg=#0c0c0c'
vim.cmd 'highlight NormalNC guibg=#0c0c0c'
vim.cmd 'highlight SignColumn guibg=#0c0c0c'
vim.cmd 'highlight LineNr guibg=#0c0c0c'

-- Disable remote providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- Set blending options
vim.opt.winblend = 0
vim.opt.pumblend = 0

-- Set line numbering
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable undofile to persist undo history across sessions
vim.o.undofile = true
vim.o.undodir = vim.fn.stdpath 'config' .. '/undo'

if vim.o.undofile then
  vim.fn.mkdir(vim.o.undodir, 'p')
end

vim.opt.winborder = 'single'

-- Incremental line numbering in insert mode
vim.api.nvim_create_autocmd({ 'InsertEnter', 'InsertLeave' }, {
  callback = function()
    vim.wo.relativenumber = vim.fn.mode() ~= 'i'
  end,
})

-- Netrw config
vim.g.netrw_bufsettings = 'noma nomod nu nobl nowrap ro'
vim.g.netrw_sort_by = 'name'
vim.g.netrw_show_hidden = 1
vim.g.netrw_banner = 1
vim.g.netrw_liststyle = 3

-- Keymaps
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- NETRW
map('n', '\\', ':Ex<CR>', opts)

-- Resize windows
map('n', '<C-M-h>', ':vertical resize -2<CR>', opts)
map('n', '<C-M-l>', ':vertical resize +2<CR>', opts)
map('n', '<C-M-k>', ':resize -2<CR>', opts)
map('n', '<C-M-j>', ':resize +2<CR>', opts)

-- Buffers
map('n', '[b', ':bprevious<CR>', opts)
map('n', ']b', ':bnext<CR>', opts)
map('n', '<Leader>bd', ':bd<CR>', opts)
map('n', '<Leader>bD', ':bp | bd #<CR>', opts)

-- Go to previous and next tag
map('n', '[t', ':tselect<CR>', opts)
map('n', ']t', ':tag<CR>', opts)

-- Copy buffer path
map('n', '<leader>yd', ':let @+ = expand("%:p:h")<CR>', { desc = 'Copy file directory' })

-- Go to mark
map('n', 'gm', '`', opts)

-- Diagnostics toggle and filters
vim.diagnostic.config { virtual_text = false }

-- toggle diagnostics
map('n', '<leader>tdd', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = 'Toggle all diagnostics' })

map('n', '<leader>tdt', function()
  local current = vim.diagnostic.config().virtual_text
  vim.diagnostic.config { virtual_text = not current }
end, { desc = 'Toggle diagnostic virtual text' })

map('n', '<leader>tdw', function()
  vim.diagnostic.config {
    virtual_text = { severity = vim.diagnostic.severity.ERROR },
    signs = { severity = vim.diagnostic.severity.ERROR },
    underline = { severity = vim.diagnostic.severity.ERROR },
  }
end, { desc = 'Show only errors, hide warnings/info' })

-- Move lines up and down
map('v', 'J', ":m '>+1<CR>gv=gv", opts)
map('v', 'K', ":m '<-2<CR>gv=gv", opts)

-- Yank current directory
map('n', 'yd', ':lua vim.fn.setreg("+", vim.fn.expand("%:p:h"))<CR>', opts)

-- Jump to last position when reopening a file
vim.cmd [[
  if has("autocmd")
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") |
      \ exe "normal! g'\"" | endif
  endif
]]

-- Open netrw explorer
-- map('n', '<leader>e', ':Explore .<CR>', opts)

-- Hover LSP info
map('n', 'gh', ':lua vim.lsp.buf.hover()<CR>', opts)

-- User commands
vim.api.nvim_create_user_command('Trim', function()
  vim.cmd [[%s/\s\+$//e]]
end, {})

-- Term toggle
map('n', '<Leader>\\', ':FloatermToggle<CR>', opts)

-- Bind q to close quick buffers
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'man', 'help', 'git', 'fugitiveblame', 'qf' },
  callback = function()
    local ft = vim.bo.filetype
    if ft == 'qf' and vim.fn.getloclist(0, { title = 1 }).title:find 'Diagnostics' then
      map('n', 'q', '<cmd>lclose<CR>', { buffer = true })
    else
      map('n', 'q', '<cmd>close<CR>', { buffer = true })
    end
  end,
})

-- Disable separators for all themes
-- vim.api.nvim_create_autocmd('ColorScheme', {
--   pattern = '*',
--   callback = function()
--     vim.opt.fillchars:append {
--       vert = ' ',
--       horiz = ' ',
--       horizup = ' ',
--       horizdown = ' ',
--     }
--     vim.api.nvim_set_hl(0, 'WinSeparator', { fg = 'none', bg = 'none' })
--   end,
-- })

-- vim.o.background = 'dark'

vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#0f0f0f' })
    vim.api.nvim_set_hl(0, 'FloatBorder', { fg = '#2a2a2a' })
  end,
})

vim.cmd.colorscheme 'lunaperche'
