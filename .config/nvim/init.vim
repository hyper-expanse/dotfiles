"====================================================
" Vim Configuration

" This script provides useful Vim configuration settings.
"====================================================

"====================================================
" General Features

" These options enable several useful baseline features for improving Vim functionality.
"====================================================
" Use Unix as the standard file type when saving a buffer back to file. This will cause Unix line terminators, \n, to be used for deliminating a file's newlines.
set fileformat=unix

" Disable modeline support within Vim. Modeline support within Vim has constantly introduced security vulnerabilities into the Vim editor. By disabling this feature any chance of a future vulnerability interfering with the use of Vim, or the operating system on which it runs, is mitigated. As for functionality, modelines are configuration lines contained within text files that instruct Vim how to behave when reading those files into a buffer.
set nomodeline " Turn off modeline parsing altogether.
set modelines=0 " Set the number of modelines Vim parses, when reading a file, to zero.

" Set the default language to use for spell checking. `spelllang` is a comma separated list of word lists. Word lists are of the form LANGUAGE_REGION. The LANGUAGE segment may include a specification, such as `-rare` to indicate rare words in that language.
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
" Setup vim-plug Plugin

" Setup the vim-plug plugin so that it's aware of external plugins we're interested in incorporating into our Vim instance. vim-plug will manage those plugins by pulling in updates and placing them in the appropriate Vim directory.

" Note: Plugins MUST be listed before any configuration steps involving these plugins can take place.
"====================================================

" We must ensure that the `autoload` directory exists within our `~/.vim` directory for the installation of `vim-plug` to work. If the `autoload` directory does not exist prior to invoking `curl`, `curl` will fail to download the file, as `curl` is not setup to create missing directories in the destination path.
call EnsureDirectoryExists($XDG_DATA_HOME . '/nvim/site/autoload/')
if empty(glob($XDG_DATA_HOME . '/nvim/site/autoload/plug.vim'))
	" If vim-plug has not been downloaded into Vim's autoload directory, go ahead and invoke `curl` to download vim-plug.
	execute '!curl -fLo $XDG_DATA_HOME/nvim/site/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif

call plug#begin()

"Plug 'https://github.com/ctrlpvim/ctrlp.vim.git'
Plug 'https://github.com/rakr/vim-one.git'
"Plug 'https://github.com/vim-scripts/OmniCppComplete.git'
"Plug 'https://github.com/scrooloose/syntastic.git'
"Plug 'https://github.com/majutsushi/tagbar.git'
"Plug 'https://github.com/mbbill/undotree.git'
Plug 'https://github.com/vim-airline/vim-airline.git' " At the time of writing Powerline (Python) does not support neovim.
Plug 'https://github.com/vim-airline/vim-airline-themes.git'
Plug 'https://github.com/tpope/vim-fugitive.git'
"Plug 'https://github.com/nathanaelkane/vim-indent-guides.git'
"Plug 'https://github.com/jelera/vim-javascript-syntax.git'
"Plug 'https://github.com/elzr/vim-json.git'
"Plug 'https://github.com/dbakker/vim-lint.git'
"Plug 'https://github.com/kana/vim-scratch.git'
Plug 'https://github.com/mhinz/vim-signify.git'

" JavaScript Plugins

" We include a post-install hook for installing the plugin's required runtime dependencies. This is accomplished through vim-plug's post-install hook interface that will jump into the plugin's directory and run the command passed as the value to `do`. That installation step will download the `tern` server that will be used by the tern_for_vim plugin.
"Plug 'https://github.com/marijnh/tern_for_vim.git', { 'do': 'npm install' }

" Add plugins to Vim's `runtimepath`.
call plug#end()

"====================================================
" User Interface

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

" Try not to split words across multiple lines when a line wraps.
set linebreak

" Use case insensitive search, except when using capital letters.
set ignorecase " Case insensitive search.
set smartcase " Enable case-sensitive search when the search phrase contains capital letters.

" Allows moving left when at the beginning of a line, or right when at the end of the line. When the end of the line has been reached, the cursor will progress to the next line, either up or down, depending on the direction of movement. < and > are left and right arrow keys, respectively, in normal and visual modes, and [ and ] are arrow keys, respectively, in insert mode.
set whichwrap+=<,>,h,l,[,]

" Instead of failing a command because of unsaved changes raise a dialogue asking if you wish to save changed files.
set confirm

" Enable use of the mouse for all Vim modes: Normal, Insert, Visual, and Command-line.
set mouse=a

" Use abbreviations when posting status messages to the command output line (The line right beneth Vim's statusline). Shortening command output may help avoid the 'press <Enter>' prompt that appears when the output is longer than the available space in the command output section. Furthermore, we append the 't' option to 'shortmess' so that if abbreviations are insufficient to keep output within the confines of the command output section, then content will be truncated as necessary; beginning at the start of the message.
set shortmess=at

" Display line numbers on the left with a column width of 4.
set number

" A buffer becomes hidden, not destroyed, when it's abandoned.
set hidden

" Don't redraw while executing macros, thereby improving performance.
set lazyredraw

" Show matching brackets when text indicator is over them.
set showmatch

" Disable error bells.
set noerrorbells
set novisualbell

" Start scrolling when we're 3 lines from the bottom of the current window.
set scrolloff=3

" Enable the highlighting of the row on which the cursor resides, along with highlighting the row's row number.
set cursorline

