" Configure tab/space behavior.
augroup python-expand
	autocmd!

	" Configure spaces to be inserted in place of tabs when the TAB key is pressed. To disable this behavior and enable the insertion of tabs when the Tab key is pressed, comment out this option.
	autocmd FileType python setlocal expandtab
augroup END

" Configure the use of Omnicomplete for Python source files.
augroup python-omnicomplete
	autocmd!

	" Enable Python Omni Complete on Python files.
	autocmd FileType python set omnifunc=pythoncomplete#Complete
augroup END

" Enable the display of space errors for Python files. Space errors are caused by the inclusion of excessive white space on blank lines or as trailing white space. Space errors are shown as highlighted character blocks.
let python_space_errors = 1

"====================================================
" Setup syntastic Plugin
"====================================================

" Set our preferred lint checker to PEP8, with a fallback to PyLint if the PEP8 checker fails to find any issues.
let g:syntastic_python_checkers = ['pep8', 'pylint']
