#!/usr/bin/env bash
FILE_NAME="cuckoo_generator.app"
if [[ "$1" == "--clean" || ! -d "$FILE_NAME" ]]; then
	rm -rf Build
	mkdir Build
	xcodebuild -project 'CuckooGenerator.xcodeproj' -scheme 'CuckooGenerator' -configuration 'Release' CONFIGURATION_BUILD_DIR="$PWD/Build" clean build
fi
cd Tests
cucumber
