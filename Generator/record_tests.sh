#!/usr/bin/env bash
./run_tests.sh "$@"
for file in Build/log/*/*.swift; do 
	fileName=$(echo "$file" | rev | cut -d"/" -f1 | rev)
	expectedFile="Tests/SourceFiles/Expected/${fileName}"
	if [ -f $expectedFile ]; then
		cp "$file" $expectedFile
	fi
done