# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH
export PATH="$HOME/.emacs.d/bin:$PATH"

# Only needed for work machines
export PATH="/opt/mssql/bin:$PATH"
export DOTNET_ROOT=/snap/dotnet-sdk/current

# User specific aliases and functions
# LS overwrite using lsd, a much better file display tool
alias ls='lsd'
alias lsa='lsd -all'

alias randombg='feh --randomize --bg-scale ~/Pictures/*'
alias showrouters='nmcli device wifi list'
alias updatestarship='sh -c "$(curl -fsSL https://starship.rs/install.sh)"'
alias evimrc='vim ~/.vimrc'

neofetch

eval "$(starship init bash)"