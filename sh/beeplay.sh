#!/bin/sh

# Error codes

ERRNO_SHEET_ARG_ABSENT=1
ERRNO_SHEET_FILE_NONEXISTENT=2
ERRNO_SHEET_FILE_UNREADABLE=3

# Helper functions 

print_error()
{
    # Print error message
    # $1    - message to print

    printf "Error: %s\n\n" "$1"
}

print_usage() 
{
    # Print script usage

    cat <<EOF
Usage: $0 [-d] SHEET

    -d, --default           use the default terminal bell instead of beep
    SHEET                   path to the sheet file
EOF
}

# Parse args

for arg in "$@"; do
    case $arg in
        -d|--default) DEFAULT=1 ;;
        -h|--help) print_usage; exit;;
        *) set -- "$@" "$arg" ;;  # Leave positional arguments
    esac
    shift
done

# Test args correctness

if [ "$#" -lt 1 ]
then
    print_error "Path to the sheet file is necessary"
    print_usage; exit "$ERRNO_SHEET_ARG_ABSENT"
fi

SHEET="$1"

if ! [ -e "$SHEET" ]
then
    print_error "Sheet file $SHEET does not exist"
    print_usage; exit "$ERRNO_SHEET_FILE_NONEXISTENT"
fi

if ! [ -r "$SHEET" ]
then
    print_error "Sheet file $SHEET is not readable"
    print_usage; exit "$ERRNO_SHEET_FILE_UNREADABLE"
fi

# Custom single note function
beep_note()
{
    # Play single note using beep command
    # $1    - frequency in Hz
    # $2    - length in ms

    FREQUENCY="$1"
    LENGTH="$2"

    beep -f "$FREQUENCY" -l "$LENGTH"
}

# Get script directory, works in most simple cases
SCRIPTDIR="$(dirname -- "$0")"

# Import library functions
# shellcheck disable=SC1090
. "$SCRIPTDIR"/beeplaylib.sh

# Pipe file to stdin and call beeplay with custom function or default based on -d option
if [ -z "$DEFAULT" ]
then
    beeplay beep_note < "$SHEET"
else
    beeplay           < "$SHEET"
fi;