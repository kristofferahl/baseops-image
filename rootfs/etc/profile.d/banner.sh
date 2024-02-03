#!/bin/bash

BANNER_COMMAND='figurine'
BANNER_INDENT="${BANNER_INDENT:-  }"
BANNER_FONT="${BANNER_FONT:-Colossal.flf}"

if [[ ${SHLVL} -le 1 ]]; then
  function _header() {
    if [ -n "${BANNER}" ]; then
      echo
      ${BANNER_COMMAND} -f "${BANNER_FONT}" "${BANNER}" | sed "s/^/${BANNER_INDENT}/"
      echo
    fi
  }
  _header
  unset _header
fi
