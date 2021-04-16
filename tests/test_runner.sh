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
for test in *.test
do
	export PATH="$PATH:$(pwd)/.."

	mkdir "${test}_repo_container" && cd "$_"
	"../$test" &> "../test_logs/${test}" && display_test_results "$test" 1 || display_test_results "$test" 0
	cd ..
done
