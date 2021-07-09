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

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
alias ls='lsd'
alias lsa='lsd -all'
alias randombg='feh --randomize --bg-scale ~/Pictures/*'
alias showrouters='nmcli device wifi list'
alias createpublishapi='cd Software/Arbinger/ArbingerAPI/ArbingerAPI/ && dotnet publish && cd ~/'
alias arbapi='cd ~/Software/Arbinger/API/ArbingerAPI/'
alias joplin='nohup ~/Downloads/Joplin-2.0.11.AppImage &'
alias evimrc='vim ~/.vimrc'


export PATH="$HOME/.emacs.d/bin:$PATH"
export PATH="/opt/mssql/bin:$PATH"
#export DOTNET_ROOT="/snap/dotnet-sdk/current:$PATH"
##export DOTNET_ROOT="/usr/share/dotnet/sdk:$PATH"
#export PATH=$PATH:$DOTNET_ROOT
export DOTNET_ROOT=/snap/dotnet-sdk/current

neofetch

eval "$(starship init bash)"
