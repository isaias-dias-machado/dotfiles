dconfdump="$HOME/dotfiles"
echo "dconf updater ..."
if [ $(stat -c %Y $dconfdump) -lt $(date -d '1 week ago' +%s) ]; then
	dconf dump / > $dconfdump
	echo "dconf dump updated"
else
	echo "last dconf dump is not yet older than a week"
fi
