# ~/.bashrc: thin loader for modular bashrc

# Source environment before interactive guard
if [ -r "$HOME/.bashrc.d/00-env.sh" ]; then
  . "$HOME/.bashrc.d/00-env.sh"
fi

# Interactive shell guard
case $- in
*i*) ;;
*) return ;;
esac

# Source all bashrc.d modules
for f in "$HOME/.bashrc.d"/*.sh; do
  [ -r "$f" ] && . "$f"
done

# Source .bashrc.local
if [ -r "$HOME/.bashrc.d/00-env.sh" ]; then
  . "$HOME/.bashrc.local"
fi
