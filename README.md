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

## Contribute

### Clone Repository

Clone the repository to a suitable location where you can extend and test this repository.

```bash
git clone https://github.com/hbetts/dotfiles.git
```

**Note:** This will clone the entire contents of the repository at the HEAD revision.

To update the project from within the project's folder you can run the following command:

```bash
git pull
```

### Feature Requests

I'm always looking for suggestions to improve these files. If you have a suggestion for improving an existing feature, or would like to suggest a completely new feature, please file an issue with my [GitHub repository](https://github.com/hbetts/dotfiles/issues).

### Bug Reports

My configuration files and scripts aren't always perfect, but I strive to always improve on that work. You may file bug reports on the [GitHub repository](https://github.com/hbetts/dotfiles/issues) site.

### Pull Requests

Along with my desire to hear your feedback and suggestions, I'm also interested in accepting direct assistance in the form of new configuration options and scripts.

You may file merge requests against my [GitHub repository](https://github.com/hbetts/dotfiles/pulls).
