### Script to print the first and last n lines of a file

lines="$2"


# default number of lines is 3
if [[ -z "$lines" ]]; then
	lines="3"
fi

# check the 2X
line_count=$(wc -l < "$1")
if (( $line_count <= 2 * $lines )); then
	cat "$1"
else
  echo "WARNING, the file is really big tbh, only displaying the first and last $lines lines"
  head -n "$lines" "$1"
  echo ...
  tail -n "$lines" "$1"
fi

