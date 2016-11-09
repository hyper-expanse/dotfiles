# Install dotfiles project.

wget https://gitlab.com/hyper-expanse/dotfiles/repository/archive.tar.gz?ref=installation -O "/tmp/dotfiles.tar.gz"
mkdir "${HOME}/.dotfiles"
tar -xf "/tmp/dotfiles.tar.gz" -C "${HOME}/.dotfiles/" --strip-components=1
rm "/tmp/dotfiles.tar.gz"

# Deploy dotfiles.

cd "${HOME}/.dotfiles"
bash deploy.sh

# Setup environment.

setupEnvironment
