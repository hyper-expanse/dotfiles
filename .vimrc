"====================================================
" VIM Configuration
"
" This script provides useful VIM configuration settings.
"====================================================

"====================================================
" General Features
"
" These options enable several useful baseline features for improving Vim functionality.
"====================================================

" Set how many lines of history Vim must remember.
set history=1000

" Set to automatically check and read a file that has changed from the outside of this Vim instance.
set autoread

" Set 'nocompatible' to prevent backwards compatibility with Vi, thereby enabling features specific to Vim.
set nocompatible

" Disable filetype detection as per Vundle's requirements.
filetype off

" Enabled filetype plugins based on the version of Vim used.
if version >= 600
	filetype plugin on " Enable filetype for the inclusion of plugins that are file type specific.
	filetype indent on " Enable filetype plugins that allow intelligent auto-indenting based on file type.
endif

" Use Unix as the standard file type when saving a buffer back to file. This will cause Unix line terminators, \n, to be used for deliminating a file's newlines.
set fileformat=unix

" Check for built-in support for multi-byte character sets such as UTF-8.
if has('multi_byte')
	" If our keyboard encoding is not set, store the current file encoding value within the keyboard terminal variable.
	if &termencoding == ""
		let &termencoding=&encoding
	endif

	set encoding=utf-8 " Set the default encoding for how Vim represents characters internally.
	setglobal fileencoding=utf-8 " Set the encoding for a particular file (local to the buffer).
	set fileencodings=ucs-bom,utf-8,latin1 " Set the sequence of encodings to be used as a heuristic when reading an existing file. The first encoding that matches will be used.
endif

" Set Bash as the default shell to be used when executing commands within a shell.
set shell=/bin/bash

" Configure Vim to remember certain information between instances.
" '10 : Marks will be remembered for up to 10 previously edited files.
" "100 : Save up to 100 lines for each register.
" :20 : Save up to 20 lines of command-line history.
" % : Save and restore the buffer list.
" n... : Location to save the viminfo files.
set viminfo='10,\"100,:20,%,n~/.vim/viminfo

" Disable modeline support within Vim. Modeline support within Vim has constantly introduced security vulnerabilities into the Vim editor. By disabling this feature any chance of a future vulnerability interfering with the use of Vim, or the operating system on which it runs, is mitigated. As for functionality, modelines are configuration lines contained within text files that instruct Vim how to behave when reading those files into a buffer.
set nomodeline " Turn off modeline parsing altogether.
set modelines=0 " Set the number of modelines Vim parses, when reading a file, to zero.

" Indicate to Vim that we have a fast terminal connection. This instructs Vim to send more characters to the screen for re-drawing rather than using insert/delete commands.
set ttyfast

" Set printing options such as syntax and the output paper size.
set printoptions=paper:A4,syntax:y

" Allow the terminal cursor to move freely, even past the end of a line. BAD IDEA.
"set virtualedit=all

" Location to store Vim temporary files.
set directory=~/.vim/temp

" Set the default language to use for spell checking.
setlocal spelllang=en_us

" \todo
function! EnsureDirExists(dir)
	if !isdirectory(a:dir)
		if exists('*mkdir')
			call mkdir(a:dir,'p')
			echo "Created directory: " . a:dir
		else
			echo "Please create directory: " . a:dir
		endif
	endif
endfunction

"====================================================
" User Interface
"
" These options alter the graphical layout and visual color of the interface, and alter how file contents are rendered.
"====================================================

" Enable syntax highlighting.
syntax on

" Enable better command-line completion.
set wildmenu " Enables a menu at the bottom of the window.
set wildmode=list:longest,full " Allows the completion of commands on the command line via the tab button.

" Ignore certain backup and compiled files based on file extensions when using tab completion.
set wildignore=*.swp,*.bak,*.tmp,*~
set wildignore+=*.zip,*.7z,*.gzip,*.gz
set wildignore+=*.jpg,*.png,*.gif,*.avi,*.mov,*.mpeg

" Show partial commands in the last line of the screen.
set showcmd

" Try not to split words across multiple lines when a line wraps.
set linebreak

" Highlight search results.
set hlsearch

" Make search behave like search in modern browsers by initiating a partial search while typing in a search pattern, thereby finding the first occurrence of the search pattern as a sub-string within the file content.
set incsearch

" Use case insensitive search, except when using capital letters.
set ignorecase " Case insensitive search.
set smartcase " Enable case-sensitive search when the search phrase contains capital letters.

" Allow backspacing over autoindent, line breaks, and start of insert action.
set backspace=indent,eol,start

" Allows moving left when at the beginning of a line, or right when at the end of the line. When the end of the line has been reached, the cursor will progress to the next line, either up or down, depending on the direction of movement. < and > are left and right arrow keys, respectively, in normal and visual modes, and [ and ] are arrow keys, respectively, in insert mode.
set whichwrap+=<,>,h,l,[,]

" Stop certain movements from always going to the first character of a line. While this behaviour deviates from that of Vi, it does what most users coming from other editors would expect.
set nostartofline

" Display the cursor position on the last line of the screen or in the status line of a window and set the ruler display format.
set ruler
set rulerformat=%40(%t%y:\ %l,%c%V\ \(%o\)\ %p%%%)

" Instead of failing a command because of unsaved changes raise a dialogue asking if you wish to save changed files.
set confirm

" Enable use of the mouse for all Vim modes: Normal, Insert, Visual, and Command-line.
set mouse=a

" Set the command window height to 2 lines, to avoid many cases of having to 'press <Enter> to continue'.
set cmdheight=2

" Display line numbers on the left with a column width of 4.
set number
set numberwidth=4

" Quickly time out on keycodes, but never time out on mappings.
set notimeout ttimeout ttimeoutlen=200

" A buffer becomes hidden, not destroyed, when it's abandoned.
set hidden

" Don't redraw while executing macros, thereby improving performance.
set lazyredraw

