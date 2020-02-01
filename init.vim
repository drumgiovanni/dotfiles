" バックスペース有効化
set backspace=indent,eol,start
" インデント
set autoindent
set smartindent
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
" ファイルタイプに応じたインデント設定
augroup Indent
  autocmd!
  autocmd BufNewFile, BufRead *.js setlocal tabstop=2 shiftwidth=2 softtabstop=2
  autocmd BufNewFile, BufRead *.ts setlocal tabstop=2 shiftwidth=2 softtabstop=2
  autocmd BufNewFile, BufRead *.vue setlocal tabstop=2 shiftwidth=2 softtabstop=2
  autocmd BufNewFile, BufRead *.py setlocal tabstop=4 shiftwidth=4 softtabstop=4
augroup END

" 入力コマンド表示
set showcmd
" 現在地表示
set ruler
" 検索
set incsearch
set hlsearch
set ignorecase
set smartcase
set wrapscan
nmap <ESC><ESC> :nohlsearch<CR><ESC>
" シンタックスハイライトをオン
syntax on
" ファイルタイプ検出
filetype plugin indent on
" マウス利用
set mouse=a
" ファイル読み込み時エンコーディング
set fileencodings=utf-8,cp932
" スワップ作成しない
set noswapfile
" 保存しなくてもバッファ移動可能になる
set hidden
" クリップボードレジスタ連結(xclip要インストール)
set clipboard+=unnamedplus
" 相対的行数表示
set relativenumber
" 空白可視化
set list
" カーソル移動を見たままの感じにする
nnoremap j gj
nnoremap k gk
set whichwrap=b,s,<,>,[,],~
" 文字ズレ防止
set ambiwidth=double
" jjでESCする
imap jj <ESC>
" IME設定
if has('multi_byte_ime')
  set iminsert=0 imsearch=0
endif
" python3の場所
let g:python3_host_prog = '/usr/bin/python3'
" バッファ作成
nnoremap <C-n> <ESC>:enew<CR>
" タブ作成
nnoremap <C-t> <ESC>:tabnew<CR>
" 保存
nnoremap <C-s> <ESC>:w<CR>
" ファイル閉じ
nnoremap <C-w> <ESC>:wq<CR>

"-----------------------------------
" plugin関連の設定（vim-plug）を利用
"-----------------------------------
call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'ryanoasis/vim-devicons', { 'on':  'NERDTreeToggle' }
Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/neoyank.vim'
Plug 'Shougo/neomru.vim'
Plug 'raghur/fruzzy'
Plug 'joshdick/onedark.vim'
Plug 'sheerun/vim-polyglot'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'mattn/vim-lsp-settings'
Plug 'Townk/vim-autoclose'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()
"--------------
"plugin個別設定
"--------------
" ■NerdTree
" キーマッピング
nnoremap <C-f> :NERDTreeToggle<CR>
" NERDTree以外のバッファが閉じられた際にvimを閉じる
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"
" ■denite.nvim
" Define mappings
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
  \ denite#do_map('toggle_select').'j'
endfunction

autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
  imap <silent><buffer> <C-o> <Plug>(denite_filter_quit)
endfunction
" For ripgrep
call denite#custom#var('file/rec', 'command',
\ ['rg', '--files', '--glob', '!.git'])
" Ripgrep command on grep source
call denite#custom#var('grep', 'command', ['rg'])
call denite#custom#var('grep', 'default_opts',
    \ ['-i', '--vimgrep', '--no-heading'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

call denite#custom#source('file/old', 'matchers',
      \ ['matcher/fruzzy', 'matcher/project_files'])
call denite#custom#source('tag', 'matchers', ['matcher/substring'])
call denite#custom#source('file/rec', 'matchers',
      \ ['matcher/fruzzy'])
call denite#custom#source('file/old,ghq', 'converters',
      \ ['converter/relative_word', 'converter/relative_abbr'])

call denite#custom#alias('source', 'file/rec/git', 'file/rec')
call denite#custom#var('file/rec/git', 'command',
      \ ['git', 'ls-files', '-co', '--exclude-standard'])
call denite#custom#option('default', {
      \ 'highlight_filter_background': 'CursorLine',
      \ 'source_names': 'short',
      \ 'split': 'floating',
      \ 'filter_split_direction': 'floating',
      \ })
call denite#custom#option('search', {
      \ 'highlight_filter_background': 'CursorLine',
      \ 'source_names': 'short',
      \ 'filter_split_direction': 'floating',
      \ })
nnoremap <silent> <C-d><C-f> :<C-u>Denite file/rec<CR>
nnoremap <silent> <C-d><C-b> :<C-u>Denite buffer<CR>
nnoremap <silent> <C-d><C-d> :<C-u>Denite grep<CR>
nnoremap <silent> <C-d><C-l> :<C-u>Denite line<CR>
nnoremap <silent> <C-d><C-u> :<C-u>Denite file_mru<CR>
nnoremap <silent> <C-d><C-y> :<C-u>Denite neoyank<CR>

"asyncomplete.vim
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"
set completeopt+=preview

" vim-airline
let g:airline_theme='badwolf'
let g:airline#extentions#tabline#enabled = 1

command DiffOrig vert new | set bt=nofile | r ++edit " | 0d_ | diffthis
  \ | wincmd p | diffthis

