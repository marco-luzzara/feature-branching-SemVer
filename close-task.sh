#!/bin/bash

. "$(git --exec-path)/git-sh-setup"
set -e

[[ ! $(git branch --show-current) =~ ^feature/[0-9]+$ ]] && die "you can close a task only if you are on a feature branch"

# check if CI files exist
test -f .CI_TASKID || die ".CI_TASKID does not exist. Cannot close a task without it"
test -f .CI_NEXTRELEASE || die ".CI_NEXTRELEASE does not exist. Cannot close a task without it"

[[ -n $(git diff --cached) ]] && die "commit the index changes or restore them before closing a task"

taskId="$(cat .CI_TASKID)"
nextRelease="$(cat .CI_NEXTRELEASE)"

# check if master has new changes
test "$(git ls-remote origin refs/heads/master | awk '{print $1}')" != "$(git rev-parse master)" && 
    die "master branch has new changes. Merge/Rebase before closing the feature"

# clean up .CI files
git rm .CI_TASKID
git rm .CI_NEXTRELEASE
git commit -m "cleaned CI files"

# create merge commit with no fast forward
git checkout master
(( $# == 1 )) && commit_description=$1 || commit_description="Merged branch feature/$taskId"
git merge --no-ff -m "rif. #${taskId}:${nextRelease}:$commit_description" "feature/$taskId"