" Turn on the 'magic' behaviour thereby enabling regular expressions.
set magic

" Show matching brackets when text indicator is over them.
set showmatch

" Specify how many tenths of a second to blink when matching brackets.
set mat=2

" Disable error bells.
set noerrorbells
set novisualbell

" Set default values for a GVim instance, the GUI version if Vim.
if has('gui_running')
	set columns=120 " Width of GVim window.
	set lines=40 " Height of GVim window.

	" Disable all GUI toolbars so that only a simple window frame containing the Vim instance is shown.
	set browsedir=buffer
	set guioptions-=M
	set guioptions-=m
	set guioptions-=T

	" Inform Vim to expect a light GUI background. This will cause Vim to compensate by altering the colorcsheme.
	set background=light

	" Set GUI font options based on the operating system.
	if has('win32') || has ('win64')
		set guifont=Monospace\ 10
	elseif has('unix')
		set guifont=DejaVu\ Sans\ Mono\ 10
	elseif has('vms')
		set guifont=-adobe-courier-medium-r-normal--14-100-100-100-m-90-iso8859-1
	endif
else
	" Set a default color scheme.
	colorscheme default

	" Inform Vim to expect a dark terminal background. This will cause Vim to compensate by altering the colorscheme.
	set background=dark
endif

" Start scrolling when we're 3 lines from the bottom of the current window.
set scrolloff=3

" Disable the highlighting of the column on which the cursor currently resides. When enabled, this feature is useful for the purpose of aligning text, but it's a performance hindrance.
set nocursorcolumn

" Disable the highlighting of the line, row, on which the cursor currently resides. When enabled, this feature is only useful for quickly determining the line on which the cursor resides in a large body of text.
set nocursorline

" Set the minimum number of lines to search around the cursor's position to derive the appropriate syntax highlighting.
syntax sync minlines=256

" Instruct Vim to offer corrections in a pop-up on right-click of the mouse.
set mousemodel=popup

" Do not display line numbers when viewing a help file.
autocmd FileType helpfile set nonumber

"====================================================
" Doxygen
"
" These options manage settings associated with Vim's built-in support for Doxygen.
"====================================================

" Autoload Doxygen highlighting. This allows Vim to understand special documentation syntax, such as '\param' so that the built-in spell checker does not give a false positive.
if version >=700
	let g:load_doxygen_syntax=1
endif

"====================================================
" Backups
"
" These options manage settings associated with how backups are handled by Vim.
"====================================================

" Turn off backups for files that are being edited by Vim.
set nobackup " Do not keep a backup of a file after overwriting the file.
set nowritebackup " Do not automatically create a write backup before overwriting a file.
set noswapfile " No temporary swap files.

" Set the default location to store backup files.
set backupdir=~/.vim/backups

" The backup directory, used to store copies of files before they're modified, must exist for backup files to be created. If it does not exist backup files will not get created.
call EnsureDirExists($HOME . '/.vim/backups')

"====================================================
" Undo
"
" These options manage settings associated with how undo history is retained by Vim.
"====================================================

" If the option is available, turn on persistent undo history. This causes all changes to a file to be written to a cache file in the specified undodir directory. This undo history can then be loaded back again by Vim the next time the file is opened.
if has('persistent_undo')
	" Set the directory to use for storing undo cache files.
	set undodir=~/.vim/undo

	" The undo directory, used to store undo cache files, must exist for undo cache files to be created. If it does not exist undo cache files will not get created.
	call EnsureDirExists($HOME . '/.vim/undo')

	" Turn on persistent undo history.
	set undofile

	" Set the maximum number of undos that should be kept in history.
	set undolevels=1000

	" Set the maximum number of lines to save for undo on a buffer reload. Allows the current contents of a buffer to be saved when reloading the buffer so that the buffer reload can be undone.
	set undoreload=10000
endif

"====================================================
" Tabs and Indents
"
" These options manage settings associated with tabs and automatically indenting new lines.
"====================================================

" When opening a new line and no filetype-specific indenting is enabled, keep the same indent as the line you're currently on.
set autoindent
"set cindent "< Probably should not use 'smartindent', a.k.a. 'cindent', with filetype indent feature enabled. Should only be set manually, enabled, when filetype-based indention is not adequate. 'cindent' is only appropriate for c-style languages.

" Set width of a tab in terms of columns.
set tabstop=4

" Set indents width in terms of columns.
set shiftwidth=4

" Instruct the backspace key to treat this number of spaces as a tab. This allows for a single backspace to go back this many white space characters.
set softtabstop=4

" Enable smart use of tabs.
set smarttab

" Copy the structure of the existing lines indent when autoindenting a new line.
set copyindent

" Causes spaces to be inserted in place of tabs when the Tab key is pressed. To disable this behavior and enable the insertion of tabs when the Tab key is pressed, comment out this option.
"set expandtab

" Enable special display options to show tabs and end-of-line characters within a non-GUI window. Tabs are represented using '>-' and a sequence of '-'s that will fill out to match the proper width of a tab. End-of-line is represented by a dollar sign '$'. Displaying tabs as '>-' and end-of-lines as '$'. Trailing white space is represented by '~'. Must be toggled by a mapping to ':set list!'.
set listchars=tab:>-,eol:$,trail:~,extends:>,precedes:<

"====================================================
" Folding
"
" These options manage settings associated with folding portions of code into condensed forms, leaving only an outline of the code visible. Folding is a form of collapsing of function definitions, class definitions, sections, etc. When a portion of code is collapsed only a header associated with that section is left visible along with a line indicating statistics associated with the collapsed code; such as the number of collapsed lines, etc. The terms 'folded' and 'collapsed' within this file are used interchangeably with one another.
"====================================================

" Use syntax highlighting rules to determine how source code or content should be folded.
set foldmethod=syntax

"====================================================
" Difference Mode
"
" These options manage settings associated with Vim wile operating in difference mode, displaying differences between two similar files.
"====================================================

