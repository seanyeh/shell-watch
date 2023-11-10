#!/bin/zsh

__shell_watch_precmd() {
    # Initialization
    local SHELL_WATCH_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/shell-watch"
    local SHELL_WATCH_LIST="${SHELL_WATCH_DIR}/watchlist"
    local SHELL_WATCH_TIMEFILE="${SHELL_WATCH_DIR}/timestamp"
    local SHELL_WATCH_COMMAND="${SHELL_WATCH_DIR}/command"
    mkdir -p "${SHELL_WATCH_DIR}"
    [ -f "${SHELL_WATCH_TIMEFILE}" ] || touch "${SHELL_WATCH_TIMEFILE}"

    # Load list of files to watch, defaulting to ~/.zshrc if watchlist not found
    local shell_watch_files="~/.zshrc"
    if [ -s "${SHELL_WATCH_LIST}" ]; then
      shell_watch_files="$(cat "${SHELL_WATCH_LIST}")"
    fi

    # Default timestamp to timestamp file
    [ -z "${__SHELL_WATCH_TIMESTAMP}" ] && __SHELL_WATCH_TIMESTAMP=$(cat "${SHELL_WATCH_TIMEFILE}")

    # Get timestamp of latest modified file in watchlist
    # Note: ~ will resolve to $HOME in filenames
    local latest_timestamp=$(printf '%s\n' "${shell_watch_files}" \
        | sed '/^[ \t]*#/d' \
        | sed 's#^~#${HOME}#g' \
        | xargs -I{} date -r {} +%s 2>/dev/null \
        | sort \
        | tail -n 1)

    if [ "${__SHELL_WATCH_TIMESTAMP}" != "${latest_timestamp}" ]; then
        printf "** shell-watch reloaded **\n"

        # Update timestamp
        __SHELL_WATCH_TIMESTAMP="${latest_timestamp}"
        printf "%s\n" "${latest_timestamp}" >! "${SHELL_WATCH_TIMEFILE}"

        # Run custom command or source ~/.zshrc
        if [ -s "${SHELL_WATCH_COMMAND}" ]; then
            source "${SHELL_WATCH_COMMAND}"
        else
            source ~/.zshrc
        fi
    fi
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd __shell_watch_precmd
