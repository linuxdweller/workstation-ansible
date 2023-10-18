
PROMPT="%(?:%{$fg[green]%} :%{$fg[red]%} )"
#   
PROMPT+="${FG[117]}%c%{$reset_color%}\$(git_prompt_info)\$(virtualenv_prompt_info)${FG[133]}\$(git_prompt_status)%{$reset_color%} "

ZSH_THEME_GIT_PROMPT_PREFIX=" ${FG[012]}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="${fg[red]}*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_VIRTUALENV_PREFIX=" ["
ZSH_THEME_VIRTUALENV_SUFFIX="]"
