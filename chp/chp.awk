BEGIN {
	path = ARGV[2]
	ARGV[2] = ""
	path = "=\"" path "\""
	}

$0 !~ /export CUR_PROJ/

/export CUR_PROJ/ {
	gsub(/=".*"/, path);
	print $0
	}

