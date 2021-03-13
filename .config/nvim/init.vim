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

Plug 'https://github.com/ctrlpvim/ctrlp.vim.git'
Plug 'https://github.com/preservim/nerdtree.git'
"Plug 'https://github.com/scrooloose/syntastic.git'
Plug 'https://github.com/mbbill/undotree.git'
Plug 'https://github.com/vim-airline/vim-airline.git' " At the time of writing Powerline (Python) does not support neovim.
Plug 'https://github.com/vim-airline/vim-airline-themes.git'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'https://github.com/tpope/vim-fugitive.git'
Plug 'https://github.com/rakr/vim-one.git'
Plug 'https://github.com/mhinz/vim-signify.git'
Plug 'https://github.com/ryanoasis/vim-devicons.git'

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

"====================================================
" Multi-Mode Mappings

" General options are define such that they are available within all operating modes. Also a collection of mappings usable within two or more modes are defined.
"====================================================

" Set a map leader so that extra key combinations can be used for quick operations.
let mapleader = ","
let g:mapleader = ","

" Use <F11> to toggle between 'paste' and 'nopaste' modes. 'paste' and 'nopaste' modes disable and enable auto-indenting respectively. Useful when pasting text that already posses the correct indenting, and you want to preserve that indention regardless of Vim's enabled auto-indent features.
set pastetoggle=<F11>

" Manage spell check by supporting mappings that turn spell check on and off.
nnoremap <silent> <F7> <ESC>:setlocal spell!<CR>
" Placing the letter 'i' at the end causes Vim to then return to insert mode after toggling the spell checker.
inoremap <silent> <F7> <ESC>:setlocal spell!<CR>i
" Placing the letter 'v' at the end causes Vim to then return to visual mode after toggling the spell checker.
vnoremap <silent> <F7> <ESC>:setlocal spell!<CR>v

" Enable the displaying of whitespace characters, including tab characters.
nnoremap <silent> <F6> <ESC>:set list!<CR>
" Placing the letter 'i' at the end causes Vim to return to insert mode after toggling list mode.
inoremap <silent> <F6> <ESC>:set list!<CR>i
" Placing the letter 'v' at the end causes Vim to return to visual mode after toggling list mode.
vnoremap <silent> <F6> <ESC>:set list!<CR>v

" Toggle all folds either open if one or more are closed.
nnoremap <F9> zR
inoremap <F9> <C-O>zR
vnoremap <F9> zR

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

nnoremap <silent> <F2> :UndotreeToggle<CR>

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
" Setup ctrlp Plugin

" Setup for a tool that allows for fuzzy matching on file names within the current directory, or parent directory containing a repository directory, or against opened buffers, or MRU (Most Recently Used) files.
"====================================================

" Set the default behavior for the CtrlP plugin to search against files only (not against the buffers or MRU).
let g:ctrlp_cmd = 'CtrlP'

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
let g:ctrlp_custom_ignore = {
	\ 'dir':  '\v[\/](\.git|\.hg|\.svn|node_modules|dist|bin|build|_book|venv|\.tox|coverage|\.temp)$',
	\ 'file': '\v\.(pyc|pyo|a|exe|dll|so|o|min.js|zip|7z|gzip|gz|jpg|png|gif|avi|mov|mpeg|doc|odt|ods)$'
	\ }

" Set the option to require CtrlP to scan for dotfiles and dotdirs.
let g:ctrlp_show_hidden = 1

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
" Setup vim-go Plugin

" Setup for a vim-go environment so that the environment will look and behave in the desired way.
" More options and recommendations available from - https://github.com/fatih/vim-go/wiki/Tutorial#edit-it
"====================================================

" Automatically add missing imports on file save while also formatting the file like `gofmt` used to do.
let g:go_fmt_command = "goimports"

" Enable syntax highlighting available through `vim-go`. This feature must be manually enabled as it may signficantly impact the performance of Vim.
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_generate_tags = 1

" Automatically invoke the `:GoMetaLinter` command on file save, which invokes `vet`, `golint`, and `errcheck` concurrently by default.
let g:go_metalinter_autosave = 1

" Automatically show the function signature on the status line when moving your cursor over a valid identifier.
let g:go_auto_type_info = 1

" Switch to AST-aware identifier renamer that is module aware (No GOPATH necessary).
let g:go_rename_command = "gopls"

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
