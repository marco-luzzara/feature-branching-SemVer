#!/bin/bash

function display_test_results {
	if (( $2 == 1 ))
	then 
		echo -e "$1 - \e[42;37m PASSED \e[0m"
	else
		echo -e "$1 - \e[41;37m FAILED \e[0m"
	fi
}

# setup 
for repo_container in *repo_container
do
	rm -rf "$repo_container"
done
mkdir -p test_logs

# run tests 
export PATH="$PATH:$(pwd)/.."

if (( $# == 0 ))
then 
	discovered_test_files=( *.test )
else
	discovered_test_files=( "$@" )
fi

. ./git_utils.sh
testDir=$(pwd)

for testFile in ${discovered_test_files[@]}
do
	(
		. ./$testFile
		tests=( $(compgen -A function test_) )

		echo "
		Found ${#tests[@]} tests in $testFile
		"

		for test in ${tests[@]}
		do
			mkdir "${test:5}_repo_container" && cd "$_"
			
			(set -e ; "$test" &> "$testDir/test_logs/${test:5}" ;)
			(($? == 0)) && display_test_results "${test:5}" 1 || display_test_results "${test:5}" 0
			
			cd "$testDir"
		done
	)
done