" Set the default difference display option such that filler lines are shown to keep text synchronized between two windows and use 6 lines of context between a change and a fold that contains unchanged lines.
set diffopt=filler,context:6

"====================================================
" Vim Explorer
"
" These options configure Vim's built-in file system explorer so that it behaves in a manner that meets user expectations. This includes showing files in a tree view so that entire projects can be seen at once.
"====================================================

" Will cause files selected in the Explorer window to be opened in the most recently used buffer window (Causing the previous buffer to be pushed into the background).
let g:netrw_browse_split=4

" Medium speed directory browsing by re-using directory listings only when using Explorer to browse remote directories.
let g:netrw_fastbrowse=1

" List files and directories in the Explorer window using the tree listing style.
let g:netrw_liststyle=3

" Place the file preview window in a horizontal split window. A file can be previewed by pressing 'P'.
let g:netrw_preview=0

"====================================================
" Status Line
"
" These options and commands manage settings associated with the status bar at the bottom of the Vim editor.
"====================================================

" Always display the status line, even if only one window is displayed.
set laststatus=2

" Format the status line.
set statusline=%F			" Full path of the file.
set statusline+=\ %m		" Display [+] if the current buffer has been modified.
set statusline+=\ %r		" Show [RO] for read-only files.
set statusline+=%=			" Right align the following status line text.
set statusline+=\ %{fugitive#statusline()}	" Fugitive plugin for pulling in Git repo information.
set statusline+=\ %y		" File type, such as [cpp] or [bash].
set statusline+=\ [%{strlen(&fenc)?&fenc:'none'}]	" File encoding, such as [utf-8] or [latin1].
set statusline+=\ [%{strlen(&ff)?&ff:'unknown'}]	" File format, such as [unix] or [dos].
set statusline+=\ [Column:\ %3v]	" Virtual column number that is independent of the total byte count of all characters up to that point. Padd with up to 3 invisible characters.
set statusline+=\ [Line:\ %4l\/%L]	" Current line number out of '%L' lines in the current buffer. Pass with up to 4 invisible characters.

"====================================================
" Helper Functions
"
" These functions help with various automation tasks and can be mapped to various key combinations or function keys.
"====================================================

" Commands to covert tabs to spaces and vice versa. - boveresch
command! -range=% -nargs=0 Tab2Space execute "<line1>,<line2>s/^\\t\\+/\\=substitute(submatch(0), '\\t', repeat(' ', ".&ts."), 'g')"
command! -range=% -nargs=0 Space2Tab execute "<line1>,<line2>s/^\\( \\{".&ts."\\}\\)\\+/\\=substitute(submatch(0), ' \\{".&ts."\\}', '\\t', 'g')"

" Define a function that will delete trailing white space on save.
function! DeleteTrailingWS()
	exe "normal mz"
	%s/\s\+$//ge
	exe "normal `z"
endfunc

" Create an autocmd that will be executed every time the buffer is written back to file, deleting trailing white space.
augroup deleteTrailingWS
	autocmd BufWrite * :call DeleteTrailingWS()
augroup END

" Return to the last edit position when re-opening a file.
autocmd BufReadPost *
	\ if line("'\"") > 0 && line("'\"") <= line("$") |
	\   exe "normal! g`\"" |
	\ endif

" Search and replace support.
function! VisualSelection(direction) range
	let l:saved_reg = @"
	execute "normal! vgvy"

	let l:pattern = escape(@", '\\/.*$^~[]')
	let l:pattern = substitute(l:pattern, "\n$", "", "")

	if a:direction == 'b'
		execute "normal ?" . l:pattern . "^M"
	elseif a:direction == 'gv'
		call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
	elseif a:direction == 'replace'
		call CmdLine("%s" . '/'. l:pattern . '/')
	elseif a:direction == 'f'
		execute "normal /" . l:pattern . "^M"
	endif

	let @/ = l:pattern
	let @" = l:saved_reg
endfunction

" Returns a status message indicating whether in paste mode, 'PASTE MODE', or not, ' '.
function! HasPaste()
	if &paste
		return 'PASTE MODE'
	endif

	return ''
endfunction

" Don't close this window when deleting a buffer.
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
	let l:currentBufNum = bufnr('%')
	let l:alternateBufNum = bufnr('#')

	if buflisted(l:alternateBufNum)
		buffer #
	else
		bnext
	endif

	if bufnr('%') == l:currentBufNum
		new
	endif

	if buflisted(l:currentBufNum)
		execute('bdelete! '.l:currentBufNum)
	endif
endfunction

" Mark the buffer in the current window for movement to a new window.
function! MarkWindowSwap()
	let g:markedWinNum = winnr()
endfunction

" Mark the current window as the destination of the previously selected buffer and begin the process of swapping buffers between the two windows.
function! DoWindowSwap()
	"Mark destination buffer.
	let curNum = winnr()
	let curBuf = bufnr('%')
	exe g:markedWinNum . "wincmd w"
	" Switch to our source buffer and shuffle destination->source.
	let markedBuf = bufnr("%")
	" Hide and open so that we aren't prompted and insure our history is kept.
	exe 'hide buf' curBuf
	" Switch to our destination buffer and shuffle source->destination.
	exe curNum . "wincmd w"
	" Hide and open so that we aren't prompted and insure our history is kept.
	exe 'hide buf' markedBuf
endfunction

" Autocmds to automatically enter hex mode and handle file writes properly.
augroup Binary
	au!

	" Set binary option for all binary files before reading them.
	au BufReadPre *.bin,*.hex,*.exe,*.tar setlocal binary

	" If on a fresh read the buffer variable is already set, it's wrong.
	au BufReadPost *
		\ if exists('b:editHex') && b:editHex |
		\   let b:editHex = 0 |
		\ endif

	" Convert to hex on startup for binary files automatically.
	au BufReadPost *
		\ if &binary | :call ToggleHex() | endif

	" When the text is freed the next time the buffer is made active it will re-read the text and thus not match the correct mode, we will need to convert it again if the buffer is again loaded.
	au BufUnload *
		\ if getbufvar(expand('<afile>'), 'editHex') == 1 |
		\   call setbufvar(expand('<afile>'), 'editHex', 0) |
		\ endif

	" Before writing a file when editing in hex mode, convert back to non-hex.
	au BufWritePre *
		\ if exists('b:editHex') && b:editHex && &binary |
		\  let oldro=&ro | let &ro=0 |
		\  let oldma=&ma | let &ma=1 |
		\  silent exe "%!xxd -r" |
		\  let &ma=oldma | let &ro=oldro |
		\  unlet oldma | unlet oldro |
		\ endif

	" After writing a binary file, if we're in hex mode, restore hex mode.
	au BufWritePost *
		\ if exists('b:editHex') && b:editHex && &binary |
		\  let oldro=&ro | let &ro=0 |
		\  let oldma=&ma | let &ma=1 |
		\  silent exe "%!xxd" |
		\  exe "set nomod" |
		\  let &ma=oldma | let &ro=oldro |
		\  unlet oldma | unlet oldro |
		\ endif
augroup END

" Toggles hex mode. Hex mode should be considered a read-only operation. Save values for modified and read-only for restoration later and clear the read-only flag for now.
function! ToggleHex()
	let l:modified=&mod
	let l:oldreadonly=&readonly
	let &readonly = 0
	let l:oldmodifiable=&modifiable
	let &modifiable=1

	if !exists('b:editHex') || !b:editHex

		" Save old options.
		let b:oldft=&ft
		let b:oldbin=&bin

		" Set new options.
		setlocal binary " Make sure it overrides any textwidth, etc.
		let &ft="xxd"

		" Set status.
		let b:editHex=1

		" Switch to hex editor.
		%!xxd
	else
		" Restore old options.
		let &ft=b:oldft

		if !b:oldbin
			setlocal nobinary
		endif

		" Set status.
		let b:editHex=0
		" Return to normal editing.
		%!xxd -r
	endif

	" Restore values for modified and read only state.
	let &mod=l:modified
	let &readonly=l:oldreadonly
	let &modifiable=l:oldmodifiable
endfunction

" Open the URI that is currently underneath the cursor in a browser.
function! Browser ()
	let line = getline('.')
	let line = matchstr(line, "http[^   ]*")

	" In Windows use Google Chrome.
	if has('win32')
		exec "!C:\Program Files (x86)\Google\Chrome\Application\chrome.exe --incognito ".line
	" In a Unix like environment use a text-based browser such as Elinks.
	elseif has('unix')
		exec "!elinks ".line
	endif
endfunction

" Retrieve the current work under the cursor.
function! GetWordUnderCursor()
	let s:wordUnderCursor = expand('<cword>')
	return s:wordUnderCursor
endfunction

" Swap SQL Join predicates.
function! SwapJoinPredicate()
	exec "s/\\v(ON|AND|OR)\\s+(.+)\\s*\\=\\s*(.+)$/\\1 \\3 = \\2/g"
endfunction

"====================================================
" Multi-Mode Mappings
"
" General options are define such that they are available within all operating modes. Also a collection of mappings usable within two or more modes are defined.
"====================================================

" Set a map leader so that extra key combinations can be used for quick operations.
let mapleader=","
let g:mapleader=","

" Manage spell check by supporting mappings that turn spell check on and off.
nnoremap <silent> <F7> <ESC>:setlocal spell!<CR>
" Placing the letter 'i' at the end causes Vim to then return to insert mode after toggling the spell checker.
inoremap <silent> <F7> <ESC>:setlocal spell!<CR>i
" Placing the letter 'v' at the end causes Vim to then return to visual mode after toggling the spell checker.
vnoremap <silent> <F7> <ESC>:setlocal spell!<CR>v

" Re-map screen-256color key sequences for [Alt,CTRL,SHIFT]+[ARROW KEYS] to the appropriate control keys. This accounts for the fact that these key sequences are not automatically handled by Vim when running Vim inside of a screen application such as tmux. Vim is notified that the terminal it is running inside of is a 'screen', or 'screen-256color' terminal by either tmux or screen terminal multiplexers.
if &term =~ '^screen'
	execute "set <xUp>=\e[1;*A"
	execute "set <xDown>=\e[1;*B"
	execute "set <xRight>=\e[1;*C"
	execute "set <xLeft>=\e[1;*D"

	" Enable extended mouse reporting mode while within a Screen or TMUX session. By enabling extended mouse reporting mode for Screen and TMUX sessions, mouse click-and-drag works on Vim splits as expected.
	" The ttymouse option changes what 'mouse codes' Vim will recognize. Setting this option to 'xterm2' is required when operating Vim within terminal multiplexers.
	" Must be one of: xterm, xterm2, netterm, dec, jsbterm, pterm
	set ttymouse=xterm2
endif

" Copy entire file contents to clipboard while in any mode.
map <C-Y> :%y+<CR>
map! <C-Y> :%y+<CR>

" Pressing CTRL-V pastes clipboard text at the cursor's location.
map <C-V> "+gP

" Start a browser instance loading the URI that is underneath the cursor.
nnoremap <silent> <C-U> <ESC>:call Browser()<CR>
inoremap <silent> <C-U> <ESC>:call Browser()<CR>
vnoremap <silent> <C-U> <ESC>:call Browser()<CR>

" Enable Hex editing mode.
nnoremap <silent> <C-H> <ESC>:call ToggleHex()<CR>
" Placing the letter 'i' at the end causes Vim to return to insert mode after toggling hex mode.
inoremap <silent> <C-H> <Esc>:call ToggleHex()<CR>i
" Placing the letter 'v' at the end causes Vim to return to visual mode after toggling hex mode.
vnoremap <silent> <C-H> <Esc>:call ToggleHex()<CR>i

" Enable the displaying of whitespace characters, including tab characters.
nnoremap <silent> <F6> <ESC>:set list!<CR>
" Placing the letter 'i' at the end causes Vim to return to insert mode after toggling list mode.
inoremap <silent> <F6> <ESC>:set list!<CR>i
" Placing the letter 'v' at the end causes Vim to return to visual mode after toggling list mode.
vnoremap <silent> <F6> <ESC>:set list!<CR>v

" Instruct Vim to generate syntax highlight for the entire buffer, beginning from the start of the buffer.
noremap <silent> <F12> <Esc>:syntax sync fromstart<CR>
" Placing the letter 'i' at the end causes Vim to return to insert mode after toggling syntax highlighting.
inoremap <silent> <F12> <ESC>:syntax sync fromstart<CR>i
" Placing the letter 'v' at the end causes Vim to return to visual mode after toggling syntax highlighting.
vnoremap <silent> <F12> <ESC>:syntax sync from start<CR>v

" Toggle all folds either open if one or more are closed.
nnoremap <F9> zR
inoremap <F9> <C-O>zR
vnoremap <F9> zR

" Go to the definition of the text that lays below the cursor. This will cause Vim to load the file containing the definition of say a function or variable.
nnoremap <silent> <C-D> <ESC><C-]>
inoremap <silent> <C-D> <ESC><C-]>
vnoremap <silent> <C-D> <ESC><C-]>

