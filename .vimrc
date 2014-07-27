"====================================================
" Vim Configuration
"
" This script provides useful Vim configuration settings.
"====================================================

"====================================================
" Environment State
"
" Capture the state of Vim's working environment (Such as the operating system, and its environmental variables, on which Vim is executing) so that various options can be enabled, or disabled, to optimize the user's experience.
"====================================================

let s:isSSH = !empty($SSH_TTY)

"====================================================
" General Features
"
" These options enable several useful baseline features for improving Vim functionality.
"====================================================

if has('vim_starting')
	" Ensure that Vim always starts with its defaults rather than those imposed by the current system.
	set all&
endif

" Set how many lines of history Vim must remember.
set history=1000

" Set to automatically check and read a file that has changed from the outside of this Vim instance.
set autoread

" Set 'nocompatible' to prevent backwards compatibility with Vi, thereby enabling features specific to Vim.
set nocompatible

" Disable filetype detection as per Vundle's requirements.
filetype off

" Enable filetype for the inclusion of plugins that are file type specific.
filetype plugin on

" Enable filetype plugins that allow intelligent auto-indenting based on file type.
filetype indent on

" Use Unix as the standard file type when saving a buffer back to file. This will cause Unix line terminators, \n, to be used for deliminating a file's newlines.
set fileformat=unix

" Check for built-in support for multi-byte character sets such as UTF-8.
if has('multi_byte')
	" If our keyboard encoding is not set, store the current file encoding value within the keyboard terminal variable.
	if &termencoding == ""
		let &termencoding = &encoding
	endif

	set encoding=utf-8 " Set the default encoding for how Vim represents characters internally.
	setglobal fileencoding=utf-8 " Set the encoding for a particular file (local to the buffer).
	set fileencodings=ucs-bom,utf-8,latin1 " Set the sequence of encodings to be used as a heuristic when reading an existing file. The first encoding that matches will be used.
endif

" Set the system's default shell as Vim's default shell to be used when executing commands within a shell.
set shell=/bin/sh

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

" When running Vim outside of an SSH session indicate to Vim that we have a fast terminal connection. If running over an SSH connection then disable the ttyfast option. ttyfast instructs Vim to send more characters to the screen for re-drawing rather than using insert/delete line commands.
if !s:isSSH
	set ttyfast
else
	set nottyfast
endif

" Set printing options such as syntax and the output paper size.
set printoptions=paper:A4,syntax:y

" Allow the terminal cursor to move freely, even past the end of a line. BAD IDEA.
"set virtualedit=all

" Location to store Vim temporary files.
set directory=~/.vim/temp

" Set the default language to use for spell checking.
setlocal spelllang=en_us

" Create a directory if it doesn't already exist.
function! EnsureDirectoryExists(directory)
	" Take the given directory, trim white space, and then expand the path using any path wildcards; such as ~ for example. Also, the second argument to expand(...) instructs expand to ignore Vim's suffixes and wildignore options..
	let l:path = expand(substitute(a:directory, '\s\+', '', 'g'), 1)

	" Ensure the expanded path is non-empty. An empty l:path may be caused if path expansion in previous step fails. For that reason we should return the original directory in hopes that it's useful for debugging.
	if empty(l:path)
		echoerr "EnsureDirectoryExists(): Invalid path: " . a:directory
		return 0
	endif

	" Ensure the path does not already exist (Because what's the point of creating a directory that already exists.).
	if !isdirectory(l:path)
		" Ensure `mkdir` exists on the system or otherwise we can't create the directory automatically.
		if exists('*mkdir')
			call mkdir(l:path,'p')
			echomsg "Created directory: " . l:path
		else
			echoerr "Please create directory: " . l:path
		endif
	endif

	return isdirectory(l:path)
endfunction

"====================================================
" Setup Vundle Plugin
"
" Setup the Vundle plugin so that it's aware of external plugins we're interested in incorporating into our Vim instance. Vundle will manage those plugins by pulling in updates and placing them in the appropriate Vim directory.
"
" Note: Vundle-managed plugins MUST be listed before any configuration steps involving these plugins can take place.
"====================================================

