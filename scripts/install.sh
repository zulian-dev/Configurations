#!/bin/bash

profile="/Users/kovi/.zprofile"

gitFolder="~/Documents/git/"

gitConfigs="https://github.com/zulian-dev/Configurations"

configFolder="~/Documents/git/Configurations"

# Função para exibir mensagens com cores
info() {
  echo -e "\033[1;34m$1\033[0m"
  timmer 5
}

error() {
  echo -e "\033[1;31m$1\033[0m"
  exit
}

timmer() {
  tempo=$1

  while true; do
    echo "Tempo: $tempo segundos"
    sleep 1
    ((tempo++))
  done
}

install() {
  tool=$1
  info "Instalando $1..."
  brew install $1 || {
    error "Erro ao instalar $1."
    exit 1
  }
}

install-cask() {
  tool=$1
  info "Instalando $1..."
  brew install --cask $1 || {
    error "Erro ao instalar $1."
    exit 1
  }
}

###############################################################################
if [ -f "$profile" ]; then
  echo "O arquivo $profile já existe."
else
  echo "Criando o arquivo $profile..."
  touch "$profile"
  echo "Arquivo $profile criado com sucesso."
fi

# Atualizando o macOS e instalando ferramentas básicas
info "Atualizando o sistema e instalando ferramentas essenciais..."
sudo softwareupdate --install --all

###############################################################################

# Instalando o Homebrew, se não estiver instalado
if ! command -v brew &>/dev/null; then
  info "Homebrew não encontrado. Instalando..."
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
    error "Erro ao instalar o Homebrew."
    exit 1
  }
else
  info "Homebrew já está instalado."
fi

# Atualizando o Homebrew
info "Atualizando o Homebrew..."
brew update

###############################################################################

install "curl"
install "wget"
install "dialog"
install "git"
install "ripgrep" # Usado no nvim (Telescope live grep)

# file finder
install "fzf"

# File viewer
install "bat"

# Smart path resolver
install "zoxide"

# Alternative to powerlevel10k
install "starship"

# File vewer
install "yazi"
install "ffmpeg"
install "sevenzip"
install "jq"
install "poppler"
install "fd"
install "ripgrep"
install "fzf"
install "zoxide"
install "imagemagick"
install "font-symbols-only-nerd-font"

###############################################################################

# info "Configurações do git"
# git config --global user.name "Your Name"
# git config --global user.email you@example.com

###############################################################################

info "Copiando as configurações do git"
info $gitConfigs

# Cria a pasta para baixar as configurações
mkdir -p $gitFolder

# Baixa as configurações
git clone $gitConfigs $gitFolder/Configurations

info "Configuração copiadas!"

###############################################################################

install "neovim"
install "font-hack-nerd-font"

# Cria link simbolicos as configurações do nvim,
# para poder gerenciar elas pelo repositorio git.
ln -s ~/Documents/git/Configurations/nvim ~/.config/nvim

###############################################################################

info "Instalando terminal Ghostty..."

install "ghostty"

ghosttyConfigFile="~/Library/Application\ Support/com.mitchellh.ghostty/config"

rm -rf $ghosttyConfigFile

ln -s ~/Documents/git/Configurations/Ghostty/config $ghosttyConfigFile

###############################################################################

# # Instalando o terminal Kitty
# info "Instalando o terminal Kitty..."
# install-cask kitty

###############################################################################

info "Configurando o Zsh..."

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# powerlevel10k

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

# adiciona meus alias
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
echo "source $configFolder/bash_profile/.bash_alias.sh" >>~/.zshrc

###############################################################################

# Instalando asdf

install "asdf"

# Configurando o asdf no shell
if ! grep -q "asdf.sh" ~/.zshrc; then
  info "Adicionando asdf ao Zsh..."
  echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" >>$profile
  echo -e "\n. $(brew --prefix asdf)/etc/bash_completion.d/asdf.bash" >>$profile

  source $profile

  # Erlang
  asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
  asdf install erlang latest
  asdf global erlang latest

  # Elixir
  asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
  asdf install elixir latest
  asdf global elixir latest

  source $profile
fi

###############################################################################

# Instalando nvm

install "nvm"

# Configurando o nvm no shell
if ! grep -q ".nvm" $profile; then
  info "Configurando nvm no Zsh..."
  mkdir ~/.nvm
  echo -e "\nexport NVM_DIR=\"$HOME/.nvm\""
  echo -e "\n. $(brew --prefix nvm)/nvm.sh" >>$profile
  echo -e "\n. $(brew --prefix nvm)/etc/bash_completion.d/nvm" >>$profile

  source $profile

  nvm install 18
fi

###############################################################################

# Instalando vscodium
info "Instalando o vscodium..."
install-cask vscodium

###############################################################################

# Instalando o Docker
info "Instalando o Docker..."
install-cask docker

# Inicializando o Docker
info "Iniciando o Docker..."
open -a Docker || {
  error "Erro ao iniciar o Docker."
  exit 1
}

###############################################################################

info "Instalação concluída! 🎉"