" Set the minimum number of lines to search around the cursor's position to derive the appropriate syntax highlighting.
syntax sync minlines=256

" Instruct Vim to offer corrections in a pop-up on right-click of the mouse.
set mousemodel=popup

" Configure Vim's formatting options used by Vim to automatically for a line of text. Formatting not applied when 'paste' is enabled.
" Options:
" j - Where it makes sense, remove a comment leader when joining lines.
" l - Do not break existing long lines when entering insert mode.
" n - Recognize numbered lists and automatically continue the correct level of indention onto the next line.
" o - Automatically insert the current comment leader after after entering 'o' or 'O' in Normal mode.
" q - Allow formatting of comments using `gq`.
" r - Automatically insert the current comment leader after pressing <ENTER> in Insert mode.
set formatoptions+=jlnoqr

"====================================================
" Backups

" These options manage settings associated with how backups are handled by Vim.
"====================================================

" Turn off backups for files that are being edited by Vim.
set nobackup " Do not keep a backup of a file after overwriting the file.
set noswapfile " No temporary swap files.

"====================================================
" Tabs and Indents

" These options manage settings associated with tabs and automatically indenting new lines.
"====================================================

" Number of spaces Vim should use to visually represent a TAB character when encountered within a file.
set tabstop=2

" Number of spaces Vim should use when autoindenting a new line of text, or when using the `<<` and `>>` operations (Such as pressing > or < while text is selected to change the indentation of the text). Also used by `cindent` when that option is enabled.
set shiftwidth=2

" Number of spaces Vim should insert when TAB is pressed, and the number of spaces Vim should remove when the <backspace> is pressed. This allows for a single backspace to go back this many white space characters.
set softtabstop=2

" Copy the structure of the existing lines indent when autoindenting a new line.
set copyindent

" Causes spaces to be inserted in place of tabs when the TAB key is pressed. To disable this behavior and enable the insertion of tabs when the Tab key is pressed, comment out this option.
augroup expand
	autocmd!
	autocmd Filetype javascript setlocal expandtab
augroup END

" Enable special display options to show tabs and end-of-line characters within a non-GUI window. Tabs are represented using '>-' and a sequence of '-'s that will fill out to match the proper width of a tab. End-of-line is represented by a dollar sign '$'. Displaying tabs as '>-' and end-of-lines as '$'. Trailing white space is represented by '~'. Must be toggled by a mapping to ':set list!'.
set listchars=tab:>-,eol:$,trail:~,extends:>,precedes:<

"====================================================
" Folding

" These options manage settings associated with folding portions of code into condensed forms, leaving only an outline of the code visible. Folding is a form of collapsing of function definitions, class definitions, sections, etc. When a portion of code is collapsed only a header associated with that section is left visible along with a line indicating statistics associated with the collapsed code; such as the number of collapsed lines, etc. The terms 'folded' and 'collapsed' within this file are used interchangeably with one another.
"====================================================

" Use syntax highlighting rules to determine how source code or content should be folded.
set foldmethod=syntax

"====================================================
" Difference Mode

" These options manage settings associated with Vim wile operating in difference mode, displaying differences between two similar files.
"====================================================

" Set the default difference display option such that filler lines are shown to keep text synchronized between two windows and use 6 lines of context between a change and a fold that contains unchanged lines.
set diffopt=filler,context:6

"====================================================
" Vim Explorer

" These options configure Vim's built-in file system explorer so that it behaves in a manner that meets user expectations. This includes showing files in a tree view so that entire projects can be seen at once.
"====================================================

" Will cause files selected in the Explorer window to be opened in the most recently used buffer window (Causing the previous buffer to be pushed into the background).
let g:netrw_browse_split = 4

" List files and directories in the Explorer window using the tree listing style.
let g:netrw_liststyle = 3

"====================================================
" Helper Functions

" These functions help with various automation tasks and can be mapped to various key combinations or function keys.
"====================================================

" Commands to covert tabs to spaces and vice versa. - boveresch
"command! -range=% -nargs=0 Tab2Space execute "<line1>,<line2>s/^\\t\\+/\\=substitute(submatch(0), '\\t', repeat(' ', ".&ts."), 'g')"
"command! -range=% -nargs=0 Space2Tab execute "<line1>,<line2>s/^\\( \\{".&ts."\\}\\)\\+/\\=substitute(submatch(0), ' \\{".&ts."\\}', '\\t', 'g')"

" Define a function that will delete trailing white space on save.
"function! DeleteTrailingWS()
"	exe "normal mz"
"	%s/\s\+$//ge
"	exe "normal `z"
"endfunc

" Create an autocmd that will be executed every time the buffer is written back to file, deleting trailing white space.
"augroup deleteTrailingWhiteSpace
"	autocmd!

"	autocmd BufWrite * :call DeleteTrailingWS()
"augroup END

" Return to the last edit position when re-opening a file.
"augroup returnLastLine
"	autocmd!

"	autocmd BufReadPost *
"		\ if line("'\"") > 0 && line("'\"") <= line("$") |
"		\   exe "normal! g`\"" |
"		\ endif
"augroup END

" Search and replace support.
"function! VisualSelection(direction) range
"	let l:saved_reg = @"
"	execute "normal! vgvy"

"	let l:pattern = escape(@", '\\/.*$^~[]')
"	let l:pattern = substitute(l:pattern, "\n$", "", "")

