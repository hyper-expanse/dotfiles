" Configure tab/space behavior.
augroup javascript-expand
	autocmd!

	" Configure spaces to be inserted in place of tabs when the TAB key is pressed. To disable this behavior and enable the insertion of tabs when the Tab key is pressed, comment out this option.
	autocmd Filetype javascript setlocal expandtab
augroup END

" Configure code folding.
augroup javascript-fold
	autocmd!

	" Set the fold level to a high number to effectively disable code folding.
	autocmd FileType javascript set foldlevel=10000
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
" Setup vim-jsdoc Plugin
"
" Setup for JsDoc plugin to build documentation for a function based on context information and user input.
"====================================================

" Allow interactive prompting for input.
let g:jsdoc_allow_input_prompt = 1

" Turn on access tags such as `@private` and `@public`.
let g:jsdoc_access_descriptions = 2

" Turn on detecting a function starting with an underscore as a private function.
let g:jsdoc_underscore_private = 1

" Support ECMAScript 6 function definition syntax.
let g:jsdoc_allow_shorthand = 1

"====================================================
" Setup syntastic Plugin
"====================================================

" Set our preferred static analysis checker to JSHint, and style checker, the fallback checker, to JSCS.
let g:syntastic_javascript_checkers = ['jshint', 'jscs']
