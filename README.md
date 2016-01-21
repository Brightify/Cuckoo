# Cuckoo
## Mock your Swift objects!

[![CI Status](http://img.shields.io/travis/SwiftKit/Cuckoo.svg?style=flat)](https://travis-ci.org/SwiftKit/Cuckoo)
[![Version](https://img.shields.io/cocoapods/v/Cuckoo.svg?style=flat)](http://cocoapods.org/pods/Cuckoo)
[![License](https://img.shields.io/cocoapods/l/Cuckoo.svg?style=flat)](http://cocoapods.org/pods/Cuckoo)
[![Platform](https://img.shields.io/cocoapods/p/Cuckoo.svg?style=flat)](http://cocoapods.org/pods/Cuckoo)

## Introduction

Cuckoo was created due to lack of a proper Swift mocking framework. We built the DSL to be very similar to Mockito, so anyone using it in Java/Android can immediately pick it up and use it.

## How does it work

Cuckoo has two parts. One is the [runtime](https://github.com/SwiftKit/Cuckoo) and the other one is an OS X command-line tool simply called [CuckooGenerator](https://github.com/SwiftKit/CuckooGenerator).

Unfortunately Swift does not have a proper reflection, so we decided to use a compile-time generator to go through files you specify and generate supporting structs/classes that will be used by the runtime in your test target.

The generated files contain enough information to give you the right amount of power.

## Requirements

Cuckoo works on the following platforms:

- **iOS 8+**
- **Mac OSX 10.9+**
- **tvOS 9+**

We plan to add a **watchOS 2+** support soon.

## Installation

Cuckoo runtime is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your test target in your Podfile:

```
pod "Cuckoo"
```

And add the following `Run script` build phase to your test target's configuration:

```
# Find the installed Cuckoo version 
CUCKOO_VERSION=$(grep '\- Cuckoo' "$PROJECT_DIR/Podfile.lock" | grep -o '[0-9]\{1,\}\.[0-9]\{1,\}\.[0-9]\{1,\}')

# Used to ignore Xcode's environment
alias run="env -i PATH=$PATH, HOME=$HOME"

cuckoo runtime --check $CUCKOO_VERSION
cuckooReturn=$?

if [ $cuckooReturn == 1 ]; then
    # Update local brew repository and upgrade to latest Cuckoo generator
    run brew update
    run brew upgrade SwiftKit/cuckoo/cuckoo
elif [ $cuckooReturn == 127 ]; then
    # Update local brew repository and install latest Cuckoo generator
    run brew install SwiftKit/cuckoo/cuckoo
fi

# Generate mock files (you can use xcode build variables to declare relative paths)
cuckoo generate -version $CUCKOO_VERSION -testable SomeAppModule -output ./GeneratedMocks/ FileToMock.swift FileToMock2.swift FileToMock3.swift
```

## Usage



## Author

Tadeas Kriz, tadeas@brightify.org

## Inspiration

* [Mockito](http://mockito.org/) - Mocking DSL 
* [Hamcrest](http://hamcrest.org/) - Matcher API

## License

Cuckoo is available under the MIT license. See the LICENSE file for more info.