"	if a:direction == 'b'
"		execute "normal ?" . l:pattern . "^M"
"	elseif a:direction == 'gv'
"		call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
"	elseif a:direction == 'replace'
"		call execute "%s/" . l:pattern . "/"
"	elseif a:direction == 'f'
"		execute "normal /" . l:pattern . "^M"
"	endif

"	let @/ = l:pattern
"	let @" = l:saved_reg
"endfunction

" Don't close this window when deleting a buffer.
"command! Bclose call <SID>BufcloseCloseIt()
"function! <SID>BufcloseCloseIt()
"	let l:currentBufNum = bufnr('%')
"	let l:alternateBufNum = bufnr('#')

"	if buflisted(l:alternateBufNum)
"		buffer #
"	else
"		bnext
"	endif

"	if bufnr('%') == l:currentBufNum
"		new
"	endif

"	if buflisted(l:currentBufNum)
"		execute 'bdelete! ' . l:currentBufNum
"	endif
"endfunction

" Mark the buffer in the current window for movement to a new window.
"function! MarkWindowSwap()
"	let g:markedWinNum = winnr()
"endfunction

" Mark the current window as the destination of the previously selected buffer and begin the process of swapping buffers between the two windows.
"function! DoWindowSwap()
"	"Mark destination buffer.
"	let curNum = winnr()
"	let curBuf = bufnr('%')
"	exe g:markedWinNum . "wincmd w"
"	" Switch to our source buffer and shuffle destination->source.
"	let markedBuf = bufnr("%")
"	" Hide and open so that we aren't prompted and insure our history is kept.
"	exe 'hide buf' curBuf
"	" Switch to our destination buffer and shuffle source->destination.
"	exe curNum . "wincmd w"
"	" Hide and open so that we aren't prompted and insure our history is kept.
"	exe 'hide buf' markedBuf
"endfunction

" Autocmds to automatically enter hex mode and handle file writes properly.
"augroup Binary
"	autocmd!

"	" Set binary option for all binary files before reading them.
"	autocmd BufReadPre *.bin,*.hex,*.exe,*.tar setlocal binary

"	" If on a fresh read the buffer variable is already set, it's wrong.
"	autocmd BufReadPost *
"		\ if exists('b:editHex') && b:editHex |
"		\   let b:editHex = 0 |
"		\ endif

"	" Convert to hex on startup for binary files automatically.
"	autocmd BufReadPost *
"		\ if &binary | :call ToggleHex() | endif

"	" When the text is freed the next time the buffer is made active it will re-read the text and thus not match the correct mode, we will need to convert it again if the buffer is again loaded.
"	autocmd BufUnload *
"		\ if getbufvar(expand('<afile>'), 'editHex') == 1 |
"		\   call setbufvar(expand('<afile>'), 'editHex', 0) |
"		\ endif

"	" Before writing a file when editing in hex mode, convert back to non-hex.
"	autocmd BufWritePre *
"		\ if exists('b:editHex') && b:editHex && &binary |
"		\  let oldro = &ro | let &ro = 0 |
"		\  let oldma = &ma | let &ma = 1 |
"		\  silent exe "%!xxd -r" |
"		\  let &ma = oldma | let &ro = oldro |
"		\  unlet oldma | unlet oldro |
"		\ endif

"	" After writing a binary file, if we're in hex mode, restore hex mode.
"	autocmd BufWritePost *
"		\ if exists('b:editHex') && b:editHex && &binary |
"		\  let oldro = &ro | let &ro = 0 |
"		\  let oldma = &ma | let &ma = 1 |
"		\  silent exe "%!xxd" |
"		\  exe "set nomod" |
"		\  let &ma = oldma | let &ro = oldro |
"		\  unlet oldma | unlet oldro |
"		\ endif
"augroup END

" Toggles hex mode. Hex mode should be considered a read-only operation. Save values for modified and read-only for restoration later and clear the read-only flag for now.
"function! ToggleHex()
"	let l:modified = &mod
"	let l:oldreadonly = &readonly
"	let &readonly = 0
"	let l:oldmodifiable = &modifiable
"	let &modifiable = 1

"	if !exists('b:editHex') || !b:editHex

"		" Save old options.
"		let b:oldft = &ft
"		let b:oldbin = &bin

"		" Set new options.
"		setlocal binary " Make sure it overrides any textwidth, etc.
"		let &ft = "xxd"

"		" Set status.
"		let b:editHex = 1

"		" Switch to hex editor.
"		%!xxd
"	else
"		" Restore old options.
"		let &ft = b:oldft

"		if !b:oldbin
"			setlocal nobinary
"		endif

"		" Set status.
"		let b:editHex = 0
"		" Return to normal editing.
"		%!xxd -r
"	endif

"	" Restore values for modified and read only state.
"	let &mod = l:modified
"	let &readonly = l:oldreadonly
"	let &modifiable = l:oldmodifiable
"endfunction

" Open the URI that is currently underneath the cursor in a browser.
"function! Browser ()
"	let line = getline('.')
"	let line = matchstr(line, "http[^   ]*")

"	" In Windows use Google Chrome.
"	if has('win32')
"		execute "!C:\Program Files (x86)\Google\Chrome\Application\chrome.exe --incognito " . line
"	" In a Unix like environment use a text-based browser such as Elinks.
"	elseif has('unix')
"		execute "!elinks " . line
"	endif
"endfunction

