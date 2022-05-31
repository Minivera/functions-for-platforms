#!/bin/sh

file_id="$(/bin/cat -)"

printf "executing /etc/code/%s.js with /v8/d8" "$file_id"
/bin/cat "/etc/code/$file_id.js"

/v8/d8 "/etc/code/$file_id.js"
