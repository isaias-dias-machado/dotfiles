BEGIN {
	projpath = ARGV[2]
	ARGV[2] = ""
	}
	
/source .*chp/ { sourced = 1 }

/export CUR_PROJ/ { exported = 1}

END {
	if (!exported) {
		printf("export CUR_PROJ=\"\"\n")
		}
	if (!sourced) {
		printf("source %schp.sh\n", projpath) 
	}
	}

