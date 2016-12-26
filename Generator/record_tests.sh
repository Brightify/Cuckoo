#!/usr/bin/env bash
./run_tests.sh "$@"
for file in Build/log/*/*.swift; do 
	fileName="$(echo "$file" | awk -F"/" '{print $NF}')"
	expectedFile="Tests/SourceFiles/Expected/$fileName"
	if [ -f "$expectedFile" ]; then
		cp "$file" "$expectedFile"
	fi
done
