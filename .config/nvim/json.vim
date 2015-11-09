" Configure filetype.
augroup json-filetype
	autocmd!

	" Instruct Vim to treat files ending in the following extension as JSON files. This must be done within our vimrc file because Vim's runtime files treat *.json files as JavaScript files; thereby applying unexpected syntax highlighting, and attempting to apply JavaScript style rules to JSON content (Which already has a well defined set of rules).
	autocmd BufRead,BufNewFile *.{json} set filetype=json
augroup END

" Configure code folding.
augroup json-fold
	autocmd!

	" Set the initial fold level for JSON files to level 2.
	autocmd FileType json set foldlevel=1
augroup END

"====================================================
" Setup vim-json Plugin
"
" Setup for working with JSON files, including proper syntax highlighting and error detection.
"====================================================

" Disable concealment of double quotes within JSON files.
let g:vim_json_syntax_conceal = 0

"====================================================
" Setup syntastic Plugin
"====================================================

" Set our preferred JSON validator to JSONLint.
let g:syntastic_json_checkers = [ 'jsonlint' ]
