function git_branch
    set -g git_branch (git rev-parse --abbrev-ref HEAD ^ /dev/null)
    if [ $status -ne 0 ]
        set -ge git_branch
    else
        set dirty_count (git status --porcelain | wc -l)
        if [ $dirty_count -gt 0 ]
            set -g git_branch "$git_branch*"
        end
    end
end

function fish_prompt
    printf (date "+%H:%M:%S ")

    set_color $fish_color_cwd
    printf (prompt_pwd)
    printf " "
    set_color normal

    git_branch
    if set -q git_branch
        printf "($git_branch) "
    end

    echo
    printf "> "
end

