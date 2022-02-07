#!/bin/sh

################################################## CONSTANTS #######################################################################

START_CMD='s'
END_CMD='e'

################################################## HELPER FUNCTIONS ################################################################

_is_osx() {
    # Check if OS is OSX

    # see https://stackoverflow.com/a/3466183/12861599
    [ "$(uname -s)" = "Darwin" ]
}

_fake_tty() {
    # Execute command in fake terminal
    # $1    - command to execute (with double-quotes escaped)

    # using script command to simulate fake tty
    # stty raw -echo -onlcr makes sure input is not processed and goes directly to the command
    # the script command differs between Linux and OSX
    # see https://serverfault.com/a/474243 and https://stackoverflow.com/a/41752647/12861599
    if _is_osx; then
        script -Fq /dev/null "stty raw -echo -onlcr; $1" 2>/dev/null
    else
        script -qfc "stty raw -echo -onlcr; $1" /dev/null 2>/dev/null
    fi
}

_fake_tty_with_input() (
    # Execute command in fake terminal that expects input at stdin
    # $1    - command to execute (with double-quotes escaped)

    ppid="$(exec sh -c 'echo "$PPID"')" # get subshell pid

    (
        cat
        _killall "$ppid" # send SIGINT to kill everything in this subshell
    ) | _fake_tty "$1"
)

_read_char() {
    # Read single character from stdin

    char="$(
        dd bs=1 count=1 2>/dev/null
        echo ~
    )"               # dd reads one character at a time, but we need to echo something out
    char="${char%~}" # strip the tilde

    printf "%s" "$char"
}

_read_line() {
    # Read one line with default IFS

    read -r line
    printf "%s" "$line"
}

_skip_read() {
    # Read once and discard

    _read_line >/dev/null
}

_skip_n_read() {
    # Read n times and discard
    # $1    - how many times to read

    i="$1"
    while [ "$i" -gt 0 ]; do
        _skip_read
        i=$((i - 1))
    done
}

_read_vlq() {
    # Read VLQ number from hex bytes in stdin
    # Number is printed to stdout and number of bytes is returned

    i=0
    value=0
    while :; do
        read -r byte
        i=$((i + 1))
        byte_dec=$(_hex_to_decimal "$byte")
        value=$(((value << 7) | (byte_dec & 0x7F)))
        ! [ $((byte_dec & 0x80)) -eq 128 ] && break
    done

    printf '%s' "$value"
    return "$i"
}

_is_symbol() {
    # Check if input is a whole symbol
    # $1    - input

    [ "$(printf '%s' "$1" | wc -m)" -gt 0 ]
}

_process_children() {
    # Get all children of a process
    # $1    - process pid

    children=$(ps -o pid= --ppid "$1" | sed 's/\n/ /g')
    printf "%s " "$children"

    for pid in $children; do
        _process_children "$pid"
    done
}

_killall() {
    # Kill the process and all of its children
    # $1    - process pid
    # $2    - signal id (optional, defaults to -13)

    pids="$1 $(_process_children "$1")"

    kill "${2:--2}" -- $pids >/dev/null 2>&1
    wait $pids >/dev/null 2>&1 # https://stackoverflow.com/a/5722874/12861599
}

_normalize_number() {
    # Remove all non-numeric characters from string and replaces commas with dots
    # $1    - string to process

    printf "%s" "$1" | sed 's/\./,/g; 
                            s/^,*//g; 
                            s/,*$//g; 
                            s/,,*/,/g; 
                            s/\(.*\),/\1./g; 
                            s/,//g; 
                            s/[^0-9\.]*//g'
}

_calculate() {
    # Calculate with bc

    printf '%s\n' "$1" | bc -sl | tr -d '\n'
}

_decimal_to_hex() {
    # Convert decimal value to hex (without '0x' prefix)
    # $1    - decimal value

    printf '%X' "$1"
}

_hex_to_decimal() {
    # Convert hex value to decimal
    # $1    - hex value (without '0x' prefix)

    printf '%d' "0x$1"
}

_hex_to_octal() {
    # Convert hex value to octal (without '0' prefix)
    # $1    - hex value (without '0x' prefix)

    printf '%o' "0x$1"
}

_raw_print() {
    # Print raw data
    # $1    - data to be printed

    printf '%b' "$1"
}

