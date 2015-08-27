# dotfiles

This repository contains a collection of configuration files used by various tools to establish expected, and desired, functionality. These dotfiles are predominately written for tools used in a POSIX-compliant shell environment.

* Documentation: projects.hyper-expanse.net/dotfiles

## Installation

Installation is as simple as copying these files into your home directory, or cloning the repository to a suitable location and then creating symlinks from the repository files into your home directory.

Clone the repository to a suitable location:

```bash
git clone https://github.com/hbetts/dotfiles.git ${HOME}/.dotfiles
```

Navigate into the directory containing the cloned repository. Once there, run the deployment script to symlink the files into your home directory. The symbolic links will have names matching the names of the files in the repository.

```bash
sh deploy.sh"
```

Once deployed the `${HOME}/.profile` script will need to be sourced, just once, to expose the scripts contained within the dotfiles repository. To source the profile script run the following command:

```bash
setupEnvironment
```

## Cheat sheats

Tmux

* http://stevehhh.com/tmux-quick-reference/
* https://gist.github.com/afair/3489752

Vim

* http://tnerual.eriogerg.free.fr/vim.html
* http://michael.peopleofhonoronly.com/vim/

## Contributing

Read [CONTRIBUTING](CONTRIBUTING.md).

## License

Copyright 2014 Hutson Betts

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
