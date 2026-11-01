chp ( )
{
	usage="Usage: chp [<dir>] [-e | -v]"

	OPTIND=1
	while getopts ":sev" opt 
	do
		case $opt in
			e )
				cd "$CUR_PROJ"
				"${EDITOR:-vi}"  "$CUR_PROJ"
				return 0
				;;
			v )
				echo "$CUR_PROJ"
				return 0
				;;
			* )
				echo "$usage"
				return 1
				;;
		esac
	done
	shift $(($OPTIND - 1))

	if [[ $# -eq 0 ]]
	then
		cd "$CUR_PROJ"
		return 0
	elif [[ $# -eq 1 ]]
	then
		path=$(realpath $1)
		if [[ ! -d $path ]]
		then
			echo "$usage"
			echo "Bad directory; exiting."
			return 1
		fi

		export CUR_PROJ="$path"
		gawk -i inplace '
	BEGIN {
	path = ARGV[2]
	ARGV[2] = ""
	path = "=\"" path "\""
	}

	$0 !~ /export CUR_PROJ/

	/export CUR_PROJ/ {
	gsub(/=".*"/, path);
	print $0
		} ' "$HOME/.bashrc" "$path"
		echo "Current project udpated."
		cd "$path"
	else
		echo "$usage"
	fi
}
