" ==========================================
" 1. 基础设置 (Basic Settings)
" ==========================================
" 关闭兼容模式
set nocompatible
" Neovim 自动识别
set fileencodings=utf-8,gbk,utf-16,cp936
" 开启语法高亮
syntax on

" 禁止启动画面
set shortmess+=I

" 显示行号和标尺
set number
set ruler

" 总是显示状态栏
set laststatus=2

" 优化退格键行为
set backspace=indent,eol,start

" 允许隐藏未保存的 buffer
set hidden

" 搜索设置 (忽略大小写，除非包含大写)
set ignorecase
set smartcase
set incsearch

" 关闭烦人的提示音
set noerrorbells visualbell t_vb=

" 开启鼠标支持
set mouse+=a

" 剪贴板共享 (需要系统支持，Termux 需要 termux-api)
set clipboard=unnamedplus

" Tab 和缩进设置 (4个空格)
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent

" 高亮当前行
set cursorline
" 设置行号颜色
highlight LineNr ctermfg=gray

" 窗口分割时，新窗口在右侧
set splitright

" ==========================================
" 2. 插件管理 (Plugins)
" ==========================================
" 统一将插件安装在 ~/.vim/plugged 下，方便管理
call plug#begin('~/.vim/plugged')

" --- 界面美化 ---
Plug 'vim-airline/vim-airline'       " 状态栏
Plug 'jiangmiao/auto-pairs'          " 括号自动补全

" --- 文件树 ---
" 使用官方维护的最新版 NERDTree
Plug 'preservim/nerdtree'

" --- Neovim 专属插件 (仅在 nvim 下加载) ---
if has('nvim')
    " 语法高亮引擎
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    " LSP 基础配置 (C语言补全)
    Plug 'neovim/nvim-lspconfig', { 'tag': 'v2.1.0' }
endif

call plug#end()

" ==========================================
" 3. 快捷键映射 (Key Mappings)
" ==========================================
" 禁用 Q 进入 Ex 模式
nmap Q <Nop>


" Ctrl+n 打开/关闭 NERDTree
map <C-n> :NERDTreeToggle<CR>

" Tab 切换 Buffer
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprev<CR>

" ==========================================
" 4. 插件详细配置
" ==========================================
" Airline 设置
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" ==========================================
" 5. Lua 配置 (Treesitter & LSP)
" ==========================================
if has('nvim')
lua << EOF
  -------------------------------------------------
  -- 防崩溃保护：如果插件没装好，不执行下面的代码
  -------------------------------------------------
  local status_ts, ts_configs = pcall(require, "nvim-treesitter.configs")
  if not status_ts then
      -- 如果 Treesitter 没加载，直接静默退出 Lua 块，防止报错
      return
  end

  local status_lsp, lspconfig = pcall(require, "lspconfig")

  -------------------------------------------------
  -- 1. 配置 Treesitter
  -------------------------------------------------
  ts_configs.setup {
    -- 确保安装 C/C++ 等解析器
    ensure_installed = { "c", "cpp", "python", "bash", "lua", "vim", "vimdoc" },

    highlight = {
      enable = true,              -- 启用高亮
      additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = true               -- 启用缩进
    }
  }

  -------------------------------------------------
  -- 2. 配置 LSP (Clangd)
  -------------------------------------------------
  if status_lsp then
      -- 启动 C 语言服务 (前提：系统安装了 clangd)
      lspconfig.clangd.setup{}
  end
EOF
endif