" Automatically insert header guards into new C++ header files.
"function! InsertHeaderGuard()
"	let gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
"	execute "normal! i#ifndef " . gatename
"	execute "normal! o#define " . gatename
"	execute "normal! Go#endif"
"	normal! kk
"endfunction

"====================================================
" Multi-Mode Mappings

" General options are define such that they are available within all operating modes. Also a collection of mappings usable within two or more modes are defined.
"====================================================

" Set a map leader so that extra key combinations can be used for quick operations.
let mapleader = ","
let g:mapleader = ","

" Map the semicolon character to the colon character to prevent the necessity of pressing <SHIFT+;> to enter command mode. Instead, with this map, pressing the semicolon key in any Vim mode will enter command mode.
"map ; :

" Use <F11> to toggle between 'paste' and 'nopaste' modes. 'paste' and 'nopaste' modes disable and enable auto-indenting respectively. Useful when pasting text that already posses the correct indenting, and you want to preserve that indention regardless of Vim's enabled auto-indent features.
"set pastetoggle=<F11>

" Manage spell check by supporting mappings that turn spell check on and off.
"nnoremap <silent> <F7> <ESC>:setlocal spell!<CR>
" Placing the letter 'i' at the end causes Vim to then return to insert mode after toggling the spell checker.
"inoremap <silent> <F7> <ESC>:setlocal spell!<CR>i
" Placing the letter 'v' at the end causes Vim to then return to visual mode after toggling the spell checker.
"vnoremap <silent> <F7> <ESC>:setlocal spell!<CR>v

