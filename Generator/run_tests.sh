#!/usr/bin/env bash
rm -rf Build
mkdir Build
xcodebuild -project 'CuckooGenerator.xcodeproj' -scheme 'CuckooGenerator' -configuration 'Release' CONFIGURATION_BUILD_DIR=$(pwd)/Build clean build
cd Tests
cucumber