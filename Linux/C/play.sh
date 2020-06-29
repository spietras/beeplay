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
(cd "$module_dir" && make -s)
./"$module_dir"/play "$1"