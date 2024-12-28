#!/bin/bash

# Mount checkbox selection with dialog
# using this options
# markdown, golang, rust, java, elixir, lua, javascript, gdscript, clojure, security, php
# and print the response using echo

# Check if dialog is installed
if ! [ -x "$(command -v dialog)" ]; then
  echo 'Error: dialog is not installed.' >&2
  exit 1
fi

tempfile=$(mktemp /tmp/vim_laucher_checkbox_selection.XXXXXXXXXXXXXXXXXXXXXXXX)

vimExecPath="/opt/homebrew/bin/nvim"

function show-options() {
  dialog --checklist "Select the languages you want to code:" 20 40 10 \
    markdown "Markdown" off \
    elixir "Elixir" off \
    javascript "Javascript" off \
    html "HTML" off \
    css "CSS" off \
    golang "Golang" off \
    rust "Rust" off \
    java "Java" off \
    lua "Lua" off \
    gdscript "GDScript" off \
    clojure "Clojure" off \
    php "PHP" off \
    security "Security" on \
    none "None" off \
    2>$tempfile

  # if no options selected, show dialog asking to confirm options,
  # if yes, show dialog sayn "root" was selected
  # if no, show options again
  if [[ $(cat $tempfile) == "" ]]; then
    dialog --yesno "No options selected. Do you want to select root?" 10 40
    if [ $? -eq 0 ]; then
      open-vim
    else
      show-options
    fi

  else
    lauche-nvim
  fi

}

function lauche-nvim() {
  langsFormated=$(cat $tempfile | sed 's/\ /\,/g')
  export NVIMLANG=$langsFormated
  open-vim
  unset NVIMLANG
}

function open-vim() {
  clear
  $vimExecPath
}

show-options

rm $tempfile
