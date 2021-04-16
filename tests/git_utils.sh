#!/bin/bash

set -e

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