# Terminal Text Editor (vim)

As a powerful text editor Vim gives the user the power to leverage the VIM environment to edit text as easily as a GUI-based text editor but with the additional power of a full Integrated Development Environment.

**Note:** These instructions are only applicable to the Vim configuration of a single individual. For a multi-user environment these instructions must be repeated for each user that wants Vim configured in this manner.

## Package Installation

To configure Vim as a fully functional text editor and integrated development environment we must install pre-written Vim scripts that bring additional functionality into the editor. These scripts are downloaded from public repositories and unpacked into the Vim configuration folder. A generic approach is taken whenever possible, but in some instances installation instructions have been included for specific operating systems.

We do not install Vim from the Debian repository, but instead, rely upon the version of Vim installed through Linxuxbrew via the `brew install vim --head` command baked into our `setupEnvironment` script.

## Configuration

To begin we setup a default Vim configuration file to provide some standard features and behaviors that could be leveraged by software developers.

Configuration is managed by the `${HOME}/.vimrc` file from the personal dotfiles repository.

## Omni Complete

Omni Complete affords the ability to auto-complete C/C++ syntax based on the Standard Template Library and any local source code.

### Script

Omni Complete for C++ auto completion must be added to Vim as it is not part of the default installation. This work was originally described in \cite{1}.

The latest version of the Omni CPP Complete script is pulled from the vim-scripts Github repository through the inclusion of the Vundle 'Plugin' statement in the vimrc file.

### C++ Source Code

We need to download a modified version of the C++ STL header files so that a Ctags tag database can be generated.

Download the C++ STL headers:
* http://www.vim.org/scripts/script.php?script_id=2358

Extract the archive into the Vim tags folder:
* ~/.vim/tags

Then rename the extracted folder, "cpp_src", to "stl_src":
* mv ~/.vim/tags/cpp_src ~/.vim/tags/stl_src

Navigate into the tags folder:
* cd ~/.vim/tags

Lastly, run Ctags (which should have been installed via `brew install ctags`) to build the tags database:
* ctags -R --sort=foldcase --c++-kinds=+pl --fields=+iaS --extra=+q --language-force=C++ -f stl stl_src

**Note:** On Windows use the downloaded Ctags executable to build the Ctags database. Do NOT use the Ctags application that comes with Cygwin.

### Examples

After installation and configuration of Omni Complete, auto-complete should work immediately in C/C++ files.

To use begin a standard C++ syntax:

```cpp
std::
```

After completing the initial C++ syntax a box will open with suggestions to complete the call.

Both meta-commands <C-N> and <C-P> can be used to navigate the list of auto-complete options. To open the suggestion box manually use: <C-X><C-O>.

In addition to a list box of auto-complete options, a window will appear above the current Vim window. Within this window will be the full signature of the function.

### References

* http://vim.wikia.com/wiki/VimTip1608

### Notes

For generating tags for other libraries:

* ctags -R --sort=foldcase --c++-kinds=+pl --fields=+iaS --extra=+q --language-force=C++ -f gl /usr/include/GL/
* ctags -R --sort=foldcase --c++-kinds=+pl --fields=+iaS --extra=+q --language-force=C++ -f sdl /usr/include/SDL/
* ctags -R --sort=foldcase --c++-kinds=+pl --fields=+iaS --extra=+q --language-force=C++ -f qt4 /usr/include/qt4/

If a Ctags database needs to be generated for local variable within the current code base just add the '+l' (Letter "l" from local.) to the c++-kinds argument as shown:

* map <C-F12> :!ctags -R --sort=foldcase --c++-kinds=+pl --fields=+iaS --extra=+q .<CR>

At this time Omni Completion does not work with boost shared pointers.
