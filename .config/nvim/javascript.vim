" Configure tab/space behavior.
augroup javascript-expand
	autocmd!

	" Configure spaces to be inserted in place of tabs when the TAB key is pressed. To disable this behavior and enable the insertion of tabs when the Tab key is pressed, comment out this option.
	autocmd Filetype javascript setlocal expandtab
augroup END

" Configure the use of Omnicomplete for JavaScript source files.
augroup javascript-omnicomplete
	autocmd!

	" Enable JavaScript Omni Complete on JavaScript files.
	autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
augroup END

" Configure code folding.
augroup javascript-fold
	autocmd!

	" Set the initial fold level for JavaScript files to level 2. Most JavaScript files begin with `define([], function () {});`. That syntax would, under the default fold level, cause the entire file to be folded into a single line. That level of folding hides everything meaningful, such as functions and objects defined within the confines of a `define` wrapper.
	autocmd FileType javascript set foldlevel=2
augroup END

" Define comment delimiter.
augroup javascript-comments
	autocmd!

	autocmd FileType javascript let b:comment_leader = '//'
augroup END

"====================================================
" Setup vim-javascript-syntax Plugin
"
" Setup for JavaScript Syntax plugin to place special color highlighting to the left of code to indicate indentation level.
"====================================================

" Enable JavaScript code folding using the vim-javascript-syntax plugin.
augroup javascript-folding
	autocmd!

	autocmd FileType javascript call JavaScriptFold()
augroup END

"====================================================
" Setup tern_for_vim Plugin
"
" Setup the `tern_for_vim` plugin to allow intelligent parsing of JavaScript code for extraction of meta information; such as function argument lists, argument types, object properties, etc.
"====================================================

" Display argument type hints when the cursor is left over a function identifier. Type information is displayed in the command/mode line at the bottom of Vim.
let g:tern_show_argument_hints = 'on_hold'

" Enable support for the key mappings defined by this plugin. These key mappings are available through the use of the <leader> key. For a full list of available key mappings please see: http://usevim.com/files/tern_keyboard.pdf
let g:tern_map_keys = 1

"====================================================
" Setup syntastic Plugin
"====================================================

" Set our preferred static analysis checker to JSHint, and style checker, the fallback checker, to JSCS.
let g:syntastic_javascript_checkers = ['jshint', 'jscs']
