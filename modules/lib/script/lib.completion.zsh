list=()

_clean_path_and_append() {
    local prefix="${1}"
    local suffix="${2}"
    local file="${3}"

    list+=("${"${file#"${prefix}"}"//"${suffix}"}")
}

_search_and_append_by_prefix_and_suffix() {
    local prefix="${1}"
    local suffix="${2}"

    for file in "${prefix}"*"${suffix}"; do
        _clean_path_and_append "${prefix}" "${suffix}" "${file}"
    done
}