" Add Vundle to Vim's runtime PATH.
if has('vim_starting')
	set runtimepath+=~/.vim/bundle/vundle/
endif

" Initialize Vundle.
call vundle#rc()

" Main Vundle plugin repository.
Plugin 'https://github.com/gmarik/vundle'

" All other plugins.
Plugin 'https://github.com/kien/ctrlp.vim'
Plugin 'https://github.com/gregsexton/gitv'
Plugin 'https://github.com/claco/jasmine.vim'
Plugin 'https://github.com/nanotech/jellybeans.vim'
Plugin 'https://github.com/vim-scripts/jQuery'
Plugin 'https://github.com/vim-scripts/OmniCppComplete'
Plugin 'https://github.com/scrooloose/syntastic'
Plugin 'https://github.com/majutsushi/tagbar'
Plugin 'https://github.com/edkolev/tmuxline.vim'
Plugin 'https://github.com/mbbill/undotree'
Plugin 'https://github.com/bling/vim-airline'
Plugin 'https://github.com/derekwyatt/vim-fswitch'
Plugin 'https://github.com/tpope/vim-fugitive'
Plugin 'https://github.com/nathanaelkane/vim-indent-guides'
Plugin 'https://github.com/pangloss/vim-javascript'
Plugin 'https://github.com/jelera/vim-javascript-syntax'
Plugin 'https://github.com/heavenshell/vim-jsdoc'
Plugin 'git://vim-latex.git.sourceforge.net/gitroot/vim-latex/vim-latex'
Plugin 'https://github.com/dbakker/vim-lint'
Plugin 'https://github.com/plasticboy/vim-markdown'
Plugin 'https://github.com/phleet/vim-mercenary'
Plugin 'https://github.com/kana/vim-scratch'
Plugin 'https://github.com/mhinz/vim-signify'
" Required by vim-snipmate.
Plugin 'https://github.com/MarcWeber/vim-addon-mw-utils'
" Required by vim-snipmate.
Plugin 'https://github.com/tomtom/tlib_vim'
Plugin 'https://github.com/garbas/vim-snipmate'
Plugin 'https://github.com/honza/vim-snippets'
Plugin 'https://github.com/jmcantrell/vim-virtualenv'

"====================================================
" User Interface
"
" These options alter the graphical layout and visual color of the interface, and alter how file contents are rendered.
"====================================================

" Enable Vim's syntax highlighting support. Specifically we call 'syntax enable' rather than 'syntax on'. Using 'enable' will instruct Vim to keep the current color settings rather than overruling those settings with Vim's defaults.
syntax enable

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

" Set the command window height to one line. This leaves a single line underneath the status line for command output. This could cause issues with commands that return more output than can fit on that one line. In those cases you may be prompted with the following statement 'press <Enter> to continue', which will require physical intervention on your part. However, this seems like a reasonable compromise as the reduction of the command output lines to only one line saves valuable real estate by avoiding unused white space. One way to offset the 'press <Enter>' prompting is to use the 'shortmess' option to reduce command output.
set cmdheight=1

" Use abbreviations when posting status messages to the command output line (The line right beneth Vim's statusline). Shortening command output may help avoid the 'press <Enter>' prompt that appears when the output is longer than the available space in the command output section. Furthermore, we append the 't' option to 'shortmess' so that if abbreviations are insufficient to keep output within the confines of the command output section, then content will be truncated as necessary; beginning at the start of the message.
set shortmess=at

" Display line numbers on the left with a column width of 4.
set number
set numberwidth=4

" Quickly time out on keycodes, but never time out on mappings.
set timeout timeoutlen=1000 ttimeoutlen=100

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

	" Set GUI font options based on the operating system.
	if has('win32') || has ('win64')
		set guifont=Monospace\ 10
	elseif has('unix')
		set guifont=DejaVu\ Sans\ Mono\ 10
	endif
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
augroup helpFile
	autocmd!

	autocmd FileType helpfile set nonumber
augroup END

