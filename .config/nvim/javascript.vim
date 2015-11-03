" Configure spaces to be inserted in place of tabs when the TAB key is pressed. To disable this behavior and enable the insertion of tabs when the Tab key is pressed, comment out this option.
augroup javascript-expand
	autocmd!

	autocmd Filetype javascript setlocal expandtab
augroup END

" Configure the use of Omnicomplete for JavaScript source files.
augroup javascript-omnicomplete
	autocmd!

	" Enable JavaScript Omni Complete on JavaScript files.
	autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS

	" Set the initial fold level for JavaScript files to level 2, rather than the default of maximum folding, a.k.a. level 1. Most JavaScript files begin with `define([], function () {});`. That syntax would, under the default fold level, cause the entire file to be folded into a single line. That level of folding hides everything meaningful, such as functions and objects defined within the confines of a `define` wrapper.
	autocmd FileType javascript set foldlevel=2
augroup END