"====================================================
" Command-line Mode
"
" Useful mappings for command-line mode.
"====================================================

" Pressing CTRL-V pastes clipboard text at the cursor's location.
cmap <C-V> <C-R>+

"====================================================
" Insert Mode
"
" Useful mappings for insert mode.
"====================================================

" Use <F11> to toggle between 'paste' and 'nopaste' which disables and enables auto-indenting respectively. Useful when pasting content into a file that is already correctly indented.
set pastetoggle=<F11>

"====================================================
" Normal Mode
"
" Useful mappings for normal mode.
"====================================================

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy, which is the default.
nnoremap Y y$

"" Map <space> to /, for forward searching, and CTRL+<space> to ?, for backwards searching.
nnoremap <space> /
nnoremap <C-space> ?

" Setup fast saving using leader.
nnoremap <leader>w :w!<CR>

" Remove the Window's ^M character when the encoding is messed up.
nnoremap <leader>m mmHmt:%s/<C-V><CR>//ge<CR>'tzt'm

" Open vimgrep and put the cursor in the correct position.
nnoremap <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>

" Vimgreps within the current file.
nnoremap <leader><space> :vimgrep // <C-R>%<C-A><right><right><right><right><right><right><right><right><right>

" Toggle spell checking on or off.
nnoremap <silent> <leader>ss :setlocal spell!<CR>