" Configure Vim's formatting options used by Vim to automatically for a line of text. Formatting not applied when 'paste' is enabled.
" Options:
" j - Where it makes sense, remove a comment leader when joining lines.
" l - Do not break existing long lines when entering insert mode.
" n - Recognize numbered lists and automatically continue the correct level of indention onto the next line.
" r - Automatically insert the current comment leader after pressing <ENTER> in Insert mode.
" o - Automatically insert the current comment leader after after entering 'o' or 'O' in Normal mode.
set formatoptions+=jlnro

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
call EnsureDirectoryExists($HOME . '/.vim/backups')

"====================================================
" Clipboard
"
" These options manage settings associated with Vim's built-in clipboard support that allows copying between Vim instances and other applications. This is possible by leveraging the System's clipboard.
"====================================================

" Setup Vim to use the operating system's native clipboard for all copy and paste operations. This will allow content to be copied and pasted between Vim and other system applications.
if has('clipboard')
	" Set Vim to use the system clipboard, available through the * registry, by default for all copy and paste operations.
	set clipboard=unnamed
elseif has('xterm_clipboard')
	" Set Vim to use the X11 clipboard, available through the + registry, by default for all copy and paste operations.
	set clipboard=unnamedplus
endif

"====================================================
" Doxygen
"
" These options manage settings associated with Vim's built-in support for Doxygen.
"====================================================

" Autoload Doxygen highlighting. This allows Vim to understand special documentation syntax, such as '\param' so that the built-in spell checker does not give a false positive.
let g:load_doxygen_syntax = 1

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
	call EnsureDirectoryExists($HOME . '/.vim/undo')

	" Turn on persistent undo history.
	set undofile

	" Set the maximum number of undos that should be kept in history.
	set undolevels=100

	" Set the maximum number of lines to save for undo on a buffer reload. Allows the current contents of a buffer to be saved when reloading the buffer so that the buffer reload can be undone.
	set undoreload=1000
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
let g:netrw_browse_split = 4

" Medium speed directory browsing by re-using directory listings only when using Explorer to browse remote directories.
let g:netrw_fastbrowse = 1

" List files and directories in the Explorer window using the tree listing style.
let g:netrw_liststyle = 3

" Place the file preview window in a horizontal split window. A file can be previewed by pressing 'P'.
let g:netrw_preview = 0

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
augroup deleteTrailingWhiteSpace
	autocmd!

	autocmd BufWrite * :call DeleteTrailingWS()
augroup END

" Return to the last edit position when re-opening a file.
augroup returnLastLine
	autocmd!

	autocmd BufReadPost *
		\ if line("'\"") > 0 && line("'\"") <= line("$") |
		\   exe "normal! g`\"" |
		\ endif
augroup END

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
		call execute "%s/" . l:pattern . "/"
	elseif a:direction == 'f'
		execute "normal /" . l:pattern . "^M"
	endif

	let @/ = l:pattern
	let @" = l:saved_reg
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
		execute 'bdelete! ' . l:currentBufNum
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
	autocmd!

	" Set binary option for all binary files before reading them.
	autocmd BufReadPre *.bin,*.hex,*.exe,*.tar setlocal binary

	" If on a fresh read the buffer variable is already set, it's wrong.
	autocmd BufReadPost *
		\ if exists('b:editHex') && b:editHex |
		\   let b:editHex = 0 |
		\ endif

	" Convert to hex on startup for binary files automatically.
	autocmd BufReadPost *
		\ if &binary | :call ToggleHex() | endif

	" When the text is freed the next time the buffer is made active it will re-read the text and thus not match the correct mode, we will need to convert it again if the buffer is again loaded.
	autocmd BufUnload *
		\ if getbufvar(expand('<afile>'), 'editHex') == 1 |
		\   call setbufvar(expand('<afile>'), 'editHex', 0) |
		\ endif

	" Before writing a file when editing in hex mode, convert back to non-hex.
	autocmd BufWritePre *
		\ if exists('b:editHex') && b:editHex && &binary |
		\  let oldro = &ro | let &ro = 0 |
		\  let oldma = &ma | let &ma = 1 |
		\  silent exe "%!xxd -r" |
		\  let &ma = oldma | let &ro = oldro |
		\  unlet oldma | unlet oldro |
		\ endif

	" After writing a binary file, if we're in hex mode, restore hex mode.
	autocmd BufWritePost *
		\ if exists('b:editHex') && b:editHex && &binary |
		\  let oldro = &ro | let &ro = 0 |
		\  let oldma = &ma | let &ma = 1 |
		\  silent exe "%!xxd" |
		\  exe "set nomod" |
		\  let &ma = oldma | let &ro = oldro |
		\  unlet oldma | unlet oldro |
		\ endif
