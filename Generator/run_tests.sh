#!/usr/bin/env bash
if [ "$1" != "--no-build" ]; then
	rm -rf Build
	mkdir Build
	xcodebuild -project 'CuckooGenerator.xcodeproj' -scheme 'CuckooGenerator' -configuration 'Release' CONFIGURATION_BUILD_DIR=$(pwd)/Build clean build
fi
cd Tests
cucumber