" Toggle paste mode on or off.
nnoremap <silent> <leader>pp :setlocal paste!<CR>

" Close current window.
nnoremap <leader>cw <C-W>c

" Support switching between Vim splits using ALT and the arrow keys.
nnoremap <silent> <A-Up> :wincmd k<CR>
nnoremap <silent> <A-Down> :wincmd j<CR>
nnoremap <silent> <A-Left> :wincmd h<CR>
nnoremap <silent> <A-Right> :wincmd l<CR>

" Support the swapping of buffers between two windows. We support two options, using either the <leader> or a function key. <F3> Marks a buffer for movement and <F4> selects the second buffer of the swap pair and then executes the swap.
nnoremap <silent> <leader>mw :call MarkWindowSwap()<CR>
nnoremap <silent> <leader>pw :call DoWindowSwap()<CR>
nnoremap <silent> <F3> :call MarkWindowSwap()<CR>
nnoremap <silent> <F4> :call DoWindowSwap()<CR>

" Resize current window by +/- 3 rows/columns using CTRL and the arrow keys.
nnoremap <silent> <C-Up> :resize +3<CR>
nnoremap <silent> <C-Down> :resize -3<CR>
nnoremap <silent> <C-Right> :vertical resize +3<CR>
nnoremap <silent> <C-Left> :vertical resize -3<CR>

" Swap SQL join predicate.
nnoremap <leader>sjp :call SwapJoinPredicate()<CR>

" Retrieve the word currently underneath the cursor.
nnoremap <leader>gwuc :call GetWordUnderCursor()<CR>

" Pressing CTRL-A selects all text within the current buffer.
nnoremap <C-A> gggH<C-O>G

"====================================================
" Operator-Pending Mode
"
" Useful mappings for operator-pending mode.
"====================================================

"====================================================
" Replace Mode
"
" Useful mappings for replace mode.
"====================================================

"====================================================
" Select Mode
"
" Useful mappings for select mode.
"====================================================

" Pressing CTRL-C and CTRL-Insert copies the selected text.
snoremap <C-C> <C-O>"+y

"====================================================
" Visual Mode
"
" Useful mappings for visual mode.
"====================================================

" Pressing CTRL-C and CTRL-Insert copies the selected text.
xnoremap <C-C> "+y

"====================================================
" Visual and Select Modes
"
" Useful mappings that are available in both visual and select modes.
"====================================================

" Search and replace the selected text.
vnoremap <silent> <leader>r :call VisualSelection('replace')<CR>

" Pressing * or # while in normal mode searches for the current selection. '*' searches forward while '#' searches backwards.
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" Pressing gv uses vimgrep after the selected text.
vnoremap <silent> gv :call VisualSelection('gv')<CR>

" Enable Hex editing mode.
vnoremap <C-H> :<C-U>ToggleHex()<CR>

" Pressing backspace will delete the character to the left of the cursor.
vnoremap <backspace> d

" Pressing CTRL-X and SHIFT-Del will cut the highlighted text.
vnoremap <C-X> "+x

" Pressing CTRL-A selects all text within the current buffer.
vnoremap <C-A> ggVG

