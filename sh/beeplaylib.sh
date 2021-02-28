#!/bin/sh

_beeplay_mili_to_seconds()
{
    # Convert miliseconds to seconds
    # $1    - time value in miliseconds
    # Returns time value in seconds

    echo "$1/1000" | bc -sl
}

beeplay_bell()
{
    # Play single note using terminal bell
    # $1    - frequency in Hz (ignored)
    # $2    - length in ms

    length="$2"

    printf '\a'
    sleep "$(_beeplay_mili_to_seconds "$length")"  # simulate sound duration by just waiting
}

beeplay()
{
    # Play music from a sheet file
    # $1    - function that plays a single note, given frequency and length (optional, defaults to terminal bell)

    play_note="${1:-beeplay_bell}"
    ifs_val=' 	
'  # literal space, literal tab, literal newline

    # second condition is for the last line when stream ends with EOF instead of newline
    # in that case read returns nonzero but delay should be set
    while IFS="$ifs_val" read -r frequency length delay repeats || [ -n "$delay" ]; do
        # make beep in background and wait
        # background ignores signals (so sound will not be interrupted)
        # but main shell exits immediately
        (
            trap '' 1 2 3 6 15
            i=1
            end="${repeats:-1}"
            while [ $i -le "$end" ]; do
                $play_note "$frequency" "$length" && sleep "$(_beeplay_mili_to_seconds "$delay")"
                i=$((i+1))
            done
        ) & wait
    done
}