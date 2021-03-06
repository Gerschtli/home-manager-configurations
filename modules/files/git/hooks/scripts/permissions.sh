#!/usr/bin/env bash

source "${HOOKS_DIR}/helpers/util.sh"

SECRET_FILES="${PWD}/.secret-files"

install() {
    while read -r line; do
        local file="${PWD}/${line}"
        if [[ -e "${file}" ]]; then
            chmod 0640 "${file}"
            # try to set group if group is available
            chgrp secret-files "${file}" 2> /dev/null || :
        fi
    done < "${SECRET_FILES}"
}

if [[ -r "${SECRET_FILES}" ]]; then
    case "${HOOK_TYPE}" in
        post-checkout | post-merge) install ;;
    esac
fi

exit ${RESULT}