_note_to_frequency() {
    # Convert MIDI note to frequency
    # $1    - MIDI note number

    awk "BEGIN{printf(\"%.2f\", 2^(($1 - 69) / 12) * 440)}"
}

_key_to_frequency() {
    # Convert key to frequency using FL Studio layout
    # $1    - key

    case "$key" in
    z) printf "%s" '261.63' ;;
    x) printf "%s" '293.66' ;;
    c) printf "%s" '329.63' ;;
    v) printf "%s" '349.23' ;;
    b) printf "%s" '392.00' ;;
    n) printf "%s" '440.00' ;;
    m) printf "%s" '493.88' ;;
    ,) printf "%s" '523.25' ;;
    .) printf "%s" '587.33' ;;
    /) printf "%s" '659.25' ;;
    s) printf "%s" '277.18' ;;
    d) printf "%s" '311.13' ;;
    g) printf "%s" '369.99' ;;
    h) printf "%s" '415.30' ;;
    j) printf "%s" '466.16' ;;
    l) printf "%s" '554.37' ;;
    \;) printf "%s" '622.25' ;;
    q) printf "%s" '523.25' ;;
    w) printf "%s" '587.33' ;;
    e) printf "%s" '659.25' ;;
    r) printf "%s" '698.46' ;;
    t) printf "%s" '783.99' ;;
    y) printf "%s" '880.00' ;;
    u) printf "%s" '987.77' ;;
    i) printf "%s" '1046.50' ;;
    o) printf "%s" '1174.66' ;;
    p) printf "%s" '1318.51' ;;
    2) printf "%s" '554.37' ;;
    3) printf "%s" '622.25' ;;
    5) printf "%s" '739.99' ;;
    6) printf "%s" '830.61' ;;
    7) printf "%s" '932.33' ;;
    9) printf "%s" '1108.73' ;;
    0) printf "%s" '1244.51' ;;
    *) return 1 ;;
    esac
}

_safe_variable_name() {
    # Convert all non-alphanumeric characters to underscores
    # $1    - string to process

    printf "%s" "$1" | sed 's/[^A-Za-z0-9]/_/g'
}

_send_cmd() {
    # Send command to stdout
    # $1    - command

    printf '%s\n' "$1"
}

_send_start() {
    # Send start command to stdout
    # $1    - frequency

    _send_cmd "$START_CMD $1"
}

_send_end() {
    # Send end command to stdout
    # $1    - frequency

    _send_cmd "$END_CMD $1"
}

_sleep_infinity() {
    while :; do sleep 86400; done # blocks for 1 day in each iteration
}

_read_midi_header() {
    # Read MIDI time division from header

    # MThd
    read -r byte1
    read -r byte2
    read -r byte3
    read -r byte4
    ! [ "$byte1$byte2$byte3$byte4" = 4D546864 ] && return 1
    # skip length, format and number of tracks
    i=0
    while [ "$i" -lt 8 ]; do
        _skip_read
        i=$((i + 1))
    done
    # time division
    read -r byte1
    read -r byte2
    _hex_to_decimal "$byte1$byte2"
}

_read_midi_track_header() {
    # Read MIDI track length from track header

    # MTrk
    read -r byte1
    read -r byte2
    read -r byte3
    read -r byte4
    ! [ "$byte1$byte2$byte3$byte4" = 4D54726B ] && return 1
    # length
    read -r byte1
    read -r byte2
    read -r byte3
    read -r byte4
    _hex_to_decimal "$byte1$byte2$byte3$byte4"
}

_ppqn_to_bpm() {
    # Convert PPQN to BPM
    # $1    - PPQN value

    _calculate "60000000 / $1"
}

_ticks_to_seconds() {
    # Convert MIDI ticks to seconds
    # $1    - ticks
    # $2    - bpm
    # $3    - time division

    _calculate "$1 * 60 / ($2 * $3)"
}

