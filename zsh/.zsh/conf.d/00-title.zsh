function _win_title_format(){
    local full_path="$1"
    local prefix="$2"
    shift 2
    local segments=("$@")  # rest of args are segments
    local max=5

    local count=${#segments[@]}
    local dir=""

    if (( count <= max )); then
        dir="${(j:/:)segments}"
    else
        local head="${segments[1]}"
        local tail=("${segments[-2]}" "${segments[-1]}")
        dir="${head}/.../${(j:/:)tail}"
    fi

    [[ -n "$prefix" ]] && dir="${prefix}/${dir}"
    [[ -z "$prefix" && "$full_path" == /* ]] && dir="/${dir}"

    local icon=""
    if [[ ! -w "$full_path" ]]; then
        icon="🔒 "
    fi

    echo -n "${icon}${dir}"
}


function set_win_title(){
    local full_path="$(pwd)"
    local dir=""

    local git_root
    git_root=$(git rev-parse --show-toplevel 2>/dev/null)

    if [[ -n "$git_root" ]]; then
        local repo_name=$(basename "$git_root")
        local rel_path="${full_path/#$git_root/}"
        rel_path="${rel_path#/}"
        if [[ -z "$rel_path" ]]; then
            dir="$repo_name"
        else
            local rel_parts=("${(@s:/:)rel_path}")
            dir=$(_win_title_format "$full_path" "$repo_name" "${(@)rel_parts}")
        fi
    elif [[ "$full_path" == $HOME* ]]; then
        local rel="${full_path/#$HOME/}"
        rel="${rel#/}"
        if [[ -z "$rel" ]]; then
            dir="~"
        else
            local rel_parts=("${(@s:/:)rel}")
            dir=$(_win_title_format "$full_path" "~" "${(@)rel_parts}")
        fi
    else
        local parts=("${(@s:/:)full_path}")
        parts=("${parts[@]:#}")
        dir=$(_win_title_format "$full_path" "" "${(@)parts}")
    fi

    echo -ne "\033]0; ${dir} \007"
}

precmd_functions+=(set_win_title)


