#!/bin/bash

# Check if dialog is installed
if ! [ -x "$(command -v dialog)" ]; then
  echo 'Error: dialog is not installed.' >&2
  exit 1
fi

# Save the original vim arguments, like files to open
originalArguments=$@

# Create a temp file to store the checkbox selection
tempfile=$(mktemp /tmp/vim_laucher_checkbox_selection.XXXXXXXXXXXXXXXXXXXXXXXX)

# Path to nvim executable
vimExecPath="/opt/homebrew/bin/nvim"

# Function to show dialog options
function show-options() {
  dialog --checklist "Select the languages you want to code:" 20 40 10 \
    txt "Text" on \
    markdown "Markdown" off \
    elixir "Elixir" off \
    javascript "Javascript" off \
    html "HTML" off \
    css "CSS" off \
    golang "Golang" off \
    rust "Rust" off \
    java "Java" off \
    lua "Lua" off \
    bash "Bash" off \
    gdscript "GDScript" off \
    clojure "Clojure" off \
    php "PHP" off \
    zig "Zig" off \
    sql "SQL" off \
    security "Security" off \
    none "None" off \
    2>"$tempfile"

  # Verificar se o usuário cancelou ou pressionou ESC
  if [ "$?" -ne 0 ]; then
    clean-temp-file
    clear
    exit 0
  fi

  if [[ $(cat "$tempfile") == "" ]]; then
    dialog --yesno "No options selected. Do you want to select root?" 10 40
    if [ "$?" -eq 0 ]; then
      open-vim
    else
      show-options
    fi

  else
    lauche-nvim
  fi
}

# Function to launch nvim with the selected languages
# inside an env variable in this format "php,html,javascript,css"
function lauche-nvim() {
  langsFormated=$(cat "$tempfile" | sed 's/\ /\,/g')
  export NVIMLANG=$langsFormated
  open-vim
  unset NVIMLANG
}

function open-vim() {
  clear
  $vimExecPath "$originalArguments"
}

show-options

rm "$tempfile"
