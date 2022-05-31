#!/bin/sh

file_id="$(/bin/cat -)"

printf "executing /etc/code/%s.js with /v8/d8\n\n" "$file_id"
printf "output is: \n"

/v8/d8 "/etc/code/$file_id.js"