augroup END

" Toggles hex mode. Hex mode should be considered a read-only operation. Save values for modified and read-only for restoration later and clear the read-only flag for now.
function! ToggleHex()
	let l:modified = &mod
	let l:oldreadonly = &readonly
	let &readonly = 0
	let l:oldmodifiable = &modifiable
	let &modifiable = 1

	if !exists('b:editHex') || !b:editHex

		" Save old options.
		let b:oldft = &ft
		let b:oldbin = &bin

		" Set new options.
		setlocal binary " Make sure it overrides any textwidth, etc.
		let &ft = "xxd"

		" Set status.
		let b:editHex = 1

		" Switch to hex editor.
		%!xxd
	else
		" Restore old options.
		let &ft = b:oldft

		if !b:oldbin
			setlocal nobinary
		endif

		" Set status.
		let b:editHex = 0
		" Return to normal editing.
		%!xxd -r
	endif

	" Restore values for modified and read only state.
	let &mod = l:modified
	let &readonly = l:oldreadonly
	let &modifiable = l:oldmodifiable
endfunction

" Open the URI that is currently underneath the cursor in a browser.
function! Browser ()
	let line = getline('.')
	let line = matchstr(line, "http[^   ]*")

	" In Windows use Google Chrome.
	if has('win32')
		execute "!C:\Program Files (x86)\Google\Chrome\Application\chrome.exe --incognito " . line
	" In a Unix like environment use a text-based browser such as Elinks.
	elseif has('unix')
		execute "!elinks " . line
	endif
endfunction

" Automatically insert header guards into new C++ header files.
function! InsertHeaderGuard()
	let gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
	execute "normal! i#ifndef " . gatename
	execute "normal! o#define " . gatename
	execute "normal! Go#endif"
	normal! kk
endfunction

"====================================================
" Multi-Mode Mappings
"
" General options are define such that they are available within all operating modes. Also a collection of mappings usable within two or more modes are defined.
"====================================================

" Set a map leader so that extra key combinations can be used for quick operations.
let mapleader = ","
let g:mapleader = ","

" Map the semicolon character to the colon character to prevent the necessity of pressing <SHIFT+;> to enter command mode. Instead, with this map, pressing the semicolon key in any Vim mode will enter command mode.
map ; :

" Use <F11> to toggle between 'paste' and 'nopaste' modes. 'paste' and 'nopaste' modes disable and enable auto-indenting respectively. Useful when pasting text that already posses the correct indenting, and you want to preserve that indention regardless of Vim's enabled auto-indent features.
set pastetoggle=<F11>

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
nnoremap <silent> <F12> <Esc>:syntax sync fromstart<CR>
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

"====================================================
" Insert Mode
"
" Useful mappings for insert mode.
"====================================================

"====================================================
" Normal Mode
"
" Useful mappings for normal mode.
"====================================================

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy, which is the default.
nnoremap Y y$

" Map <space> to /, for forward searching, and CTRL+<space> to ?, for backwards searching.
nnoremap <space> /
nnoremap <C-space> ?

" Remove the Window's ^M character when the encoding is messed up.
nnoremap <leader>m mmHmt:%s/<C-V><CR>//ge<CR>'tzt'm

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

" Pressing CTRL-A selects all text within the current buffer.
nnoremap <C-A> gggH<C-O>G

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

" Search and replace the selected text.
vnoremap <silent> <leader>r :call VisualSelection('replace')<CR>

