#!/bin/bash

. "$(git --exec-path)/git-sh-setup"
set -e

test $(git branch --show-current) != "master" && die "you can only create a feature branch from master"
test "$#" -ne 2 && die "specify both the task id and the release type (major|minor|patch)"
[[ ! "$1" =~ ^[0-9]+$ ]] && die "task id must be a number"
[[ ! "$2" =~ ^(major|minor|patch)$ ]] && die "accepted release type: (major|minor|patch)"

# check if index is clear
[[ -n $(git diff --cached) ]] && die "commit the index changes or restore them before opening a new task"

# check if feature branch exists
git rev-parse --verify "refs/heads/feature/$1" &> /dev/null && die "branch feature/$1 already exists locally"
git fetch --dry-run origin "feature/$1" &> /dev/null && die "branch feature/$1 already exists remotely"

# check if local master is equal to remote master
test "$(git ls-remote origin refs/heads/master | awk '{print $1}')" != "$(git rev-parse refs/heads/master)" && 
    die "Remote master and local master points to different commits. Pull/push before opening a task"

# first commit with branch info
git checkout -b "feature/$1"
printf "$1" > .CI_TASKID
printf "$2" > .CI_NEXTRELEASE

git add .CI_TASKID .CI_NEXTRELEASE
git commit -m "branch feature/$1 started"

# if it fails it could mean that feature branch has been pushed in the meanwhile
git push origin "feature/$1"
