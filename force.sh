#!/bin/bash

r='\033[0;31m' # red
g='\033[0;32m' # green
b='\033[0;34m' # blue
n='\033[0m' # no color

show_usage() {
    echo "usage: $0 [options]"
    echo "-h, --help [show help message]"
    echo "-i, --information [show information tools]"
    echo
}

show_information() {
    echo "information:"
    echo "name: X-Force"
    echo "version: 1.0.0"
    echo "author: msverse.site"
    echo "homepage: https://www.msverse.site"   
    echo
}

show_target_arguments() {
    echo "target arguments:"
    echo "-u, --url [target url]"
    echo "-w, --wordlist [wordlist file]"
    echo "-t, --thread [numbers of threading (default: 5)]"
    echo
}

DOMAIN=""
WORDLIST=""
THREAD=5

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -u|--url)
        DOMAIN="$2"
        shift 2
        ;;
        -w|--wordlist)
        WORDLIST="$2"
        shift 2
        ;;
        -t|--thread)
        THREAD="$2"
        shift 2
        ;;
        -h|--help)
        show_usage
        show_target_arguments
        exit 0
        ;;
        -i|--information)
        show_information
        exit 0
        ;;
        *)
        shift
        ;;
    esac
done

if [[ -z $DOMAIN ]] || [[ -z $WORDLIST ]]; then
    show_usage
    exit 1
fi

clear
echo -e "${b}
____  ___        ___________                         
\   \/  /        \_   _____/__________   ____  ____  
 \     /   ______ |    __)/  _ \_  __ \_/ ___\/ __ \ 
 /     \  /_____/ |     \(  <_> )  | \/\  \__\  ___/ 
/___/\  \         \___  / \____/|__|    \___  >___  >
      \_/             \/                    \/    \/${n} "
echo -e "${r}[${g} $DOMAIN ${r}] ${n}|| ${r}[${g} $WORDLIST ${r}] ${n}|| ${r}[${g} $THREAD ${r}]${n}"
start_time=$(date +"%Y-%m-%d %H:%M:%S")
echo -e "${r}[${g} $start_time ${r}]${n} starting program"

found_file="found.txt"
notfound_file="notfound.txt"

while IFS= read -r word; do
    url="https://$DOMAIN/$word"
    result=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    if [[ $result -eq 200 ]]; then
        echo "$url => found" >> "$found_file"
    else
        echo "$url => notfound" >> "$notfound_file"
    fi
done < "$WORDLIST"

end_time=$(date +"%Y-%m-%d %H:%M:%S")
echo -e "${r}[${g} $end_time ${r}]${n} status complete"

echo -e "${r}[${g} $end_time ${r}]${n} data save ${r}[${g} $found_file ${r}] ${n}|| ${r}[${g} $notfound_file ${r}]${n}"
