#!/bin/sh

print_usage()
{
    echo
    echo "Correct usage is : $0 sheet"
    echo
    echo "sheet - file with notes"
}

if [ "$#" -ne 1 ]
then
    echo "Exactly one argument is needed"
    print_usage
    exit 1
fi

module_dir="$(dirname "$0")"
(cd "$module_dir" && make -s > /dev/null)

exitval="$?"

if ! [ "$exitval" -eq 0 ]
then
    echo "Can't build executable"
    print_usage
    exit 2
fi
./"$module_dir"/bin/play "$1"