#!/bin/bash

BANNER_DISPLAY=${BANNER_DISPLAY:-true}
BANNER_INDENT="${BANNER_INDENT:-  }"
BANNER_FONT="${BANNER_FONT:-Colossal.flf}"

if [[ ${SHLVL} -le 1 ]]; then
  function _header() {
    if [[ -n "${BANNER}" && ${BANNER_DISPLAY:-false} == true ]]; then
      echo
      figurine -f "${BANNER_FONT:?}" "${BANNER:?}" | sed "s/^/${BANNER_INDENT:-}/"
      echo
      BANNER_DISPLAY=false
    fi
  }
  _header
  unset _header
fi