"--------------------------------------------------------
" Block Commenting
"
" These options and commands support commenting and uncommenting large source code blocks based on language.
"---------------------------------------------------------

" Map filetypes to comment delimiters.
au FileType haskell,vhdl,ada let b:comment_leader = '-- '
au FileType vim let b:comment_leader = '" '
au FileType c,cpp,java,javascript,php let b:comment_leader = '// '
au FileType fql,fqlut let b:comment_leader = '\\ '
au FileType sh,make let b:comment_leader = '# '
au FileType tex let b:comment_leader = '% '

" Define comment functions to map comment to 'cc' and uncomment to 'uc' in visual and normal mode.
nnoremap <silent> cc :<C-B>sil <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:noh<CR>
vnoremap <silent> cc :<C-B>sil <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:noh<CR>
nnoremap <silent> uc :<C-B>sil <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:noh<CR>
vnoremap <silent> uc :<C-B>sil <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:noh<CR>

"====================================================
" Setup Python Virtual Environment Support

" Add Python's virtualenv's site-packages to the Vim path so that code completion will only work for those libraries within
" the virtual environment.
"====================================================

py << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF

"====================================================
" Setup Omni Complete Plugin and Other Language Tools
"
" Setup for Omni Completion to facilitate auto-completion support and to further configure language-specific helper tools.
"====================================================

" Configure the auto-complete pop-up menu to automatically open and close.
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif

" Configure pop-up menu to auto-select based on order of options.
set completeopt=menuone,menu,longest,preview

" Set the default tag file to equal the name of the file that is generated as a result of the UpdateTags() function. If a tag file not exist within the directory containing the file that is being edited by Vim then it is simply not used. No negative effects occur.
if has('win32')
	set tags+=./tags
elseif has('unix')
	set tags+=./tags
endif

" Use binary search to search a tags file for matching patterns. Assumes the tags file was sorted on ASCII byte value. If no match is found during an initial search, Vim will switch to a linear search and re-scan the tags file. OPTIMIZATION: Requires tags files to be sorted by Ctags using the 'foldcase' option and requires Vim to have 'ignorecase' option set. Optimization will insure all matching tags are found, while still supporting binary search. See ":help tagbsearch".
set tagbsearch

" Enable a Vim option to remember which tags were jumped to, and from where. The tagstack list shows the tags that were jumped to and the cursor position right before the jump.
set tagstack

" GENERIC LANGUAGE SUPPORT

" Enable default auto complete support in Vim. Will force Vim to select the appropriate auto complete tool based on filetype.
set omnifunc=syntaxcomplete#Complete

" C SUPPORT.

" Enable C Omni Complete on C source and header files.
if version >= 700
	autocmd FileType c set omnifunc=ccomplete#Complete " Default Omni Complete line for enabling Omni Complete for C files.
endif

" C++ SUPPORT.

" Enable C++ Omni Complete on C++ source and header files.
if version >= 700
	autocmd FileType cpp set omnifunc=omni#cpp#complete#Main " Override built-in C Omni Complete with C++ OmniCppComplete plugin.
	" autocmd BufNewFile,BufRead,BufEnter *.cpp,*.hpp " A possible improvement is to use the proceeding line in which the file extensions are specified. It may be required to get Vim to recognize files that have usual extensions.
	let OmniCpp_GlobalScopeSearch = 1 " Search for functions starting from the global scope and narrowing down from there.
	let OmniCpp_NamespaceSearch = 1 " Search for functions within the current file and all included files.
	let OmniCpp_ShowAccess = 1 " Show access modifier (private(-), public(#), or protected(#)).
	let OmniCpp_DisplayMode = 1 " Show all members: static, public, protected, and private.
	let OmniCpp_ShowScopeInAbbr = 1 " Show namespace, such as the class, that defines the function.
	let OmniCpp_ShowPrototypeInAbbr = 1 " Show prototype (argument types).
	let OmniCpp_MayCompleteDot = 1 " Autocomplete after .
	let OmniCpp_MayCompleteArrow = 1 " Autocomplete after ->
	let OmniCpp_MayCompleteScope = 1 " Autocomplete after ::
	let OmniCpp_SelectFirstItem = 2 " Select first item within the pop-up menu. (1 = Insert option into text, 2 = Select but don't insert into text)
	let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"] " Omni Complete will include the following namespaces by default, without first requiring the namespaces to be specified.
	set completeopt=menuone,menu,longest
endif

" List OmniCppComplete tag database files.
if has('unix')
	set tags+=~/.vim/tags/stl " STL C++ tag database file.
endif

" Automatically insert header guards into new C++ header files.
function! s:insert_header_guard()
	let gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
	execute "normal! i#ifndef " . gatename
	execute "normal! o#define " . gatename
	execute "normal! Go#endif"
	normal! kk
endfunction
autocmd BufNewFile *.{h,hpp} call <SID>insert_header_guard()

" Enable the display of space errors for C and C++ files. Space errors are caused by the inclusion of excessive white space on blank lines or as trailing white space. Space errors are shown as highlighted character blocks.
let c_space_errors=1

" Highlight strings inside C comments. Therefore, the use of "string" inside of a C comment will cause the entire "string" to receive a special highlighting color.
let c_comment_strings=1

" PYTHON SUPPORT.

" Enable Python Omni Complete on Python files.
if version >= 700
	autocmd FileType python set omnifunc=pythoncomplete#Complete
endif

" Enable the display of space errors for Python files. Space errors are caused by the inclusion of excessive white space on blank lines or as trailing white space. Space errors are shown as highlighted character blocks.
let python_space_errors=1

" RUBY SUPPORT.

" Enable Ruby Omni Complete on Ruby and eRuby files.
if version >= 700
	autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
	autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1 " Show buffer/rails/global members.
	autocmd FileType ruby,eruby let g:rubycomplete_rails = 1 " Enable Ruby on Rails support.
	autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1 " Show classes in global completions.
