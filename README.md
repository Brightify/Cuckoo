# Cuckoo
## Mock your Swift objects!

[![CI Status](http://img.shields.io/travis/SwiftKit/Cuckoo.svg?style=flat)](https://travis-ci.org/SwiftKit/Cuckoo)
[![Version](https://img.shields.io/cocoapods/v/Cuckoo.svg?style=flat)](http://cocoapods.org/pods/Cuckoo)
[![License](https://img.shields.io/cocoapods/l/Cuckoo.svg?style=flat)](http://cocoapods.org/pods/Cuckoo)
[![Platform](https://img.shields.io/cocoapods/p/Cuckoo.svg?style=flat)](http://cocoapods.org/pods/Cuckoo)
[![Slack Status](http://swiftkit.tmspark.com/badge.svg)](http://swiftkit.tmspark.com)

## Introduction

Cuckoo was created due to lack of a proper Swift mocking framework. We built the DSL to be very similar to Mockito, so anyone using it in Java/Android can immediately pick it up and use it.

To have a chat, [join our Slack team](http://swiftkit.tmspark.com)!

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

And add the following `Run script` build phase to your test target's `Build Phases`:

```
# Define output file; change "${PROJECT_NAME}Tests" to your test's root source folder, if it's not the default name
OUTPUT_FILE="./${PROJECT_NAME}Tests/GeneratedMocks.swift"
echo "Generated Mocks File = ${OUTPUT_FILE}"

# Define input directory; change "${PROJECT_NAME}" to your project's root source folder, if it's not the default name
INPUT_DIR="./${PROJECT_NAME}"
echo "Mocks Input Directory = ${INPUT_DIR}"

# Generate mock files; include as many input files as you'd like to create mocks for
${PODS_ROOT}/Cuckoo/run generate --testable ${PROJECT_NAME} \
--output ${OUTPUT_FILE} \
${INPUT_DIR}/FileName1.swift \
${INPUT_DIR}/FileName2.swift \
${INPUT_DIR}/FileName3.swift
# ... and so forth

# After running once, locate `GeneratedMocks.swift` and drag it into your Xcode test target group
```

## Usage

For the example, lets say we generate the mock for the following protocol:

```Swift
protocol Greeter {
    func greet()
    
    func greetWithMessage(message: String)
    
    func messageForName(name: String) -> String
}
```

Then the generated mock will be named `MockGreeter`. Let's use it! 

```Swift
// Create a mock instance
let mock = MockGreeter()

// Create a spy instance
let spy = MockGreeter(spyOn: aRealInstanceOfGreeter)

// Start
stub(mock) { mock in
    // Allows calling the `greet` method, making it a `nop`.
    when(mock.greet()).thenReturn()
    
    // Allows calling the `greetWithMessage` with "Hello world". 
    when(mock.greetWithMessage("Hello world")).then { message in
        print(message)
    }
    
    // When calling method `messageForName` with any string, we make it return "Still the same" value.
    when(mock.messageForName(anyString())).thenReturn("Still the same")
    
    // Lets override the previous statement. Now calling the method with "Swift", it will return "Awesome!"
    // This does not change the behavior for input other than the "Swift".
    // The stubbing works in layers, the later defined is used.
    when(mock.messageForName("Swift")).thenReturn("Awesome!")
}

// Now it would be the time to use the mock, however for the sake of this example, we will only do some simple calls.

mock.greet() // This will work

mock.greetWithMessage("Hello world") // This will work as well and will print the message "Hello world" to console

mock.greetWithMessage("Well...") // This will fail, because it is was not stubbed

mock.messageForName("Anything in this world") // This will work and will return "Still the same"
mock.messageForName("Another thing in this world") // This will work and will return "Still the same" again

mock.messageForName("Swift") // Will work and will return "Awesome!"


// Last but not least, let's verify the mock was used as expected. All of these will succeed.
verify(mock).greet()

verify(mock, times(2)).greetWithMessage(anyString())
verify(mock).greetWithMessage("Hello world")
verify(mock).greetWithMessage("Well...")
verify(mock, never()).greetWithMessage("Was not called.")

verify(mock, times(3)).messageForName(anyString())
verify(mock).messageForName("Swift")

```

## Author

Tadeas Kriz, tadeas@brightify.org

## Inspiration

* [Mockito](http://mockito.org/) - Mocking DSL 
* [Hamcrest](http://hamcrest.org/) - Matcher API

## License

Cuckoo is available under the MIT license. See the LICENSE file for more info.