" Pressing * or # while in normal mode searches for the current selection. '*' searches forward while '#' searches backwards.
vnoremap <silent> 8 :call VisualSelection('f')<CR>
vnoremap <silent> 3 :call VisualSelection('b')<CR>

" Pressing gv uses vimgrep after the selected text.
vnoremap <silent> gv :call VisualSelection('gv')<CR>

" Enable Hex editing mode.
vnoremap <C-H> :<C-U>ToggleHex()<CR>

" Pressing backspace will delete the character to the left of the cursor.
vnoremap <backspace> d

" Pressing CTRL-A selects all text within the current buffer.
vnoremap <C-A> ggVG

"====================================================
" Block Commenting
"
" These options and commands support commenting and uncommenting large source code blocks based on language.
"====================================================

" Map filetypes to comment delimiters.
augroup programmingLanguageComments
	autocmd!

	autocmd FileType haskell,vhdl,ada let b:comment_leader = '-- '
	autocmd FileType vim let b:comment_leader = '" '
	autocmd FileType c,cpp,java,javascript,php let b:comment_leader = '// '
	autocmd FileType fql,fqlut let b:comment_leader = '\\ '
	autocmd FileType sh,make let b:comment_leader = '# '
	autocmd FileType tex let b:comment_leader = '% '
augroup END

" Define comment functions to map comment to 'cc' and uncomment to 'uc' in visual and normal mode.
nnoremap <silent> cc :<C-B>sil <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:noh<CR>
vnoremap <silent> cc :<C-B>sil <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:noh<CR>
nnoremap <silent> uc :<C-B>sil <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:noh<CR>
vnoremap <silent> uc :<C-B>sil <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:noh<CR>

"====================================================
" Setup Omni Complete Plugin and Other Language Tools
"
" Setup for Omni Completion to facilitate auto-completion support and to further configure language-specific helper tools.
"====================================================

" Configure the auto-complete pop-up menu to automatically open and close.
augroup autoCompleteMenu
	autocmd!

	autocmd CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
augroup END

" Configure pop-up menu to auto-select based on order of options.
set completeopt=menuone,menu,longest,preview

" Set the default tag file to equal the name of the file that is generated as a result of the UpdateTags() function. If a tag file not exist within the directory containing the file that is being edited by Vim then it is simply not used. No negative effects occur.
set tags+=./tags

" Use binary search to search a tags file for matching patterns. Assumes the tags file was sorted on ASCII byte value. If no match is found during an initial search, Vim will switch to a linear search and re-scan the tags file. OPTIMIZATION: Requires tags files to be sorted by Ctags using the 'foldcase' option and requires Vim to have 'ignorecase' option set. Optimization will insure all matching tags are found, while still supporting binary search. See ":help tagbsearch".
set tagbsearch

" Enable a Vim option to remember which tags were jumped to, and from where. The tagstack list shows the tags that were jumped to and the cursor position right before the jump.
set tagstack

" GENERIC LANGUAGE SUPPORT

" Enable default auto complete support in Vim. Will force Vim to select the appropriate auto complete tool based on filetype.
set omnifunc=syntaxcomplete#Complete

" C SUPPORT.

" Enable C Omni Complete on C source and header files.
augroup cSupport
	autocmd!

	autocmd FileType c set omnifunc=ccomplete#Complete " Default Omni Complete line for enabling Omni Complete for C files.
augroup END

" C++ SUPPORT.

augroup cppSupport
	autocmd!

	" Enable C++ Omni Complete on C++ source and header files.
	autocmd FileType cpp set omnifunc=omni#cpp#complete#Main " Override built-in C Omni Complete with C++ OmniCppComplete plugin.

	" Automatically insert header guards into new C++ header files.
	autocmd BufNewFile *.{h,hpp} call InsertHeaderGuard()
augroup END

