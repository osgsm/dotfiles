export EDITOR=vim
export LANG="ja_JP.UTF-8"
export LC_COLLATE="ja_JP.UTF-8"
export LC_CTYPE="ja_JP.UTF-8"
export LC_MESSAGES="ja_JP.UTF-8"
export LC_MONETARY="ja_JP.UTF-8"
export LC_NUMERIC="ja_JP.UTF-8"
export LC_TIME="ja_JP.UTF-8"

PS1='%~ %# '

# Use colors in coreutils utilities output
alias ls='ls --color=auto'
alias grep='grep --color'

# ls aliases
alias ll='ls -lah'
alias la='ls -A'
alias l='ls'

# Aliases to protect against overwriting
alias cp='cp -i'
alias mv='mv -i'
# alias rm='rm -i'

# Navigation aliases
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~"
alias -- -="cd -"

# Shortcuts
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias p="cd ~/Projects"
alias g="git"

# pnpm aliases
alias pn="pnpm"
alias pni="pnpm install"
alias pnid="pnpm install --save-dev"
alias pnig="pnpm install -g"
alias pnun="pnpm uninstall"
alias pnung="pnpm uninstall -g"
alias pnl="pnpm list --depth=0"
alias pnu="pnpm update"
alias pnug="pnpm update-g"
alias pno="pnpm outdated"
alias pnr="pnpm run"
alias pnrd="pnpm run dev"
alias pnrb="pnpm run build"
alias pnrs="pnpm run start"
alias pnrp="pnpm run preview"

# Yarn aliases
alias y="yarn"
alias yi="yarn init -y"
alias ya="yarn add"
alias yr="yarn remove"
alias yad="yarn add -D"
alias yga="yarn global add"
alias ygr="yarn global remove"
alias yu="yarn upgrade"
alias ygu="yarn global upgrade"
alias yl="yarn list --depth=0"
alias ygl="yarn global list --depth=0"
alias yo="yarn outdated"
alias yd="yarn dev"
alias yb="yarn build"
alias ys="yarn start"

# npm aliases
alias ni="npm install"
alias nid="npm install --save-dev"
alias nig="npm install -g"
alias nun="npm uninstall"
alias nung="npm uninstall -g"
alias nl="npm list --depth=0"
alias nu="npm update"
alias nug="npm update-g"
alias no="npm outdated"
alias nr="npm run"
alias nrd="npm run dev"
alias nrb="npm run build"
alias nrs="npm run start"
alias nrp="npm run preview"

# zsh-completions
if type brew &>/dev/null; then
 	FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
 
 	autoload -Uz compinit
 	compinit
fi

# zsh-autosuggestions
 source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# set vim key bind
bindkey -v

# n
export N_PREFIX=$HOME/.n
export PATH=$N_PREFIX/bin:$PATH

[[ -e ~/.phpbrew/bashrc ]] && source ~/.phpbrew/bashrc

# depot_tools
export PATH=$HOME/Tools/depot_tools:$PATH

# bun completions
[ -s "/Users/osgsm/.bun/_bun" ] && source "/Users/osgsm/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# composer
export PATH="$HOME/.composer/vendor/bin:$PATH"

# bat
export BAT_THEME="OneHalfDark"

# Starship
eval "$(starship init zsh)"

# flutter
export PATH="$HOME/flutter/bin:$PATH"

# VS Code
export COREPACK_ENABLE_AUTO_PIN=0

# pnpm
export PNPM_HOME="/Users/osgsm/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# GitHub CLI
prco () {
    gh pr list;
    echo "Type the number of PR to checkout: " && read number;
    gh pr checkout ${number};
}
