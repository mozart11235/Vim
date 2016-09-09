" Vim default
set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin
" End Vim default

" Set Color Scheme
colorscheme ir_black
" no backup files
set nobackup
" only in case you don't want a backup file while editing
set nowritebackup
" no swap files
set noswapfile
" highlight current line
set cursorline
" highlight bg color of current line
hi cursorline guibg=#333333
" highlight cursor
hi CursorColumn guibg=#333333
" Set font
set gfn=Droid_Sans_Mono:h10:cANSI
" End Set font

" Need to add comments
set autoread
set ignorecase
set tabstop=4 shiftwidth=4 expandtab
" Makes every buffer open in a new tab rather than the same tab
":au BufAdd,BufNewFile * nested tab sball

" show tag preview in a new window"
"nnoremap <C-]> <Esc>:exe "ptjump " . expand("<cword>")<Esc>

" ctags path, needs to be fixed, this isnt correct right now
let g:ctags_path= "C:\Programs\GNU"
"let g:tagbar_ctags_bin= "C:\\Programs\\GNU"

" Toggle Taglist Plugin
":nmap <F3> :TlistToggle<cr>

" Toggle TagBar Plugin
nmap <F3> :TagbarToggle<CR>

" Maximize GUI Version on startup
if has("gui_running")
  " GUI is running or is about to start.
  " Maximize gvim window.
  set lines=99999 columns=99999
else
  " This is console Vim.
  if exists("+lines")
    set lines=50
  endif
  if exists("+columns")
    set columns=100
  endif
endif
" End Maximize GUI Version on startup

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => MISC
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => MyDIFF
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set diffexpr=MyDiff()
function MyDiff()
   let opt = '-a --binary '
   if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
   if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
   let arg1 = v:fname_in
   if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
   let arg2 = v:fname_new
   if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
   let arg3 = v:fname_out
   if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
   if $VIMRUNTIME =~ ' '
     if &sh =~ '\<cmd'
       if empty(&shellxquote)
         let l:shxq_sav = ''
         set shellxquote&
       endif
       let cmd = '"' . $VIMRUNTIME . '\diff"'
     else
       let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
     endif
   else
     let cmd = $VIMRUNTIME . '\diff'
   endif
   silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
   if exists('l:shxq_sav')
     let &shellxquote=l:shxq_sav
   endif
 endfunction
 """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => End MyDIFF
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" CTRL-T opens a new tab, CTRL-W closes tab, CTRL-Left/Right switches tabs
"noremap   <C-T> :tabnew<return>
noremap   <C-Left> :bprevious<return>
noremap   <C-Right> :bnext<return>
nnoremap  <C-Delete> :bd<CR>

nnoremap   <C-V> "+p

"// not convinced yet
"autocmd BufReadPost * tab ball
"
"
"StausLine
"set laststatus=2
"set statusline=[LINE=%04l,COLUMN=%04v][%p%%]\ %=F%m%r%h%w%<\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [LEN=%L]

"au InsertEnter * hi StatusLine term=reverse ctermbg=5 gui=italic guisp=Cyan
"au InsertLeave * hi StatusLine term=reverse ctermfg=0 ctermbg=2 gui=bold,reverse
"
function! InsertStatuslineColor(mode)
  if a:mode == 'i'
    hi statusline guibg=white guifg=black
  elseif a:mode == 'r'
    hi statusline guibg=blue guifg=black
  else
    hi statusline guibg=red guifg=black
  endif
endfunction

"au InsertEnter * call InsertStatuslineColor(v:insertmode)
"au InsertChange * call InsertStatuslineColor(v:insertmode)
"au InsertLeave * hi statusline guibg=cyan guifg=black
" default the statusline to green when entering Vim
"hi statusline guibg=cyan guifg=black

"set statusline+=\ %{g:matchnum}\ matches
"
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

"Delete trailing whitespaces
autocmd FileType h,c,cpp,java,php autocmd BufWritePre <buffer> :%s/\s\+$//e

" Enabled NERDTree
"autocmd vimenter * NERDTree
nnoremap <F4> :NERDTreeToggle<CR>

" Enabled Airline by default
let g:airline#extensions#tabline#enabled = 1

"the below line shows complete path, 
"let g:airline#extensions#tabline#fnamemod = ':p'

"the below line shows just filename, 
let g:airline#extensions#tabline#fnamemod = ':t'

" Buffer management
:nnoremap <F5> :buffers<CR>:buffer<Space>

" Dirdiff tools
let g:DirDiffExcludes = "CVS,*.class,*.o,*.log,*.evt,*.dbb,*.metadata,*.prf,*.trc,*.err,*.rec,*.wrn"
" Ignore whitespace error
 let g:DirDiffAddArgs = "-w"

 function GuiTabLabel()
	  let label = ''
	  let bufnrlist = tabpagebuflist(v:lnum)

	  " Add '+' if one of the buffers in the tab page is modified
	  for bufnr in bufnrlist
	    if getbufvar(bufnr, "&modified")
	      let label = '+'
	      break
	    endif
	  endfor

	  " Append the number of windows in the tab page if more than one
	  let wincount = tabpagewinnr(v:lnum, '$')
	  if wincount > 1
	    let label .= wincount
	  endif
	  if label != ''
	    let label .= ' '
	  endif

	  " Append the buffer name
	  return label . bufname(bufnrlist[tabpagewinnr(v:lnum) - 1])
	endfunction

	set guitablabel=%{GuiTabLabel()}
"set guitablabel=%N\ %f
set nofoldenable    " disable folding

"nnoremap <Tab> :bnext<CR>
"nnoremap <S-Tab> :bprevious<CR>
"
"
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0