_stream_midi_track() {
    # Stream events from single MIDI track hex data
    # $1    - time division
    # $2    - bpm (optional, defaults to 120)

    division="$1"
    bpm="${2:-120}"

    n="$(_read_midi_track_header)" || return 1
    last_code='' # for running status
    # read all bytes
    while [ "$n" -gt 0 ]; do
        # detla time
        delta="$(_read_vlq)"
        n=$((n - $?))
        # status (or first data byte if running status)
        read -r byte
        n=$((n - 1))
        dec="$(_hex_to_decimal "$byte")"
        [ "$dec" -lt 128 ] && code="$last_code" || code="$byte"
        case "$code" in
        8? | 9? | A? | B? | E? | F2) # two data bytes
            if [ "$dec" -lt 128 ]; then
                byte1="$byte"
                read -r byte2
                n=$((n - 1))
            else
                read -r byte1
                read -r byte2
                n=$((n - 2))
            fi
            msg="$code $byte1 $byte2"
            last_code="$code"
            ;;
        C? | D? | F1 | F3) # one data byte
            if ! [ "$dec" -lt 128 ]; then
                read -r byte
                n=$((n - 1))
            fi
            msg="$code $byte"
            last_code="$code"
            ;;
        F0) # system exclusive
            msg="$code"
            while [ "$(_hex_to_decimal "$byte")" -lt 128 ]; do
                read -r byte
                n=$((n - 1))
                msg="$msg $byte"
            done
            last_code="$byte"
            ;;
        FF) # meta event
            read -r type
            n=$((n - 1))
            case "$type" in
            00) # sequence number
                read -r num
                n=$((n - 1))
                if [ "$num" = 02 ]; then
                    _skip_n_read 2
                    n=$((n - 2))
                fi
                ;;
            20 | 21) # midi channel or midi port
                _skip_n_read 2
                n=$((n - 2))
                ;;
            2F) # end of track
                _skip_read
                n=$((n - 1))
                ;;
            51) # tempo
                _skip_read
                read -r byte1
                read -r byte2
                read -r byte3
                n=$((n - 4))
                bpm="$(_ppqn_to_bpm "$(_hex_to_decimal "$byte1$byte2$byte3")")"
                ;;
            54) # smpte offset
                _skip_n_read 6
                n=$((n - 6))
                ;;
            58) # time signature
                _skip_n_read 5
                n=$((n - 5))
                ;;
            59) # key signature
                _skip_n_read 3
                n=$((n - 3))
                ;;
            *)
                len="$(_read_vlq)"
                n=$((n - $? - len))
                _skip_n_read "$len"
                ;;
            esac
            msg='F0 F7' # dummy message
            ;;
        esac
        # send message with delta time in seconds (e.g. '0.01 90 3E 60')
        echo "$(_ticks_to_seconds "$delta" "$bpm" "$division") $msg"
    done
}

_stream_midifile() {
    # Stream events from MIDI file to stdout
    # $1    - ID of track to follow (optional, defaults to 0)

    track="${1:-0}"

    # see http://midi.teragonaudio.com/tech/midifile.htm
    # works best with type 0 MIDI files

    hexdump -v -e '/1 "%02X\n"' |
        (
            division="$(_read_midi_header)" || exit
            while [ "$track" -gt 0 ]; do
                length="$(_read_midi_track_header)" || exit
                _skip_n_read "$length"
                track=$((track - 1))
            done
            _stream_midi_track "$division"
        ) |
        while read -r delta_time hex_msg; do
            octal_msg=''
            # see https://stackoverflow.com/a/54792587/12861599
            for hex in $(echo "$hex_msg"); do
                octal_msg="$octal_msg\0$(_hex_to_octal "$hex")"
            done
            sleep "$delta_time"
            _raw_print "$octal_msg"
        done
}

################################################## BUNDLED EMITTER FUNCTIONS ######################################################

emit_tty() (
    # Emit note events from terminal to stdout
    # Notes are emitted after the first press of a key associated with a note

    resets=''

    # in icanon mode input is accessible only after pressing Enter
    # so we should turn it off
    if [ -t 0 ]; then
        # remember tty settings to restore them later
        resets="$resets stty $(stty -g);"

        # turn off icanon, echo and set timeout so notes can be stopped after key up
        stty -icanon -echo min 0 time 1
    fi

    if command -v xset >/dev/null; then
        # remember x settings to restore them later
        read -r x_delay x_rate <<EOF
$(xset q | sed -n '/auto repeat delay:/s/[^0-9]/ /gp')
EOF
        resets="$resets xset r rate $x_delay $x_rate;"

        # turn off keyboard autorepeat delay
        xset r rate 1 33
    fi

    trap 'rc=$?; trap "" HUP INT QUIT ABRT ALRM TERM; '"$resets"' return $rc' HUP INT QUIT ABRT ALRM TERM

    previous_frequency=''
    while :; do

        # read one character at a time until whole symbol is read (some have more characters, e.g. \e)
        key=''
        while ! _is_symbol "$key"; do
            char="$(_read_char)"
            if [ -z "$char" ] && [ -n "$previous_frequency" ]; then
                _send_end "$previous_frequency"
                previous_frequency=''
            fi              # timeout
            key="$key$char" # concat characters
        done

        ! frequency="$(_key_to_frequency "$key")" && continue # key not mapped

        # emit note events only when symbols changed
        if [ "$frequency" != "$previous_frequency" ]; then
            [ -n "$previous_frequency" ] && _send_end "$previous_frequency" # stop previous note
            _send_start "$frequency"                                        # start new note
            previous_frequency="$frequency"
        fi
    done

    # restore settings
    $resets
)

