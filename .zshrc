# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="~/bin:$PATH"
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="gentoo"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git gradle zsh-syntax-highlighting zsh-autosuggestions)
plugins=()
source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8
export EDITOR=vim
# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
bindkey "\eOc" forward-word
bindkey "\eOd" backward-word
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word
bindkey "\e[5C" forward-word
bindkey "\e[5D" backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word

catv() {
	if [[ -t 1 ]]; then 
		/bin/cat -v $* ; 
	else
		/bin/cat $*; 
	fi
}

bar_size=40
bar_char_done="#"
bar_char_todo=" "
bar_percentage_scale=2

progressbar() {
	local current_val="$1"
	local target_val="$2"
	local width=20
	
	local done_ratio=$(echo "scale=8; ${current_val} / ${target_val}" | bc)
	
	local pixels_done=$(echo "scale=0; ${width} * ${done_ratio}" | bc)
	local pixels_remaining=$(echo "scale=0; ${width} * (1-${done_ratio})" | bc)

	printf "\r["
	printf "%${pixels_done}s" "" | tr ' ' '#'
	printf "%${pixels_remaining}s]" ''
	
}


dirtyBytes() {
	awk '/Dirty:|Writeback:/ {print $2 $3}' /proc/meminfo|tr 'k' 'K'|numfmt --from=iec --suffix B|tr -d 'B'|awk '{sum+=$1} END{print sum}'
}

formatSeconds() {
	local seconds="$1"
	local t=

	if [ "$seconds" -gt 3600 ]; then
		t=$((seconds / 3600))
		seconds=$((seconds % 3600))
		echo -n "${t}h "
	fi
	if [ "$seconds" -gt 60 ]; then
		t=$((seconds / 60))
		seconds=$((seconds % 60))
		echo -n "${t}m "
	fi
	echo "${t}s"
}



syncv() {
	local start_b=$(dirtyBytes)
	local start_ts=$(date +%s)

	local now_b=
	local now_ts=

	local elapsed=
	local written=
	local speed=

	local remaining_nice=
	local time_estimate=
	local speed_nice=

	set +m
	sync &
	while [ -e /proc/$! ]; do
		sleep 0.1
		now_b=$(dirtyBytes)
		now_ts=$(date +%s)
		elapsed=$((now_ts-start_ts))
		written=$((now_b-start_b))
		
		if [ $elapsed -eq 0 ]; then
			continue
		fi
		
		speed=$((written/elapsed))

		remaining_nice=$(echo "${now_b}" | numfmt --to iec --suffix B)
		speed_nice=$(echo "${speed}" | numfmt --to iec --suffix B/s)
		time_estimate=$(formatSeconds $((now_b/speed)))

		if [ "${speed}" -lt "0" ]; then
			echo -n "\rsync: writeback increasing. Remaining: ${remaining_nice}"
			start_b=$(dirtyBytes)
			start_ts=$(date +%s)
		else
			echo "\r$(progressbar "${writen}" "${start_b}") Remaining: ${remaining_nice} (${time_estimate} - syncing at ${speed_nice}"
		fi
	done
	set -m

	echo ""
}



export GRAPHVIZ_DOT=/usr/bin/dot
#export LC_TIME=en_IE.UTF-8
export JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8
export MC_SKIN=$HOME/.mc/selenized.ini

#export JDK_HOME=/usr/lib/jvm/jdk1.8.0_181_x64; export JAVA_HOME=$JDK_HOME; export PATH=$JDK_HOME/bin:$PATH

