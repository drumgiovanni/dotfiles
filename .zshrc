# Created by newuser for 5.7.1

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# 日本語を使用
export LANG=ja_JP.UTF-8

# パスを追加したい場合
export PATH="$HOME/bin:$PATH"

# 色を使用
autoload -Uz colors
colors

# 補完
autoload -Uz compinit
compinit

# 他のターミナルとヒストリーを共有
setopt share_history

# ヒストリーに重複を表示しない
setopt histignorealldups

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# 自動でpushdを実行
setopt auto_pushd

# cdコマンドを省略して、ディレクトリ名のみの入力で移動
setopt auto_cd

# コマンドミスを修正
setopt correct

# cdの後にlsを実行
chpwd() { ls -ltr --color=auto }

# どこからでも参照できるディレクトリパス
cdpath=(~)

# プロンプトを2行で表示、時刻を表示
PROMPT="%(?.%{${fg[green]}%}.%{${fg[red]}%})%n${reset_color}@${fg[blue]}%m${reset_color}(%*%) %~
%# "

# Ctrl+rでヒストリーのインクリメンタルサーチ、Ctrl+sで逆順
bindkey '^r' history-incremental-pattern-search-backward
bindkey '^s' history-incremental-pattern-search-forward

# git設定
RPROMPT="%{${fg[blue]}%}[%~]%{${reset_color}%}"
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats "%F{green}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () { vcs_info }
RPROMPT=$RPROMPT'${vcs_info_msg_0_}'

function find_cd() {
  cd "$(find . -type d | peco)"
}
alias fc="find_cd"

# === cool-peco init ===
FPATH="$FPATH:/home/giovanni/go/src/github.com/ryoppy/cool-peco"
autoload -Uz cool-peco
cool-peco
# ======================
source /usr/share/nvm/init-nvm.sh

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
source $HOME/.cargo/env
