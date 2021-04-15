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
for test in ./*.test
do
	export PATH="$PATH:$(pwd)/.."
	testName=`basename "$test"`
	mkdir "${testName}_repo_container"
	$test &> "test_logs/${testName}" && display_test_results "$testName" 1 || display_test_results "$testName" 0
done