endif

" Enable the display of space errors for Ruby files. Space errors are caused by the inclusion of excessive white space on blank lines or as trailing white space. Space errors are shown as highlighted character blocks.
let ruby_space_errors=1

" JAVA SUPPORT.

" Enable the display of space errors for Java files. Space errors are caused by the inclusion of excessive white space on blank lines or as trailing white space. Space errors are shown as highlighted character blocks.
let java_space_errors=1

" PHP SUPPORT.

" Instruct Vim to treat *.phtml files as PHP source code files.
au BufNewFile,BufRead *.phtml set syntax=php

" JAVASCRIPT SUPPORT.

" Enable JavaScript Omni Complete on JavaScript files.
if version >= 700
	autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
endif

" HTML SUPPORT.

" Enable HTML Omni Complete on HTML file.
if version >= 700
	autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
endif

" CSS SUPPORT.

" Enable CSS Omni Complete on CSS files.
if version >= 700
	autocmd FileType css set omnifunc=csscomplete#CompleteCSS
endif

" OTHER SUPPORT.

" Change the default auto-complete pop-up window color scheme from pink to a custom scheme using Black for the background, Cyan for each entry in the dropdown, and Green for the item currently under focus..
if version >= 700
	highlight clear
	highlight Pmenu ctermfg=Cyan ctermbg=Black guifg=Cyan guibg=Black gui=bold
	highlight PmenuSel ctermfg=Green ctermbg=Black guifg=Green guibg=Black gui=bold
	highlight PmenuSbar ctermfg=White ctermbg=Green guifg=White guibg=Green gui=bold
	highlight PmenuThumb ctermfg=White ctermbg=Green guifg=White guibg=Green gui=bold
endif

" Update, or create, a tag database file for source code contained within the directory, and recursively within sub-directories, that Vim was opened.
function! UpdateTags()
	execute ":silent !ctags --recurse=yes --sort=foldcase --languages=C++ --c++-kinds=+p --fields=+iaS --extra=+fq ./"
	execute ":redraw!"
	echohl StatusLine | echo "C/C++ Tags Updated" | echohl None
endfunction
nnoremap <silent> <F5> <ESC>:call UpdateTags()<CR>
inoremap <silent> <F5> <ESC>:call UpdateTags()<CR>i
vnoremap <silent> <F5> <ESC>:call updateTags()<CR>v

"====================================================
" Setup Vundle Plugin
"
" Setup the Vundle plugin so that it's aware of all the external plugins we're interested in.
"====================================================

" Add Vundle to Vim's PATH and then initialize Vundle.
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Main Vundle plugin repository.
Bundle 'https://github.com/gmarik/vundle'

" All other plugins.
Bundle 'https://github.com/vim-scripts/closetag.vim'
Bundle 'https://github.com/kien/ctrlp.vim'
Bundle 'https://github.com/gregsexton/gitv.git'
Bundle 'https://github.com/claco/jasmine.vim'
Bundle 'https://github.com/vim-scripts/jQuery'
Bundle 'https://github.com/vim-scripts/OmniCppComplete'
Bundle 'https://github.com/scrooloose/syntastic'
Bundle 'https://github.com/majutsushi/tagbar'
Bundle 'https://github.com/mbbill/undotree'
Bundle 'https://github.com/derekwyatt/vim-fswitch'
Bundle 'https://github.com/tpope/vim-fugitive'
Bundle 'https://github.com/pangloss/vim-javascript'
Bundle 'https://github.com/heavenshell/vim-jsdoc'
Bundle 'git://vim-latex.git.sourceforge.net/gitroot/vim-latex/vim-latex'
Bundle 'https://github.com/dbakker/vim-lint'
Bundle 'https://github.com/phleet/vim-mercenary'
"Bundle 'https://github.com/techlivezheng/vim-plugin-minibufexpl.git' " Disabling this plugin until the following issue is resolved in the vim-plugin-minibufexpl plugin: https://github.com/techlivezheng/vim-plugin-minibufexpl/issues/21
Bundle 'https://github.com/kana/vim-scratch'
" Required by vim-snipmate.
Bundle "https://github.com/MarcWeber/vim-addon-mw-utils"
" Required by vim-snipmate.
Bundle "https://github.com/tomtom/tlib_vim"
Bundle "https://github.com/garbas/vim-snipmate"
Bundle "https://github.com/honza/vim-snippets"

"====================================================
" Setup Closetag Plugin
"
" Setup for a tool that closes open HTML/XML tags.
"====================================================

" Default mapping for closing an HTML/XML tag is <C-_>.

"====================================================
" Setup CtrlP Plugin
"
" Setup for a tool that allows for fuzzy matching on file names within the current directory, or parent directory containing a repository directory, or against opened buffers, or MRU (Most Recently Used) files.
"====================================================

" Default mapping for CtrlP is <C-P>.

" Set the default behavior for the CtrlP plugin to search against files, buffers, and MRU files.
let g:ctrlp_cmd = 'CtrlPMixed'

"|bin|tmp|node_modules|bower_components$',
let g:ctrlp_custom_ignore = {
	\ 'dir':  '\v[\/]\.(git|hg|svn)$',
	\ 'file': '\v\.(pyc|pyo|a|exe|dll|so|o|min.js|zip|7z|gzip|gz|jpg|png|gif|avi|mov|mpeg|doc|odt|ods)$'
	\ }

" Set the maximum depth of a directory tree to recurse into.
let g:ctrlp_max_depth = 40

" Set the maximum number of files to scan into the CtrlP cache for fuzzing matching.
let g:ctrlp_max_files = 10000

" Set the option to require CtrlP to scan for dotfiles and dotdirs.
let g:ctrlp_show_hidden = 1

"====================================================
" Setup FSwitch Plugin
"
" Setup for an integrated tool that can switch between companion files, such as *.cxx and *.h. Furthermore, it allows for the quick creation of companion files, when they don't already exist, in a pre-defined location.
"====================================================