let OmniCpp_GlobalScopeSearch = 1	" Search for functions starting from the global scope and narrowing down from there.
let OmniCpp_NamespaceSearch = 1		" Search for functions within the current file and all included files.
let OmniCpp_ShowAccess = 1			" Show access modifier (private(-), public(#), or protected(#)).
let OmniCpp_DisplayMode = 1			" Show all members: static, public, protected, and private.
let OmniCpp_ShowScopeInAbbr = 1		" Show namespace, such as the class, that defines the function.
let OmniCpp_ShowPrototypeInAbbr = 1 " Show prototype (argument types).
let OmniCpp_MayCompleteDot = 1		" Autocomplete after .
let OmniCpp_MayCompleteArrow = 1	" Autocomplete after ->
let OmniCpp_MayCompleteScope = 1	" Autocomplete after ::
let OmniCpp_SelectFirstItem = 2		" Select first item within the pop-up menu. (1 = Insert option into text, 2 = Select but don't insert into text)
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"] " Omni Complete will include the following namespaces by default, without first requiring the namespaces to be specified.

" List OmniCppComplete tag database files.
if has('unix')
	set tags+=~/.vim/tags/stl " STL C++ tag database file.
endif

" Enable the display of space errors for C and C++ files. Space errors are caused by the inclusion of excessive white space on blank lines or as trailing white space. Space errors are shown as highlighted character blocks.
let c_space_errors = 1

" Highlight strings inside C comments. Therefore, the use of "string" inside of a C comment will cause the entire "string" to receive a special highlighting color.
let c_comment_strings = 1

" PYTHON SUPPORT.

augroup pythonSupport
	autocmd!

	" Enable Python Omni Complete on Python files.
	autocmd FileType python set omnifunc=pythoncomplete#Complete
augroup END

" Enable the display of space errors for Python files. Space errors are caused by the inclusion of excessive white space on blank lines or as trailing white space. Space errors are shown as highlighted character blocks.
let python_space_errors = 1

" RUBY SUPPORT.

augroup rubySupport
	autocmd!

	" Enable Ruby Omni Complete on Ruby and eRuby files.
	autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
augroup END

let g:rubycomplete_buffer_loading = 1		" Show buffer/rails/global members.
let g:rubycomplete_rails = 1				" Enable Ruby on Rails support.
let g:rubycomplete_classes_in_global = 1	" Show classes in global completions.

" Enable the display of space errors for Ruby files. Space errors are caused by the inclusion of excessive white space on blank lines or as trailing white space. Space errors are shown as highlighted character blocks.
let ruby_space_errors = 1

" PHP SUPPORT.

augroup phpSupport
	autocmd!

	" Instruct Vim to treat *.phtml files as PHP source code files.
	autocmd BufNewFile,BufRead *.phtml set syntax=php
augroup END

" JAVASCRIPT SUPPORT.

augroup javascriptSupport
	autocmd!

	" Enable JavaScript Omni Complete on JavaScript files.
	autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS

	" Set the initial fold level for JavaScript files to level 2, rather than the default of maximum folding, a.k.a. level 1. Most JavaScript files begin with `define([], function () {});`. That syntax would, under the default fold level, cause the entire file to be folded into a single line. That level of folding hides everything meaningful, such as functions and objects defined within the confines of a `define` wrapper.
	autocmd FileType javascript set foldlevel=2
augroup END

" HTML SUPPORT.

augroup htmlSupport
	autocmd!

	" Enable HTML Omni Complete on HTML file.
	autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
augroup END

" CSS SUPPORT.

augroup cssSupport
	autocmd!

	" Enable CSS Omni Complete on CSS files.
	autocmd FileType css set omnifunc=csscomplete#CompleteCSS
augroup END

" OTHER SUPPORT.

" Change the default auto-complete pop-up window color scheme from pink to a custom scheme using Black for the background, Cyan for each entry in the dropdown, and Green for the item currently under focus..
highlight clear
highlight Pmenu ctermfg=Cyan ctermbg=Black guifg=Cyan guibg=Black gui=bold
highlight PmenuSel ctermfg=Green ctermbg=Black guifg=Green guibg=Black gui=bold
highlight PmenuSbar ctermfg=White ctermbg=Green guifg=White guibg=Green gui=bold
highlight PmenuThumb ctermfg=White ctermbg=Green guifg=White guibg=Green gui=bold

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
" Setup Vundle-based Plugins
"
" Each section below is designated to setting up and configuring a specific plugin pulled in by Vundle.
"====================================================

