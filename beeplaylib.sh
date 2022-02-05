#!/bin/sh

################################################## CONSTANTS #######################################################################

START_CMD='s'
END_CMD='e'

################################################## HELPER FUNCTIONS ################################################################

_process_children() {
    # Gets all children of a process
    # $1    - process pid

    children=$(ps -o pid= --ppid "$1" | sed 's/\n/ /g')
    printf "%s " "$children"

    for pid in $children; do
        _process_children "$pid"
    done
}

_killall() {
    # Kills the process and all of its children
    # $1    - process pid

    kill -13 -- "$1" $(_process_children "$1") >/dev/null 2>&1 # SIGPIPE should not print exit message
}

_normalize_number() {
    # Removes all non-numeric characters from string and replaces commas with dots
    # $1    - string to process

    printf "%s" "$1" | sed 's/\./,/g; 
                            s/^,*//g; 
                            s/,*$//g; 
                            s/,,*/,/g; 
                            s/\(.*\),/\1./g; 
                            s/,//g; 
                            s/[^0-9\.]*//g'
}

_mili_to_seconds() {
    # Converts miliseconds to seconds
    # $1    - time value in miliseconds

    printf '%s\n' "$1/1000" | bc -sl | tr -d '\n'
}

_safe_variable_name() {
    # Converts all non-alphanumeric characters to underscores
    # $1    - string to process

    printf "%s" "$1" | sed 's/[^A-Za-z0-9]/_/g'
}

_send_cmd() {
    # Sends command to stdout
    # $1    - command

    printf '%s\n' "$1"
}

_send_start() {
    # Sends start command to stdout
    # $1    - frequency

    _send_cmd "$START_CMD $1"
}

_send_end() {
    # Sends end command to stdout
    # $1    - frequency

    _send_cmd "$END_CMD $1"
}

_sleep_infinity() {
    while true; do sleep 86400; done # blocks for 1 day in each iteration
}

################################################## BUNDLED EMITTER FUNCTIONS ######################################################

emit_tty() (
    # Emits note events to stdout
    # Notes are emitted after the first press of a key associated with a note (CDEFGAB)

    resets=''

    # In icanon mode input is accessible only after pressing Enter
    # So we should turn it off
    if [ -t 0 ]; then
        # Remember tty settings to restore them later
        resets="$resets stty $(stty -g);"

        # Turn off icanon, echo and set timeout so notes can be stopped after key up
        stty -icanon -echo min 0 time 1
    fi

    if command -v xset >/dev/null; then
        # Remember x settings to restore them later
        read -r x_delay x_rate <<EOF
$(xset q | sed -n '/auto repeat delay:/s/[^0-9]/ /gp')
EOF
        resets="$resets xset r rate $x_delay $x_rate;"

        # Turn off keyboard autorepeat delay
        xset r rate 1 33
    fi

    trap 'rc=$?; trap "" 1 2 3 6 14 15; '"$resets"' return $rc' 1 2 3 6 14 15

    previous_frequency=''
    while true; do

        # Read one characters at a time until whole symbol is read (some have more characters, e.g. \e)
        key=''
        while [ "$(printf '%s' "$key" | wc -m)" -eq 0 ]; do
            char=''
            char="$(
                dd bs=1 count=1 2>/dev/null
                echo ~
            )"               # dd reads one character at a time, but we need to echo something out
            char="${char%~}" # strip the tilde
            [ -z "$char" ] && [ -n "$previous_frequency" ] && {
                _send_end "$previous_frequency"
                previous_frequency=''
            }               # timeout
            key="$key$char" # concat characters
        done

        # FL Studio keyboard layout
        # note to frequencies mapping from https://pages.mtu.edu/~suits/notefreqs.html
        case "$key" in
        z) frequency='261.63' ;;
        x) frequency='293.66' ;;
        c) frequency='329.63' ;;
        v) frequency='349.23' ;;
        b) frequency='392.00' ;;
        n) frequency='440.00' ;;
        m) frequency='493.88' ;;
        ,) frequency='523.25' ;;
        .) frequency='587.33' ;;
        /) frequency='659.25' ;;
        s) frequency='277.18' ;;
        d) frequency='311.13' ;;
        g) frequency='369.99' ;;
        h) frequency='415.30' ;;
        j) frequency='466.16' ;;
        l) frequency='554.37' ;;
        \;) frequency='622.25' ;;
        q) frequency='523.25' ;;
        w) frequency='587.33' ;;
        e) frequency='659.25' ;;
        r) frequency='698.46' ;;
        t) frequency='783.99' ;;
        y) frequency='880.00' ;;
        u) frequency='987.77' ;;
        i) frequency='1046.50' ;;
        o) frequency='1174.66' ;;
        p) frequency='1318.51' ;;
        2) frequency='554.37' ;;
        3) frequency='622.25' ;;
        5) frequency='739.99' ;;
        6) frequency='830.61' ;;
        7) frequency='932.33' ;;
        9) frequency='1108.73' ;;
        0) frequency='1244.51' ;;
        *) continue ;;
        esac

        # Emit note events only when symbols changed
        if [ "$frequency" != "$previous_frequency" ]; then
            [ -n "$previous_frequency" ] && _send_end "$previous_frequency" # stop previous note
            _send_start "$frequency"                                        # start new note
            previous_frequency="$frequency"
        fi
    done

    # Restore settings
    $resets
)

