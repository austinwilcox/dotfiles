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

str=`hostnamectl | grep 'hostname'`
IFS=':'
read -rasplitIFS<<< "$str"
desktopName=" Austin-Desktop"
if [[ "${splitIFS[1]}" == "$desktopName" ]]
then
  export PATH="/usr/share/dotnet:$PATH"
else
  export PATH="$PATH:/home/[[USER_NAME]]/.dotnet/tools"
fi

 #User specific aliases and functions
# LS overwrite using lsd, a much better file display tool
alias ls='lsd'
alias lsa='lsd -all'

alias vim='nvim'
alias v='nvim'

alias gs='git status'
alias gp='git push'

alias randombg='feh --randomize --bg-scale ~/Pictures/*'
alias showrouters='nmcli device wifi list'
alias updatestarship='sh -c "$(curl -fsSL https://starship.rs/install.sh)"'
alias evimrc='vim ~/.vimrc'
alias ssh-arblaptop='ssh austin@192.168.1.19'
alias startDefaultNetwork='sudo virsh net-start default'
#alias nuget="mono /usr/local/bin/nuget.exe"
alias mountFilesDrive='udisksctl mount -b /dev/sda1'
alias rider='~/Downloads/"JetBrains Rider-2021.2.2"/bin/rider.sh'
  export DENO_INSTALL="/home/austin/.deno"
  export PATH="$DENO_INSTALL/bin:$PATH"


alias colemakdh='sudo kmonad ~/.dotfiles/kmonad-layouts/colemak-dh-extend-ansi.kbd'
if [[ "${splitIFS[1]}" == "$desktopName" ]]
then
  neofetch
else
  pfetch
fi

eval "$(starship init bash)"

export VISUAL=nvim
export EDITOR="$VISUAL"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
. "$HOME/.cargo/env"