"====================================================
" Setup Vim-Airline Plugin
"
" Setup for a vim-airline environment so that the environment will look and behave in the desired way.
"====================================================

" Enable vim-airline's buffer status bar. This buffer status bar will appear at the very top of Vim, similiar to where the multibufexpl plugin would appear.
let g:airline#extensions#tabline#enabled = 1

" Automatically populate the `g:airline_symbols` dictionary with the correct font glyphs used as the special symbols for vim-airline's status bar.
let g:airline_powerline_fonts = 1

" Correct a spacing issue that may occur with fonts loaded via the fontconfig approach.
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"

"====================================================
" Setup CtrlP Plugin
"
" Setup for a tool that allows for fuzzy matching on file names within the current directory, or parent directory containing a repository directory, or against opened buffers, or MRU (Most Recently Used) files.
"====================================================

" Default mapping for CtrlP is <C-P>.

" Set the default behavior for the CtrlP plugin to search against files only (not against the buffers or MRU).
let g:ctrlp_cmd = 'CtrlP'

"|bin|tmp|node_modules|bower_components$',
let g:ctrlp_custom_ignore = {
	\ 'dir':  '\v[\/](\.git|\.hg|\.svn|node_modules|bower_components|dist|bin|build)$',
	\ 'file': '\v\.(pyc|pyo|a|exe|dll|so|o|min.js|zip|7z|gzip|gz|jpg|png|gif|avi|mov|mpeg|doc|odt|ods)$'
	\ }

" Set the maximum depth of a directory tree to recurse into.
let g:ctrlp_max_depth = 20

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

" When viewing a C++ header file, open the first available companion file using the following order: {.cxx}, {.cpp}, and then {.c}. Furthermore, look for a companion file in an include and source directory, and if that fails, search in the current directory. If all else fails, create a new companion file in an UNKNOWN directory.
augroup cppfiles
	autocmd!

	autocmd BufEnter *.h let b:fswitchdst  = 'cxx,cpp,c'
	autocmd BufEnter *.h let b:fswitchlocs = 'reg:/include/src/,reg:/include.*/src/'
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
" Gedit
" Gblame
" Gcommit
" Others...

"====================================================
" Setup Indent Guide Plugin
"
" Setup for Indent Guide plugin to place special color highlighting to the left of code to indicate indentional level.
"====================================================

let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1

"====================================================
" Setup Jasmine Plugin
"
" Setup for Jasmine allowing Jasmine templates to be used when creating new Jasmine Spec files, for snippets that allow for basic Jasmine auto-completion, and for Jasmine syntax highlighting.
"====================================================

" Must set these directories manually. If not the Jasmine plugin will attempt to use Pathogen commands to resolve the plugin path. Because we use Vundle instead of Pathogen, Pathogen commands do not exist. If we specify the path manually the calls to Pathogen are bypassed.
let g:jasmine_snippets_directory = '~/.vim/bundle/jasmine.vim/snippets'
let g:jasmine_templates_directory = '~/.vim/bundle/jasmine.vim/templates'

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

augroup jquerySupport
	autocmd!

	autocmd BufRead,BufNewFile jquery.*.js set ft=javascript syntax=jquery
augroup END

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
" Setup Markdown Plugin
"
" Setup for the Markdown plugin to enable syntax highlighting, folding, and key bindings.
"====================================================

" Set the fold level at 1. This instructs Vim to fold all but the last level.
" You will therefore see all '#' and '##' headers, but everything under '##'
" will be folded.
let g:vim_markdown_initial_foldlevel=1

augroup markdownSupport
	autocmd!

	" Instruct Vim to treat files ending in the following as Markdown files.
	" We specifically set these files to the 'mkd' file type which is defined
	" by the vim-markdown plugin.
	autocmd BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn}   set filetype=markdown
	autocmd BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn}.{des3,des,bf,bfa,aes,idea,cast,rc2,rc4,rc5,desx} set filetype=markdown