emit_sheet() {
    ifs_val=' 	
' # literal space, literal tab, literal newline

    # second condition is for the last line when stream ends with EOF instead of newline
    # in that case read returns nonzero but delay should be set
    while IFS="$ifs_val" read -r frequency length delay repeats || [ -n "$delay" ]; do
        i=1
        end="${repeats:-1}"
        while [ $i -le "$end" ]; do
            _send_start "$frequency"
            sleep "$(_mili_to_seconds "$length")"
            _send_end "$frequency"
            sleep "$(_mili_to_seconds "$delay")"
            i=$((i + 1))
        done
    done
}

################################################## BUNDLED SINGLE NOTE FUNCTIONS ##################################################

note_print() {
    # Print frequency of given note
    # $1    - frequency in Hz

    printf '%s\n' "$1"
    sleep 0.1 # to prevent spamming
}

note_bell() {
    # Play single note using terminal bell
    # $1    - frequency in Hz (ignored)

    printf '\a'
    _sleep_infinity # block here so the bell plays only once
}

note_play() {
    # Play single note using play command from sox
    # $1    - frequency in Hz

    play -q -n synth sin "$1"
}

################################################## MAIN FUNCTION ###################################################################

beeplay() (
    # Play music from stdin events
    # $1    - function that plays a single note, given frequency and length (optional, defaults to terminal bell)

    play_note="${1:-note_bell}"
    ifs_val=' 	
' # literal space, literal tab, literal newline

    ppid="$(exec sh -c 'echo "$PPID"')" # get subshell pid
    trap 'rc=$?; trap "" 1 2 3 6 14 15; _killall "$ppid"; return $rc' 1 2 3 6 14 15

    while IFS="$ifs_val" read -r command frequency; do # read until the end of stream
        frequency="$(_normalize_number "$frequency")"
        frequency_safe="$(_safe_variable_name "$frequency")"
        pid="$(eval "echo \$pids_$frequency_safe")"

        # If start command and note is not playing already then start playing it
        if [ "$command" = "$START_CMD" ] && [ -z "$pid" ]; then
            (
                trap 'exit' 1 2 3 6 14 15
                while true; do $play_note "$frequency"; done
            ) &                              # play note in background and repeat (if non-blocking function is used)
            eval "pids_$frequency_safe='$!'" # save pid of launched process, associating it with frequency
        # If end command and note is playing then kill it
        elif [ "$command" = "$END_CMD" ] && [ -n "$pid" ]; then
            _killall "$pid" # kill all children just in case
            eval "pids_$frequency_safe=''"
        fi
    done
)
