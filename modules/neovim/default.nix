{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    plugins = with pkgs; [
      vimPlugins.copilot-vim
      vimPlugins.hlchunk-nvim
      vimPlugins.lexima-vim
      vimPlugins.mini-comment
      vimPlugins.mkdir-nvim
      vimPlugins.numb-nvim
      vimPlugins.nvim_context_vt
      vimPlugins.transparent-nvim
      vimPlugins.nvim-lspconfig
      vimPlugins.nvim-cmp
      vimPlugins.cmp-nvim-lsp
    ];

    extraLuaConfig = ''
      -- basic settings
      local o = vim.opt
      o.fileencoding = 'utf-8'
      vim.o.encoding = 'utf-8'
      o.backup = false
      o.swapfile = false
      o.autoread = true
      o.hidden = true
      o.showcmd = true
      o.clipboard = 'unnamedplus'
      o.mouse = 'a'
      o.wildmode = 'longest,list,full'
      vim.opt.belloff = 'all'

      -- line
      o.number = true
      o.cursorline = true
      o.virtualedit = 'onemore'
      o.showmatch = true
      vim.o.statusline = table.concat({
        '%F','%m','%h','%=',' %Y[%{&fileencoding}]','[%l/%L(%p%%)]'
      })
      o.laststatus = 2

      -- indent/tab
      o.expandtab = false
      o.tabstop = 8
      o.shiftwidth = 8
      o.smarttab = true
      o.smartindent = true
      o.backspace = { 'indent', 'eol', 'start' }

      -- search
      o.ignorecase = true
      o.smartcase = true
      o.incsearch = true
      o.wrapscan = true
      o.hlsearch = true

      -- scroll
      o.scrolloff = 8

      -- filetype
      vim.cmd('syntax enable')
      vim.cmd('filetype plugin indent on')
      vim.cmd('language C')

      -- trim whitespace on save
      local trim = vim.api.nvim_create_augroup('TrimWS', { clear = true })
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = trim,
        pattern = '*',
        command = [[%s/\s\+$//e]],
      })

      -- jump to last edit position
      vim.api.nvim_create_autocmd('BufReadPost', {
        pattern = '*',
        callback = function()
          local last = vim.fn.line([['"]])
          if last > 0 and last <= vim.fn.line('$') then
            vim.cmd([[normal! g`"]])
          end
        end,
      })

      -- filetype specific settings
      vim.api.nvim_create_autocmd('FileType', { pattern = 'nix',        command = 'setlocal tabstop=2 shiftwidth=2 expandtab' })
      vim.api.nvim_create_autocmd('FileType', { pattern = 'rust',       command = 'setlocal tabstop=4 shiftwidth=4 expandtab' })
      vim.api.nvim_create_autocmd('FileType', { pattern = 'python',     command = 'setlocal tabstop=4 shiftwidth=4 expandtab' })
      vim.api.nvim_create_autocmd('FileType', { pattern = 'javascript', command = 'setlocal tabstop=2 shiftwidth=2 expandtab' })
      vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, { pattern = '*.v', command = 'setfiletype verilog' })

      -- color
      vim.cmd('colorscheme vim')

      -- transparent-nvim
      -- :help highlight-groups
      require('transparent').setup({
        exclude_groups = { 'LineNr', 'StatusLine' },
      })

      -- locale
      vim.cmd('language en_US.UTF-8')

      -- LSP
      local caps_ok, cmp_caps = pcall(require, 'cmp_nvim_lsp')
      local caps = caps_ok and cmp_caps.default_capabilities() or nil

      vim.lsp.config('*', { capabilities = caps })

      for _, name in ipairs{
        'bashls','gopls','jsonls','lua_ls','nil_ls','pyright','rust_analyzer','yamlls'
      } do vim.lsp.enable(name) end

      local ok_cmp, cmp = pcall(require, 'cmp')
      if ok_cmp then
        cmp.setup({
          mapping = {
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<Tab>'] = cmp.mapping.select_next_item(),
            ['<S-Tab>'] = cmp.mapping.select_prev_item(),
          },
          sources = { { name = 'nvim_lsp' } },
        })
      end

      local function lsp_on_attach(buf)
        local map = function(mode, lhs, rhs) vim.keymap.set(mode, lhs, rhs, {buffer=buf}) end
        map('n','K', vim.lsp.buf.hover)
        map('n','gd', vim.lsp.buf.definition)
        map('n','gr', vim.lsp.buf.references)
        map('n','gi', vim.lsp.buf.implementation)
        map('n','<leader>rn', vim.lsp.buf.rename)
        map('n','<leader>ca', vim.lsp.buf.code_action)
        map('n','<leader>f', function() vim.lsp.buf.format({async=true}) end)
      end

      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        severity_sort = true,
      })

      local caps_ok, cmp_caps = pcall(require, 'cmp_nvim_lsp')
      local caps = caps_ok and cmp_caps.default_capabilities() or nil
      vim.lsp.config('*', { capabilities = caps, on_attach = function(client, buf) lsp_on_attach(buf) end })
    '';
  };
  home.packages = with pkgs; [
    bash-language-server
    gopls
    java-language-server
    lua-language-server
    nil
    pyright
    rust-analyzer
    vscode-json-languageserver
    yaml-language-server
  ];
}
