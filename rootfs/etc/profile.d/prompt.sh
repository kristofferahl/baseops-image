#!/bin/bash

# Set the window size for the shell
shopt -s checkwinsize
export SCREEN_SIZE="${LINES}x${COLUMNS}"

# Disable PROMPT_COMMAND and PS1 from being exported to subshells
export -n PS1
export -n PROMPT_COMMAND

function _add_prompter() {
  if ! [[ $PROMPT_COMMAND =~ prompter ]]; then
    local final_colon=';$'
    if [[ -z $PROMPT_COMMAND ]]; then
      PROMPT_COMMAND="prompter;"
    elif [[ $PROMPT_COMMAND =~ $final_colon ]]; then
      PROMPT_COMMAND="${PROMPT_COMMAND}prompter;"
    else
      PROMPT_COMMAND="${PROMPT_COMMAND};prompter;"
    fi
  fi
}

# Add prompter to PROMPT_COMMAND
_add_prompter
unset -f _add_prompter

function prompter() {
  for hook in "${PROMPT_HOOKS[@]}"; do
    "${hook:?}"
  done
}

# Handle reloads
PROMPT_HOOKS+=("reload")
function reload() {
  local current_screen_size="${LINES}x${COLUMNS}"
  if [ "${current_screen_size}" != "${SCREEN_SIZE}" ]; then
    echo "* Screen resized to ${current_screen_size}"
    export SCREEN_SIZE=${current_screen_size}
    # Instruct shell that window size has changed to ensure lines wrap correctly
    kill -WINCH $$
  fi
}

# Handle prompt
PROMPT_HOOKS+=("baseops_prompt")
function baseops_prompt() {
  [[ -z $BASEOPS_ARROR_RIGHT ]] && BASEOPS_ARROR_RIGHT=$'\u2a20' # ⨠
  [[ -z $BASEOPS_BANNER ]] && BASEOPS_BANNER='❤︎'

  local level
  case ${SHLVL:-1} in
    1) level="" ;;
    *) level="[$((SHLVL - 1))] " ;;
  esac

  local prompt
  prompt="  ${level:-}$(pwd -P) "
  prompt+=$'${BASEOPS_ARROR_RIGHT:?} '

  if [ -n "${BANNER:-}" ]; then
    PS1=$"\n"' ${BASEOPS_BANNER}'" ${BANNER:?}\n${prompt:?}"
  else
    PS1=" ${prompt:=?}"
  fi
}
