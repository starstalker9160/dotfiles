# !/usr/bin/env bash
# persistent ordered mapping: index -> value
# 1-based externally but 0-based internally

MAPPING_FILE="${SESSION_MAP_FILE:-$HOME/.starstalker9160/.session_map}"

declare -a _mapping

load_map_file() {
    _mapping=()
    [[ -f "$MAPPING_FILE" ]] || return 0

    local pos val
    while read -r pos val; do
        _mapping[$((pos-1))]="$val"
    done < "$MAPPING_FILE"
}

_save_map_file() {
    > "$MAPPING_FILE"
    local i
    for i in "${!_mapping[@]}"; do
        printf "%d %s\n" "$((i+1))" "${_mapping[i]}" >> "$MAPPING_FILE"
    done
}

# ----- public API -----

insert_mapping_at() {
    local idx=$1
    local val=$2
    ((idx--))

    _mapping=(
        "${_mapping[@]:0:idx}"
        "$val"
        "${_mapping[@]:idx}"
    )

    _save_map_file
}

remove_value() {
    local target=$1
    local i

    for i in "${!_mapping[@]}"; do
        if [[ "${_mapping[i]}" == "$target" ]]; then
            _mapping=(
                "${_mapping[@]:0:i}"
                "${_mapping[@]:i+1}"
            )
            _save_map_file
            return 0
        fi
    done

    return 1  # not found
}

map_get() {
    local idx=$1
    ((idx--))
    printf '%s\n' "${_mapping[idx]}"
}

map_size() {
    echo "${#_mapping[@]}"
}

map_list() {
    local i
    for i in "${!_mapping[@]}"; do
        printf "%d %s\n" "$((i+1))" "${_mapping[i]}"
    done
}

