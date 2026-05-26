if status is-interactive
    starship init fish | source

    function mark_prompt_start --on-event fish_prompt
        echo -en "\e]133;A\e\\"
    end
end

function clock
    printf '\e]4;4;#afafff\e\\'
    if contains -- -s $argv
        tty-clock -C 4 -D -s
    else
        tty-clock -C 4 -D
    end
    printf '\e]104;4\e\\'
end

function matrix
    printf '\e]4;4;#afafff\e\\'
    unimatrix -c blue -s 90
    printf '\e]104;4\e\\'
end

alias ls='exa -lahF --icons=always'
alias grep='grep --color=auto'