emit_midistream() {
    # Emit note events from MIDI stream to stdout
    # $1    - ID of channel to follow (optional, 1-16 range, defaults to 1)

    channel="$(_decimal_to_hex $((${1:-1} - 1)))"

    # parsing of binary MIDI stream is happening below
    # for specification of MIDI streams see http://midi.teragonaudio.com/tech/midispec.htm
    #
    # events from one channel only are captured, rest is ignored
    # running status is supported
    #
    # note_on and note_off messages are converted to beeplay commands
    # they are sent to output immediately so input should appear at proper time
    #
    # hexdump is decoding binary data into hexadecimal bytes
    # however hexdump doesn't buffer output only in interactive terminals
    # so to have live processing we need to execute hexdump in a fake tty

    last_code='' # for running status

    _fake_tty_with_input "hexdump -v -e '/1 \"%02X\n\"'" |
        while read -r byte; do
            dec="$(_hex_to_decimal "$byte")"
            [ "$dec" -lt 128 ] && code="$last_code" || code="$byte"
            case "$code" in
            "8$channel" | "9$channel") # note_on and note_off
                if [ "$dec" -lt 128 ]; then
                    read -r velocity
                    note="$dec"
                else
                    read -r note
                    read -r velocity
                    note="$(_hex_to_decimal "$note")"
                fi
                frequency="$(_note_to_frequency "$note")"
                if [ "$velocity" = 00 ] || [ "$code" = 80 ]; then
                    _send_end "$frequency"
                else
                    _send_start "$frequency"
                fi
                last_code="$code"
                ;;
            8? | 9? | A? | B? | E? | F2) # two data bytes
                if [ "$dec" -lt 128 ]; then
                    _skip_read
                else
                    _skip_n_read 2
                fi
                last_code="$code"
                ;;
            C? | D? | F1 | F3) # one data byte
                ! [ "$dec" -lt 128 ] && _skip_read
                last_code="$code"
                ;;
            F0) # system exclusive
                while [ "$(_hex_to_decimal "$byte")" -lt 128 ]; do
                    read -r byte
                done
                last_code="$byte"
                ;;
            esac
        done
}

emit_midifile() {
    # Emit note events from MIDI file to stdout
    # $1    - ID of track to follow (optional, defaults to 0)
    # $2    - ID of channel to follow (optional, 1-16 range, defaults to 1)

    track="${1:-0}"
    channel="${2:-1}"

    _stream_midifile "$track" | emit_midistream "$channel"
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
    trap 'rc=$?; trap "" HUP INT QUIT ABRT ALRM TERM; _killall "$ppid"; return $rc' HUP INT QUIT ABRT ALRM TERM

    while IFS="$ifs_val" read -r command frequency; do # read until the end of stream
        frequency="$(_normalize_number "$frequency")"
        frequency_safe="$(_safe_variable_name "$frequency")"
        pid="$(eval "echo \$pids_$frequency_safe")"

        # if start command and note is not playing already then start playing it
        if [ "$command" = "$START_CMD" ] && [ -z "$pid" ]; then
            (
                trap 'exit' HUP INT QUIT ABRT ALRM TERM
                while :; do $play_note "$frequency"; done
            ) &                              # play note in background and repeat (if non-blocking function is used)
            eval "pids_$frequency_safe='$!'" # save pid of launched process, associating it with frequency
        # if end command and note is playing then kill it
        elif [ "$command" = "$END_CMD" ] && [ -n "$pid" ]; then
            _killall "$pid" -9 # kill all children just in case, SIGKILL to be fast
            eval "pids_$frequency_safe=''"
        fi
    done

    kill "$ppid" # kill self to invoke trap and clean
)