" Re-map screen-256color key sequences for [Alt,CTRL,SHIFT]+[ARROW KEYS] to the appropriate control keys. This accounts for the fact that these key sequences are not automatically handled by Vim when running Vim inside of a screen application such as tmux. Vim is notified that the terminal it is running inside of is a 'screen', or 'screen-256color' terminal by either tmux or screen terminal multiplexers.
"if &term =~ '^screen'
"	execute "set <xUp>=\e[1;*A"
"	execute "set <xDown>=\e[1;*B"
"	execute "set <xRight>=\e[1;*C"
"	execute "set <xLeft>=\e[1;*D"

"	" Enable extended mouse reporting mode while within a Screen or TMUX session. By enabling extended mouse reporting mode for Screen and TMUX sessions, mouse click-and-drag works on Vim splits as expected.
"	" The ttymouse option changes what 'mouse codes' Vim will recognize. Setting this option to 'xterm2' is required when operating Vim within terminal multiplexers.
"	" Must be one of: xterm, xterm2, netterm, dec, jsbterm, pterm
"	set ttymouse=xterm2
"endif

" Start a browser instance loading the URI that is underneath the cursor.
"nnoremap <silent> <C-U> <ESC>:call Browser()<CR>
"inoremap <silent> <C-U> <ESC>:call Browser()<CR>
"vnoremap <silent> <C-U> <ESC>:call Browser()<CR>

" Enable Hex editing mode.
"nnoremap <silent> <C-H> <ESC>:call ToggleHex()<CR>
" Placing the letter 'i' at the end causes Vim to return to insert mode after toggling hex mode.
"inoremap <silent> <C-H> <Esc>:call ToggleHex()<CR>i
" Placing the letter 'v' at the end causes Vim to return to visual mode after toggling hex mode.
"vnoremap <silent> <C-H> <Esc>:call ToggleHex()<CR>i

" Enable the displaying of whitespace characters, including tab characters.
"nnoremap <silent> <F6> <ESC>:set list!<CR>
" Placing the letter 'i' at the end causes Vim to return to insert mode after toggling list mode.
"inoremap <silent> <F6> <ESC>:set list!<CR>i
" Placing the letter 'v' at the end causes Vim to return to visual mode after toggling list mode.
"vnoremap <silent> <F6> <ESC>:set list!<CR>v

" Instruct Vim to generate syntax highlight for the entire buffer, beginning from the start of the buffer.
"nnoremap <silent> <F12> <Esc>:syntax sync fromstart<CR>
" Placing the letter 'i' at the end causes Vim to return to insert mode after toggling syntax highlighting.
"inoremap <silent> <F12> <ESC>:syntax sync fromstart<CR>i
" Placing the letter 'v' at the end causes Vim to return to visual mode after toggling syntax highlighting.
"vnoremap <silent> <F12> <ESC>:syntax sync from start<CR>v

" Toggle all folds either open if one or more are closed.
"nnoremap <F9> zR
"inoremap <F9> <C-O>zR
"vnoremap <F9> zR

" Go to the definition of the text that lays below the cursor. This will cause Vim to load the file containing the definition of say a function or variable.
"nnoremap <silent> <C-D> <ESC><C-]>
"inoremap <silent> <C-D> <ESC><C-]>
"vnoremap <silent> <C-D> <ESC><C-]>

"====================================================
" Command-line Mode

" Useful mappings for command-line mode.
"====================================================

"====================================================
" Insert Mode

" Useful mappings for insert mode.
"====================================================

" Map the TAB key such that pressing TAB while the auto-complete menu is displayed causes the selected item from the menu to iterate to the next item. This effectively causes the TAB key to act as the next button (or down arrow key). The TAB key substitutes for the existing support afforded by CTRL+n.
"inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<C-g>u\<Tab>"

"====================================================
" Normal Mode

" Useful mappings for normal mode.
"====================================================

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy, which is the default.
"nnoremap Y y$

" Map <space> to /, for forward searching, and CTRL+<space> to ?, for backwards searching.
"nnoremap <space> /
"nnoremap <C-space> ?

" Remove the Window's ^M character when the encoding is messed up.
"nnoremap <leader>m mmHmt:%s/<C-V><CR>//ge<CR>'tzt'm

" Support switching between Vim splits using ALT and the arrow keys.
nnoremap <silent> <A-Up> :wincmd k<CR>
nnoremap <silent> <A-Down> :wincmd j<CR>
nnoremap <silent> <A-Left> :wincmd h<CR>
nnoremap <silent> <A-Right> :wincmd l<CR>

" Support the swapping of buffers between two windows. We support two options, using either the <leader> or a function key. <F3> Marks a buffer for movement and <F4> selects the second buffer of the swap pair and then executes the swap.
"nnoremap <silent> <leader>mw :call MarkWindowSwap()<CR>
"nnoremap <silent> <leader>pw :call DoWindowSwap()<CR>
"nnoremap <silent> <F3> :call MarkWindowSwap()<CR>
"nnoremap <silent> <F4> :call DoWindowSwap()<CR>

" Resize current window by +/- 3 rows/columns using CTRL and the arrow keys.
"nnoremap <silent> <C-Up> :resize +3<CR>
"nnoremap <silent> <C-Down> :resize -3<CR>
"nnoremap <silent> <C-Right> :vertical resize +3<CR>
"nnoremap <silent> <C-Left> :vertical resize -3<CR>

" Pressing CTRL-A selects all text within the current buffer.
"nnoremap <C-A> gggH<C-O>G

"====================================================
" Select Mode

" Useful mappings for select mode.
"====================================================

" Pressing CTRL-C and CTRL-Insert copies the selected text.
"snoremap <C-C> <C-O>"+y

"====================================================
" Visual Mode

" Useful mappings for visual mode.
"====================================================

" Search and replace the selected text.
"vnoremap <silent> <leader>r :call VisualSelection('replace')<CR>

" Pressing * or # while in normal mode searches for the current selection. '*' searches forward while '#' searches backwards.
"vnoremap <silent> 8 :call VisualSelection('f')<CR>
"vnoremap <silent> 3 :call VisualSelection('b')<CR>

" Pressing gv uses vimgrep after the selected text.
"vnoremap <silent> gv :call VisualSelection('gv')<CR>

" Enable Hex editing mode.
"vnoremap <C-H> :<C-U>ToggleHex()<CR>

" Pressing backspace will delete the character to the left of the cursor.
"vnoremap <backspace> d

" Pressing CTRL-A selects all text within the current buffer.
"vnoremap <C-A> ggVG

"====================================================
" Block Commenting

" These options and commands support commenting and uncommenting large source code blocks based on language.
"====================================================

" Map filetypes to comment delimiters.
"augroup programmingLanguageComments
"	autocmd!

"	autocmd FileType haskell,vhdl,ada let b:comment_leader = '-- '
"	autocmd FileType vim let b:comment_leader = '" '
"	autocmd FileType c,cpp,java,javascript,php let b:comment_leader = '// '
"	autocmd FileType fql,fqlut let b:comment_leader = '\\ '
"	autocmd FileType sh,make let b:comment_leader = '# '
"	autocmd FileType tex let b:comment_leader = '% '
"augroup END

" Define comment functions to map comment to 'cc' and uncomment to 'uc' in visual and normal mode.
"nnoremap <silent> cc :<C-B>sil <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:noh<CR>
"vnoremap <silent> cc :<C-B>sil <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:noh<CR>
"nnoremap <silent> uc :<C-B>sil <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:noh<CR>
"vnoremap <silent> uc :<C-B>sil <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:noh<CR>

"====================================================
" Setup Omni Complete Plugin and Other Language Tools

" Setup for Omni Completion to facilitate auto-completion support and to further configure language-specific helper tools.
"====================================================

" Configure pop-up menu to auto-select based on order of options.
"set completeopt=menuone,menu,longest,preview

" Set the default tag file to equal the name of the file that is generated as a result of the UpdateTags() function. If a tag file not exist within the directory containing the file that is being edited by Vim then it is simply not used. No negative effects occur.
"set tags+=./tags

" Use binary search to search a tags file for matching patterns. Assumes the tags file was sorted on ASCII byte value. If no match is found during an initial search, Vim will switch to a linear search and re-scan the tags file. OPTIMIZATION: Requires tags files to be sorted by Ctags using the 'foldcase' option and requires Vim to have 'ignorecase' option set. Optimization will insure all matching tags are found, while still supporting binary search. See ":help tagbsearch".
"set tagbsearch

" Enable a Vim option to remember which tags were jumped to, and from where. The tagstack list shows the tags that were jumped to and the cursor position right before the jump.
"set tagstack

" GENERIC LANGUAGE SUPPORT

" Enable default auto complete support in Vim. Will force Vim to select the appropriate auto complete tool based on filetype.
"set omnifunc=syntaxcomplete#Complete

" C SUPPORT.

" Enable C Omni Complete on C source and header files.
"augroup cSupport
"	autocmd!

"	autocmd FileType c set omnifunc=ccomplete#Complete " Default Omni Complete line for enabling Omni Complete for C files.
"augroup END

" C++ SUPPORT.

"augroup cppSupport
"	autocmd!

"	" Enable C++ Omni Complete on C++ source and header files.
"	autocmd FileType cpp set omnifunc=omni#cpp#complete#Main " Override built-in C Omni Complete with C++ OmniCppComplete plugin.

"	" Automatically insert header guards into new C++ header files.
"	autocmd BufNewFile *.{h,hpp} call InsertHeaderGuard()
"augroup END

"let OmniCpp_GlobalScopeSearch = 1	" Search for functions starting from the global scope and narrowing down from there.
"let OmniCpp_NamespaceSearch = 1		" Search for functions within the current file and all included files.
"let OmniCpp_ShowAccess = 1			" Show access modifier (private(-), public(#), or protected(#)).
"let OmniCpp_DisplayMode = 1			" Show all members: static, public, protected, and private.
"let OmniCpp_ShowScopeInAbbr = 1		" Show namespace, such as the class, that defines the function.
"let OmniCpp_ShowPrototypeInAbbr = 1 " Show prototype (argument types).
"let OmniCpp_MayCompleteDot = 1		" Autocomplete after .
"let OmniCpp_MayCompleteArrow = 1	" Autocomplete after ->
"let OmniCpp_MayCompleteScope = 1	" Autocomplete after ::
"let OmniCpp_SelectFirstItem = 2		" Select first item within the pop-up menu. (1 = Insert option into text, 2 = Select but don't insert into text)
"let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"] " Omni Complete will include the following namespaces by default, without first requiring the namespaces to be specified.

" List OmniCppComplete tag database files.
"if has('unix')
"	set tags+=~/.vim/tags/stl " STL C++ tag database file.
"endif

" Enable the display of space errors for C and C++ files. Space errors are caused by the inclusion of excessive white space on blank lines or as trailing white space. Space errors are shown as highlighted character blocks.
"let c_space_errors = 1

" Highlight strings inside C comments. Therefore, the use of "string" inside of a C comment will cause the entire "string" to receive a special highlighting color.
"let c_comment_strings = 1

" PYTHON SUPPORT.

"augroup pythonSupport
"	autocmd!

"	" Enable Python Omni Complete on Python files.
"	autocmd FileType python set omnifunc=pythoncomplete#Complete

"	" Expand each tab insert into the number of spaces specified by the `shiftwidth` option.
"	autocmd FileType python setlocal expandtab
"augroup END

" Enable the display of space errors for Python files. Space errors are caused by the inclusion of excessive white space on blank lines or as trailing white space. Space errors are shown as highlighted character blocks.
"let python_space_errors = 1

" RUBY SUPPORT.

"augroup rubySupport
"	autocmd!

"	" Enable Ruby Omni Complete on Ruby and eRuby files.
"	autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
"augroup END

"let g:rubycomplete_buffer_loading = 1		" Show buffer/rails/global members.
"let g:rubycomplete_rails = 1				" Enable Ruby on Rails support.
"let g:rubycomplete_classes_in_global = 1	" Show classes in global completions.

" Enable the display of space errors for Ruby files. Space errors are caused by the inclusion of excessive white space on blank lines or as trailing white space. Space errors are shown as highlighted character blocks.
"let ruby_space_errors = 1

" PHP SUPPORT.

"augroup phpSupport
"	autocmd!

"	" Instruct Vim to treat *.phtml files as PHP source code files.
"	autocmd BufNewFile,BufRead *.phtml set syntax=php
"augroup END

" JAVASCRIPT SUPPORT.

"augroup javascriptSupport
"	autocmd!

"	" Enable JavaScript Omni Complete on JavaScript files.
"	autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS

"	" Set the initial fold level for JavaScript files to level 2, rather than the default of maximum folding, a.k.a. level 1. Most JavaScript files begin with `define([], function () {});`. That syntax would, under the default fold level, cause the entire file to be folded into a single line. That level of folding hides everything meaningful, such as functions and objects defined within the confines of a `define` wrapper.
"	autocmd FileType javascript set foldlevel=2
"augroup END

" HTML SUPPORT.

"augroup htmlSupport
"	autocmd!

"	" Enable HTML Omni Complete on HTML file.
"	autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
"augroup END

" CSS SUPPORT.

"augroup cssSupport
"	autocmd!

"	" Enable CSS Omni Complete on CSS files.
"	autocmd FileType css set omnifunc=csscomplete#CompleteCSS
"augroup END

" Markdown SUPPORT

"augroup markdownSupport
"	autocmd!

"	" Instruct Vim to treat files ending in the following extensions as Markdown files. This must be done within our vimrc file because Vim's runtime files treat *.md files as Module-2 files; thereby applying unexpected syntax highlighting (Because I assume files ending in *,md are Markdown files.).
"	autocmd BufRead,BufNewFile *.{md} set filetype=markdown
"	autocmd BufRead,BufNewFile *.{md}.{des3,des,bf,bfa,aes,idea,cast,rc2,rc4,rc5,desx} set filetype=markdown
"augroup END

" JSON SUPPORT

"augroup jsonSupport
"	autocmd!

"	" Instruct Vim to treat files ending in the following extension as JSON files. This must be done within our vimrc file because Vim's runtime files treat *.json files as JavaScript files; thereby applying unexpected syntax highlighting, and attempting to apply JavaScript style rules to JSON content (Which already has a well defined set of rules).
"	autocmd BufRead,BufNewFile *.{json} set filetype=json
"augroup END

" OTHER SUPPORT.

" Change the default auto-complete pop-up window color scheme from pink to a custom scheme using Black for the background, Cyan for each entry in the dropdown, and Green for the item currently under focus..
"highlight clear
"highlight Pmenu ctermfg=Cyan ctermbg=Black guifg=Cyan guibg=Black gui=bold
"highlight PmenuSel ctermfg=Green ctermbg=Black guifg=Green guibg=Black gui=bold
"highlight PmenuSbar ctermfg=White ctermbg=Green guifg=White guibg=Green gui=bold
"highlight PmenuThumb ctermfg=White ctermbg=Green guifg=White guibg=Green gui=bold

" Update, or create, a tag database file for source code contained within the directory, and recursively within sub-directories, that Vim was opened.
"function! UpdateTags()
"	execute ":silent !ctags --recurse=yes --sort=foldcase --languages=C++ --c++-kinds=+p --fields=+iaS --extra=+fq ./"
"	execute ":redraw!"
"	echohl StatusLine | echo "C/C++ Tags Updated" | echohl None
"endfunction
"nnoremap <silent> <F5> <ESC>:call UpdateTags()<CR>
"inoremap <silent> <F5> <ESC>:call UpdateTags()<CR>i
"vnoremap <silent> <F5> <ESC>:call updateTags()<CR>v

"====================================================
" Setup ctrlp Plugin

" Setup for a tool that allows for fuzzy matching on file names within the current directory, or parent directory containing a repository directory, or against opened buffers, or MRU (Most Recently Used) files.
"====================================================

" Set the default behavior for the CtrlP plugin to search against files only (not against the buffers or MRU).
"let g:ctrlp_cmd = 'CtrlP'

" Directory ignore list:
" * .git/.hg/.svn - Source Code Management storage directories.
" * node_modules - Directory to house Node modules.
" * bower_components - Directory to house Bower components.
" * dist/bin/build - Common directories used to house build artifacts.
" * _book - Build artifact cache used by `gitbook`.
" * venv - The prefered Python virtual environment directory.
" * .tox - Cache directory used by `tox`.
" * coverage - Output directory for generated coverage reports.
" * .temp - Cache directory we use for Yeoman unit tests.
"let g:ctrlp_custom_ignore = {
"	\ 'dir':  '\v[\/](\.git|\.hg|\.svn|node_modules|bower_components|dist|bin|build|_book|venv|\.tox|coverage|\.temp)$',
"	\ 'file': '\v\.(pyc|pyo|a|exe|dll|so|o|min.js|zip|7z|gzip|gz|jpg|png|gif|avi|mov|mpeg|doc|odt|ods)$'
"	\ }

" Set the maximum depth of a directory tree to recurse into.
"let g:ctrlp_max_depth = 20

" Set the maximum number of files to scan into the CtrlP cache for fuzzing matching.
"let g:ctrlp_max_files = 10000

" Set the option to require CtrlP to scan for dotfiles and dotdirs.
"let g:ctrlp_show_hidden = 1

"====================================================
" Setup vim-airline Plugin

" Setup for a vim-airline environment so that the environment will look and behave in the desired way.
"====================================================

" Enable vim-airline's buffer status bar. This buffer status bar will appear at the very top of Vim, similiar to where the multibufexpl plugin would appear.
let g:airline#extensions#tabline#enabled = 1

" Automatically populate the `g:airline_symbols` dictionary with the correct font glyphs used as the special symbols for vim-airline's status bar.
let g:airline_powerline_fonts = 1

" Set airline theme to match the Vim editor theme.
let g:airline_theme = 'one'

" Correct a spacing issue that may occur with fonts loaded via the fontconfig approach.
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"

"====================================================
" Setup vim-indent-guides Plugin

" Setup for Indent Guide plugin to place special color highlighting to the left of code to indicate indentation level.
"====================================================

" Enable the indent guide plugin on Vim startup. This will cause indentations to be highlighted automatically when opening up a file into a Vim buffer.
"let g:indent_guides_enable_on_vim_startup = 0

" Indicate which indentation level to begin showing guides.
"let g:indent_guides_start_level = 2

" Set the width of the indent guide to be one space in width. Only applies when indentation consists of spaces.
"let g:indent_guides_guide_size = 1

"====================================================
" Setup vim-javascript-syntax Plugin

" Setup for JavaScript Syntax plugin to place special color highlighting to the left of code to indicate indentation level.
"====================================================

" Enable JavaScript code folding using the vim-javascript-syntax plugin.
"augroup javascriptFolding
"	autocmd!

"	autocmd FileType javascript call JavaScriptFold()
"augroup END

"====================================================
" Setup vim-json Plugin

" Setup for working with JSON files, including proper syntax highlighting and error detection.
"====================================================

" Disable concealment of double quotes within JSON files.
"let g:vim_json_syntax_conceal = 0

"====================================================
" Setup vim-scratch Plugin

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
" Setup vim-signify Plugin

" Setup for the Signify plugin that adds the +, -, and ~ characters in the "gutter", a.k.a left sidebar, of Vim to indicate when lines have been added, removed, or modified as compared against a file managed by a VCS.
"====================================================

" Mapping for jumping around in a buffer between next, or previous, change hunks.
nmap <leader>gj <plug>(signify-next-hunk)
nmap <leader>gk <plug>(signify-prev-hunk)

" Use alternative signs for various states of a line under version control.
let g:signify_sign_change = '~'

" Update line status more quickly.
set updatetime=100

"====================================================
" Setup syntastic Plugin

" Setup for the Syntastic plugin so that it knows how to behave for each software language filetype. Additional configuration can be included in this section to, for example, specify the tool that should be used to check a particular filetype for lint issues.
"====================================================

" C++

" Set our preferred lint checker to CppChecker.
"let g:syntastic_cpp_checkers = ['cppcheck']

" JavaScript

" Set our preferred static analysis chcker to JsHint, and style checker, the fallback checker, to jscs.
"let g:syntastic_javascript_checkers = ['jshint', 'jscs']

" JSON

" Set our preferred JSON validator to JSONLint.
"let g:syntastic_json_checkers = [ 'jsonlint' ]

" PYTHON

" Set our preferred lint checker to PEP8, with a fallback to PyLint if the PEP8 checker fails to find any issues.
"let g:syntastic_python_checkers = ['pep8', 'pylint']

" YAML

" Set our preferred lint checker to JSYAML.
"let g:syntastic_yaml_checkers = ['jsyaml']

"====================================================
" Setup tagbar Plugin

" Setup for Tagbar allowing a sidebar to display Ctags relevant to the current file.
"====================================================

" Toggle the Tagbar window on or off in normal and insert modes.
"nnoremap <silent> <F8> <ESC>:TagbarToggle<CR>
" Placing the letter 'i' at the end causes the Tagbar to be turned on/off and for Vim to then return to insert mode.
"inoremap <silent> <F8> <ESC>:TagbarToggle<CR>i
" Place the letter 'v' at the end causes the Tagbar to be turned on/off and for Vim to then return to visual mode.
"vnoremap <silent> <F8> <ESC>:TagbarToggle<CR>v

" Enable Tagbar support for Markdown files by configuring Tagbar to use a special script that's capable of generating the required Ctag information necessary for Tagbar to render a tree view of the current file's headings.
"let g:tagbar_type_markdown = {
"	\ 'ctagstype': 'markdown',
"	\ 'ctagsbin' : '~/.vim/markdown2ctags.py',
"	\ 'ctagsargs' : '-f - --sort=yes',
"	\ 'kinds' : [
"		\ 's:sections',
"		\ 'i:images'
"	\ ],
"	\ 'sro' : '|',
"	\ 'kind2scope' : {
"		\ 's' : 'section',
"	\ },
"	\ 'sort': 0,
"\ }

"====================================================
" Setup tern_for_vim Plugin

" Setup the `tern_for_vim` plugin to allow intelligent parsing of JavaScript code for extraction of meta information; such as function argument lists, argument types, object properties, etc.
"====================================================

" Display argument type hints when the cursor is left over a function identifier. Type information is displayed in the command/mode line at the bottom of Vim.
"let g:tern_show_argument_hints = 'on_hold'

" Enable support for the key mappings defined by this plugin. These key mappings are available through the use of the <leader> key. For a full list of available key mappings please see: http://usevim.com/files/tern_keyboard.pdf
"let g:tern_map_keys = 1

"====================================================
" Setup Colorscheme

" Setup Vim to recognize our terminal as having a particular background color, and then set our preferred color scheme (a.k.a theme).

" Note: This setup step must be last so that the color scheme is setup properly. If configured earlier, some setting in this configuration file will cause Vim to revert to its default color scheme (or worse, you'll get a collision of multiple color schemes.).
"====================================================

" Inform Vim to expect a dark terminal background. This will cause Vim to compensate by altering the color scheme.
set background=dark

" Enable support for italics in the One theme.
let g:one_allow_italics = 1

" Set Vim's color scheme. We purposely silence any failure notification if the desired colorscheme can't be loaded by Vim. If Vim is unable to load the desired colorscheme, it will be quite apparent to the user. By silencing error messages we gain the ability to automate tasks, such as installing plugins for the first time, that would otherwise block if an error message was displayed because the desired colorscheme wasn't available.
silent! colorscheme one
" highlight Normal ctermbg=NONE " Uncomment if you want to unset a background color and defer to your terminal.

"====================================================
" Spellcheck Highlighting

" Setup Vim to use our own highlighting rules for words not recognized by Vim based on the `spelllang` setting. These highlight rules must be set _after_ a theme has been selected using `colorscheme`.

" SpellBad: word not recognized
" SpellCap: word not capitalized
" SpellRare: rare word
" SpellLocal: wrong spelling for selected region, but spelling exists in another region for given language.
"====================================================

" Clear existing highlighting rules used to make a spelling mistake stand out in text. The existing highlight rules must be cleared to correctly apply our custom rules.
highlight clear SpellBad
highlight clear SpellCap
highlight clear SpellRare
highlight clear SpellLocal

" Set our own highlighting rules for Vim's spell checking.
" We use `undercurl` to use squiggles under highlighted words when that option is available (gvim only). Otherwise words are simply underlined.
highlight SpellBad   term=undercurl cterm=undercurl ctermfg=Red
highlight SpellCap   term=undercurl cterm=undercurl ctermfg=Yellow
highlight SpellRare  term=undercurl cterm=undercurl ctermfg=Magenta
highlight SpellLocal term=undercurl cterm=undercurl ctermfg=Blue
