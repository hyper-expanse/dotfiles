# dotfiles

This repository contains a collection of configuration files used by various tools to establish expected, and desired, functionality. These dotfiles are predominately written for tools used in a POSIX-compliant shell environment.

## Install

Installation is as simple as copying these files into your home directory, or cloning the repository to a suitable location and then creating symlinks from the repository files into your home directory.

Clone the repository to a suitable location:

```bash
git clone https://github.com/hbetts/dotfiles.git
```

Navigate into the directory containing the cloned repository. Once there, run the deployment script to symlink the files into your home directory. The symbolic links will have names matching the names of the files in the repository.

```bash
bash deploy.sh
```

**Note:** Directories in this repository will not be symlinked, nor will the files contained within them. You will need to symlink those files yourself.

## Test

No tests exist for the contents of this repository. Please feel free to suggest approaches for testing its contents, or file a merge request with a test implementation.
