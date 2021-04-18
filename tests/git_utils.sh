#!/bin/bash

function create_commit {
    create_commit_with_file_content "$(date +%N)" ""
}

function create_commit_with_file_content {
    (( $# < 2 )) && echo "parameters not specified. \$1: file name, \$2: file content" && exit 1

    current_branch=$(git branch --show-current)

    printf "$2" > "$1"
    git add "$1"
    git commit -m "commit n $(git rev-list --count $current_branch 2> /dev/null || echo 0) on branch $current_branch"
}

function setup_task {
    mkdir remote && cd "$_"

    # remote repo
    git init
    git config receive.denyCurrentBranch 'updateInstead'
    create_commit

    # local repo
    cd ..
    mkdir "local" && cd "$_"

    git clone ../remote .

    open-task.sh "$1" "$2"
}