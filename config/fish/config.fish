if status is-interactive
    starship init fish | source

    function mark_prompt_start --on-event fish_prompt
        echo -en "\e]133;A\e\\"
    end
end

alias ls='exa -lahF --icons=always'
alias grep='grep --color=auto'