" Set the default file extension of a companion file.
let b:fswitchdst = 'h'

" Set the default folders to search in for a companion file.
let b:fswitchlocs = 'reg:|src|include/**|'

" Disable the creation of a new companion file if a companion file could not be found.
"set fsnonewfiles

" When viewing a C++ header file, open the first available companion file using the following order: {.cxx}, {.cpp}, and then {.c}. Furthermore, look for a companion file in an include and source directory, and if that fails, search in the current directory. If all else fails, create a new companion file in an UNKNOWN directory.
augroup cppfiles
	au!
	au BufEnter *.h let b:fswitchdst  = 'cxx,cpp,c'
	au BufEnter *.h let b:fswitchlocs = 'reg:/include/src/,reg:/include.*/src/'
augroup END

" Switch between a C/C++ header and its source by opening the companion file in a new vertical split window on the right. Only works if there are not other splits to the right.
map <silent> <F2> <ESC>:FSSplitRight<CR>
map! <silent> <F2> <ESC>:FSSplitRight<CR>

"====================================================
" Setup Fugitive Plugin
"
" Setup for an integrated git tool that allows for the management (clone, checkout, branch, add, .etc) of git repositories from within Vim.
"====================================================

" Use the following commands like that their counter parts in Git would be used:
" Gsplit
" Gedit
" Gblame
" Gcommit
" Gremove
" Gmove
" Others...

"====================================================
" Setup Jasmine Plugin
"
" Setup for Jasmine allowing Jasmine templates to be used when creating new Jasmine Spec files, for snippets that allow for basic Jasmine auto-completion, and for Jasmine syntax highlighting.
"====================================================

" Must set these directories manually. If not the Jasmine plugin will attempt to use Pathogen commands to resolve the plugin path. Because we use Vundle instead of Pathogen, Pathogen commands do not exist. If we specify the path manually the calls to Pathogen are bypassed.
let g:jasmine_snippets_directory='~/.vim/bundle/jasmine.vim/snippets'
let g:jasmine_templates_directory='~/.vim/bundle/jasmine.vim/templates'

"====================================================
" Setup JavaScript Plugin
"
" Setup for working with JavaScript files including proper syntax highlighting, reference mapping, and proper indentions.
"====================================================

let g:html_indent_inctags = "html,body,head,tbody" " Indent elements within the following HTML tags.
let g:html_indent_script1 = "inc" " Indent script contents.
let g:html_indent_style1 = "inc" " Style contents within script tags.

"====================================================
" Setup JQuery Plugin
"
" Setup for working with JQuery files, or JavaScript containing JQuery, including proper syntax highlighting, reference mapping, and proper indentions.
"====================================================

au BufRead,BufNewFile jquery.*.js set ft=javascript syntax=jquery

"====================================================
" Setup LaTex Plugin
"
" Setup for working with LaTex files including proper syntax highlighting, reference mapping, and TeX compilation.
"====================================================

" Windows users must have 'shellslash' set so that latex can be called correctly.
set shellslash

" Grep will sometimes skip displaying the file name if you search in a singe file. This will confuse Latex-Suite. Therefore we set grep to always generate a file-name.
set grepprg=grep\ -nH\ $*

" Starting with Vim 7, the filetype of empty .tex files defaults to 'plaintext' instead of 'tex', which results in vim-latex not being loaded. The following changes the default filetype back to 'tex'.
let g:tex_flavor = 'latex'

" If you write your \label's as \label{fig:something}, then if you type in \ref{fig: and press <C-n> you will automatically cycle through all the figure labels.
set iskeyword+=:

"====================================================
" Setup Mini Buffer Explorer Plugin
"
" Setup for the Mini Buffer Explorer that helps assist in visualizing all open file buffers.
"====================================================

" To switch between buffers use the following command:
" :buffer [BUFFER INDEX]

"====================================================
" Setup Scratch Plugin
"
" Setup for a scratch utility that generates scratch buffers, un-savable buffers, on request.
"====================================================

" Only one scratch buffer can exist per Vim instance. Once invoked, the scratch buffer, and its contents, will not be lost until the current Vim instance is closed.

" To open a new scratch buffer, or existing scratch buffer, in a split window:
"	:ScratchOpen
" To close the scratch buffer:
"	:ScratchClose
" Closing a scratch buffer can also be done using ':q' as with any buffer.
"	:q

"====================================================
" Setup Syntastic Plugin
"
" Setup for the Syntastic plugin so that it knows how to behave for each software language filetype. Additional configuration can be included in this section to, for example, specify the tool that should be used to check a particular filetype for lint issues.
"====================================================

" C++

" Set our preferred lint checker to CppChecker.
let g:syntastic_cpp_checkers=['cppcheck']

" JavaScript

" Set our preferred lint checker to JsHint.
let g:syntastic_python_checkers=['jshint']

" PYTHON

" Set our preferred lint checker to PEP8, with a fallback to PyLint if the PEP8 checker fails to find any issues.
let g:syntastic_python_checkers=['pep8', 'pylint']

" YAML

" Set our preferred lint checker to JSYAML.
let g:syntastic_yaml_checkers=['jsyaml']

"====================================================
" Setup Tagbar Plugin
"
" Setup for Tagbar allowing a sidebar to display Ctags relevant to the current file.
"====================================================

" Toggle the Tagbar window on or off in normal and insert modes.
nnoremap <silent> <F8> <ESC>:TagbarToggle<CR>
" Placing the letter 'i' at the end causes the Tagbar to be turned on/off and for Vim to then return to insert mode.
inoremap <silent> <F8> <ESC>:TagbarToggle<CR>i
" Place the letter 'v' at the end causes the Tagbar to be turned on/off and for Vim to then return to visual mode.
vnoremap <silent> <F8> <ESC>:TagbarToggle<CR>v
