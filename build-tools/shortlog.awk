#! /usr/bin/awk -f

# Detect any error
function match_any_error(l)
{
   return \
l ~ /(^[^ :]+:( ?line ?)?[0-9]+|[eE][rR][rR][oO][rR]:|prepare-kernel\.sh:)/ \
   || l ~ /^[^ ]*[-/]ld:/ \
   || l ~ /^*** Warning/ \
   || l ~ /(referenced|discarded) in section/ \
   || l ~ /^make.*(\*\*\*|Error|:.*:)/
}

/libfakeroot\.so/ {
	next
}

match_any_error($0) {
	if (!prev_printed)
		print prev
	print $0
	prev_printed = 1
	next
}

{
	prev = $0
	prev_printed = 0
}