augroup END

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
" Setup Signify Plugin
"
" Setup for the Signify plugin that adds the +, -, and ~ characters in the "gutter", a.k.a left sidebar, of Vim to indicate when lines have been added, removed, or modified as compared against a file managed by a VCS.
"====================================================

" Instruct the Signify plugin to only check for these version control systems upon loading a file into a Vim buffer. Restricting the list of version control systems to check for will improve the performance of the Signify plugin (by preventing Signify from checking the loaded buffer against every version control system). Also note that this list is a priority list. Version control support is checked in the order of those items in the list.
let g:signify_vcs_list = ['git', 'hg']

" Mapping for jumping around in a buffer between next, or previous, change hunks.
let g:signify_mapping_next_hunk = '<leader>gj'
let g:signify_mapping_prev_hunk = '<leader>gk'

" Toggles the Signify plugin for the current buffer only.
let g:signify_mapping_toggle = '<leader>gt'

" Don't overwrite existing signs placed into the left sidebar by other Vim plugins.
let g:signify_sign_overwrite = 0

" Update signs when Vim is given focus.
let g:signify_update_on_focusgained = 0

" Use alternative signs for various states of a line under version control.
let g:signify_sign_change = '~'

" By default `git diff` compares the working copy against the staging index. Therefore, after you have added a change hunk to the index, signify will no longer indicate the change along the file's left sidebar. This is not really our desired behavior. It would be preferable to see all changes in a file not yet committed to the repository.
let g:signify_diffoptions = { 'git': 'HEAD' }

"====================================================
" Setup Syntastic Plugin
"
" Setup for the Syntastic plugin so that it knows how to behave for each software language filetype. Additional configuration can be included in this section to, for example, specify the tool that should be used to check a particular filetype for lint issues.
"====================================================

" C++

" Set our preferred lint checker to CppChecker.
let g:syntastic_cpp_checkers = ['cppcheck']

" JavaScript

" Set our preferred static analysis chcker to JsHint, and style checker, the fallback checker, to jscs.
let g:syntastic_javascript_checkers = ['jshint', 'jscs']

" PYTHON

" Set our preferred lint checker to PEP8, with a fallback to PyLint if the PEP8 checker fails to find any issues.
let g:syntastic_python_checkers = ['pep8', 'pylint']

" YAML

" Set our preferred lint checker to JSYAML.
let g:syntastic_yaml_checkers = ['jsyaml']

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

" Enable Tagbar support for Markdown files by configuring Tagbar to use a special script that's capable of generating the required Ctag information necessary for Tagbar to render a tree view of the current file's headings.
let g:tagbar_type_markdown = {
	\ 'ctagstype': 'markdown',
	\ 'ctagsbin' : '~/.vim/markdown2ctags.py',
	\ 'ctagsargs' : '-f - --sort=yes',
	\ 'kinds' : [
		\ 's:sections',
		\ 'i:images'
	\ ],
	\ 'sro' : '|',
	\ 'kind2scope' : {
		\ 's' : 'section',
	\ },
	\ 'sort': 0,
\ }

"====================================================
" Setup Tmuxline Plugin
"
" Setup for Tmuxline to enable a Powerline line like status line for TMUX, but using Vim to manage the setup and configuration.
"====================================================

" Choose one of the built-in status line presets available from the Tmuxline plugin. In this case I have chosen Tmuxline's 'full' preset that includes most available data points; such as open windows, date, time, and host.
let g:tmuxline_preset = 'full'

"====================================================
" Setup Colorscheme
"
" Setup Vim to recognize our terminal as having a particular background color, and then set our preferred color scheme (a.k.a theme).
"
" Note: This setup step must be last so that the color scheme is setup properly. If configured earlier, some setting in this configuration file will cause Vim to revert to its default color scheme (or worse, you'll get a collision of multiple color schemes.).
"====================================================

" Inform Vim to expect a dark terminal background. This will cause Vim to compensate by altering the color scheme.
set background=dark

" Set Vim's color scheme.
colorscheme jellybeans
