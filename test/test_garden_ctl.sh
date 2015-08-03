#!/bin/bash -e

test_script=$(mktemp -t $0)
erb -r ./test_helper.rb ../jobs/garden/templates/garden_ctl.erb > $test_script

source $test_script > /dev/null

failed=0

# If the configured size is less than the available size, use the configured size.
result=$(backing_store_size "50" "df-stub.txt" "cat")
if [ $result = "51200K" ]; then
	echo passed
else
	failed=1
	echo  failed: $result !=  "51200K"
fi

# If the configured size is -1, use the available size.
result=$(backing_store_size "-1" "df-stub.txt" "cat")
if [ $result = "592955372K" ]; then
	echo passed
else
	failed=1
	echo failed: $result !=  "592955372K"
fi

# If the configured size is greater than the available size, use the available size.
result=$(backing_store_size "900000" "df-stub.txt" "cat")
if [ $result = "592955372K" ]; then
	echo passed
else
	failed=1
	echo failed: $result !=  "592955372K"
fi

exit $failed
