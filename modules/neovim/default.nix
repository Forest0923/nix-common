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
      vimPlugins.render-markdown-nvim
      vimPlugins.transparent-nvim
      vimPlugins.vim-lsp
      vimPlugins.vim-lsp-settings
    ];
    extraConfig = ''
      syntax enable
      filetype plugin indent on

      language C
      set fenc=utf-8
      set encoding=utf-8
      set nobackup
      set noswapfile
      set autoread
      set hidden
      set showcmd
      set belloff=all
      set clipboard=unnamedplus
      set mouse=a
      set wildmode=longest,list,full
      " remove trailing whitespace
      autocmd BufWritePre * %s/\s\+$//e
      " jump to last edit position when opening files
      autocmd BufReadPost *
           \ if line("'\"") > 0 && line("'\"") <= line("$") |
           \   exe "normal! g`\"" |
           \ endif
      lang en_US.UTF-8

      " line
      set number
      set cursorline
      set virtualedit=onemore
      set showmatch

      " Status Line
      set statusline=%F
      set statusline+=%m
      set statusline+=%h
      set statusline+=%=
      set statusline+=\ %Y[%{&fileencoding}]
      set statusline+=[%l/%L(%p%%)]
      set laststatus=2

      " Indent, Tab
      set noexpandtab
      set tabstop=8
      set shiftwidth=8
      set smarttab
      set smartindent
      if has ("autocmd")
              filetype plugin on
              autocmd FileType nix setlocal tabstop=2 shiftwidth=2 expandtab
              autocmd FileType rust setlocal tabstop=4 shiftwidth=4 expandtab
              autocmd FileType python setlocal tabstop=4 shiftwidth=4 expandtab
              autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 expandtab
              autocmd BufRead,BufNewFile *.v setfiletype verilog
      endif
      set backspace=indent,eol,start

      " Search
      set ignorecase
      set smartcase
      set incsearch
      set wrapscan
      set hlsearch

      " scroll
      set scrolloff=8

      " colorscheme
      colorscheme vim

      " transparent-nvim
      lua << EOF
      require("transparent").setup({
        -- :help highlight-groups
        exclude_groups = { "LineNr", "StatusLine" },
      })
      EOF
    '';
  };
}
