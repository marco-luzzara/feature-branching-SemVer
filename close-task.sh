#!/bin/bash

. "$(git --exec-path)/git-sh-setup"
set -e

[[ ! $(git branch --show-current) =~ ^feature/[0-9]+$ ]] && die "you can close a task only if you are on a feature branch"

# check if CI files exist
test -f .CI_TASKID || die ".CI_TASKID does not exist. Cannot close a task without it"
test -f .CI_NEXTRELEASE || die ".CI_NEXTRELEASE does not exist. Cannot close a task without it"

taskId="$(cat .CI_TASKID)"
nextRelease="$(cat .CI_NEXTRELEASE)"

# check if master has new changes
test "$(git ls-remote origin refs/heads/master | awk '{print $1}')" != "$(git merge-base master feature/$taskId)" && 
    die "master branch has new changes. Merge/Rebase before closing the feature"

#git fetch origin master
