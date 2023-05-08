   # _____                   __   .__              __      __ .__ .__                          
  # /  _  \   __ __  _______/  |_ |__|  ____      /  \    /  \|__||  |    ____   ____ ___  ___ 
 # /  /_\  \ |  |  \/  ___/\   __\|  | /    \     \   \/\/   /|  ||  |  _/ ___\ /  _ \\  \/  / 
# /    |    \|  |  /\___ \  |  |  |  ||   |  \     \        / |  ||  |__\  \___(  <_> )>    <  
# \____|__  /|____//____  > |__|  |__||___|  /      \__/\  /  |__||____/ \___  >\____//__/\_ \ 
   #      \/            \/                 \/            \/                  \/             \/ 
                                                                                             
# __________                 .__                                                               
# \______   \_____     ______|  |__ _______   ____                                             
 # |    |  _/\__  \   /  ___/|  |  \\_  __ \_/ ___\                                            
 # |    |   \ / __ \_ \___ \ |   Y  \|  | \/\  \___                                            
 # |______  /(____  //____  >|___|  /|__|    \___  >                                           
   #      \/      \/      \/      \/             \/                                            

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
export PATH="$HOME/.local/share/nvim/lsp_servers/gopls:$PATH"
export PATH="$HOME/.local/share/nvim/lsp_servers/bashls:$PATH"

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
  export PATH="$PATH:/home/austin/Software/arbinger/publishedConsoleApps/ProcessSalesforceOrders/"
fi

export PATH="$PATH:/home/austin/.BrowserDrivers/"

# User specific aliases and functions
# LS overwrite using lsd, a much better file display tool
alias nuget="mono /usr/local/bin/nuget.exe"
alias ls='exa'
alias lsa='exa -all'

alias mv='mv -i'

alias python=python3

alias vim='nvim'
alias v='nvim'

alias gs='git status'
alias gp='git push'

alias :G='git $1'
alias randombg='feh --randomize --bg-scale ~/Pictures/*'
alias showrouters='nmcli device wifi list'
alias updatestarship='sh -c "$(curl -fsSL https://starship.rs/install.sh)"'
alias evimrc='vim ~/.vimrc'
alias ssh-arblaptop='ssh austin@192.168.1.19'
alias startDefaultNetwork='sudo virsh net-start default'
alias mountFilesDrive='udisksctl mount -b /dev/sda1'
alias rider='~/Downloads/"JetBrains Rider-2021.2.2"/bin/rider.sh'
  export DENO_INSTALL="/home/austin/.deno"
  export PATH="$DENO_INSTALL/bin:$PATH"
alias gcane='git commit --amend --no-edit'
alias arbPortal='~/.dotfiles/arbPortalTmux.sh'
alias arbPortalUnitTests='~/.dotfiles/arbPortalUnitTestsTmux.sh'
alias goKanban='~/.dotfiles/goKanbanTmux.sh'
alias swd='~/.dotfiles/secondswebdevTmux.sh'
alias startSqlServer='sudo docker start sql2019'
alias stopSqlServer='sudo docker stop sql2019' #https://theserogroup.com/sql-server/getting-started-with-sql-server-in-a-docker-container/
alias autoUploadToAsana='~/Software/arbinger/autoUploadToAsana/bin/release/net5.0/linux-x64/publish/autoUploadToAsana -f ~/Software/arbinger/autoUploadToAsana/config.json'
alias colemakdh='sudo kmonad ~/.dotfiles/kmonad-layouts/colemak-dh-extend-ansi.kbd'
alias startJellyfinFiles='podman run --detach --label "io.containers.autoupdate=registry" --name jellyfinssd --publish 8096:8096/tcp --rm --user $(id -u):$(id -g) --userns keep-id --volume jellyfin-cache:/cache:Z --volume jellyfin-config:/config:Z --mount type=bind,source=/home/austin/Files/Jellyfin,destination=/Jellyfin,ro=true docker.io/jellyfin/jellyfin:latest'

if [[ "${splitIFS[1]}" == "$desktopName" ]]
then
  # colorscript -r
  paleofetch
else
  pfetch
fi

export VISUAL=nvim
export EDITOR="$VISUAL"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
. "$HOME/.cargo/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/home/austin/WebDrivers
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# Android Studio/React Native Dev Setup
export ANDROID_HOME=/home/austin/Android/Sdk/
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Add custom path to Omnisharp
export PATH=$PATH:/home/austin/Software/omnisharp
export PATH=$PATH:/home/austin/.local/bin/netcoredbg/

# Learned about thefuck the other day, and experimenting with it
# eval $(thefuck --alias fuck)

# batcat does not support piping right away, which is a dealbreaker, I will use batcat specifically instead of aliasing over cat
# if command -v batcat >/dev/null 2>&1; then
#   alias cat='batcat'
# else
#   echo "Batcat not found, if you are on an ubuntu based machine please run: sudo apt install batcat"
# fi

# This command is the ideal brightness for my laptop on the go
# sudo brightnessctl set 100%

# Start tmux by default whenever a launch a new terminal
# if [[ -z "$TMUX"  ]]; then
#   if ! tmux has-session -t "$USER"; then
#     tmux new-session -d -s "$USER"
#   fi
#   tmux a -t "$USER"
# fi
#
set -o vi

eval "$(starship init bash)"
