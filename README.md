# Cuckoo
## Mock your Swift objects!

[![CI Status](http://img.shields.io/travis/SwiftKit/Cuckoo.svg?style=flat)](https://travis-ci.org/SwiftKit/Cuckoo)
[![Version](https://img.shields.io/cocoapods/v/Cuckoo.svg?style=flat)](http://cocoapods.org/pods/Cuckoo)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/Cuckoo.svg?style=flat)](http://cocoapods.org/pods/Cuckoo)
[![Platform](https://img.shields.io/cocoapods/p/Cuckoo.svg?style=flat)](http://cocoapods.org/pods/Cuckoo)
[![Slack Status](http://swiftkit.tmspark.com/badge.svg)](http://swiftkit.tmspark.com)

## Introduction

Cuckoo was created due to lack of a proper Swift mocking framework. We built the DSL to be very similar to [Mockito](http://mockito.org/), so anyone using it in Java/Android can immediately pick it up and use it.

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

### CocoaPods
Cuckoo runtime is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your test target in your Podfile:

```Ruby
pod "Cuckoo"
```

And add the following `Run script` build phase to your test target's `Build Phases`:

```Bash
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

Input files can be also specified directly in `Run script` in `Input Files` form.

### Carthage
To use Cuckoo with [Carthage](https://github.com/Carthage/Carthage) add in your Cartfile this line:
```
  github "SwiftKit/Cuckoo"
```

Then use the `Run script` from above and replace
```Bash
${PODS_ROOT}/Cuckoo/run
```
with
```Bash
Carthage/Checkouts/Cuckoo/run
```

Also don't forget to add the Framework into your project.

## Usage

Usage of Cuckoo is similar to [Mockito](http://mockito.org/) and [Hamcrest](http://hamcrest.org/). But there are some differences and limitations caused by generating the mocks and Swift language itself. List of all supported features can be found [here](https://github.com/SwiftKit/CuckooGenerator). You can find complete example in [tests](Tests) concretely in [CuckooAPITest](Tests/CuckooAPITest).

### Mock initialization

Mocks can be created with parameterless constructor. If you want to spy on object instead, pass it as `spyOn` parameter. Name of mock class always corresponds to name of the mocked class/protocol with 'Mock' prefix. For example mock of protocol `Greeter` has a name `MockGreeter`.  

```Swift
let mock = MockGreeter()
let spy = MockGreeter(spyOn: aRealInstanceOfGreeter)
```

### Stubbing

Stubbing can be done by calling methods as parameter of `when` function. The stub call must be done on special stubbing object. You can get a reference to it with `stub` function. This function takes an instance of mock which you want to stub and a closure in which you can do the stubbing. Parameter of this closure is the stubbing object.

Note: It is currently possible for the subbing object to escape from the closure. You can still use it to stub calls but it is not recommended practice and behavior of this may change in the future.

After calling the `when` function you can specify what to do next with following methods:

```Swift
/// Invoke `implementation` when invoked.
then(implementation: IN throws -> OUT)

/// Return `output` when invoked.
thenReturn(output: OUT)

/// Throw `error` when invoked.
thenThrow(error: ErrorType)
```

The stubbing of method can look like this:

```Swift
stub(mock) { stub in
  when(stub.greetWithMessage("Hello world")).then { message in
      print(message)
  }
}
```

And for property:

```Swift
stub(mock) { stub in
  when(stub.readWriteProperty.get).thenReturn(10)
  when(stub.readWriteProperty.set(anyInt())).then {
      print($0)
  }
}
```

### Usage in real code

After previous steps the stubbed method can be called. It is up to you to inject this mock into your production code.

Note: Call on mock which wasn't stubbed will cause error. In case of spy, the real code will execute.

### Verification

For verifying calls there is function `verify`. Its first parameter is mocked object, optional second parameter is call matcher. Then the call with its parameters follows.

```Swift
verify(mock).greetWithMessage("Hello world")
```

Verification of properties is similar to their stubbing.

### Parameter matchers

As parameters of methods in stubbing and verification you can use either basic value types or parameter matchers.

Value types which can be used directly are:

* `Bool`
* `Int`
* `String`
* `Float`
* `Double`
* `Character`

And this is list of available parameter matchers:

```Swift
/// All equalTo matchers have shortcut eq.

/// Returns an equality matcher.
equalTo<T: Equatable>(value: T)

/// Returns an identity matcher.
equalTo<T: AnyObject>(value: T)

/// Returns a matcher using the supplied function.
equalTo<T>(value: T, equalWhen equalityFunction: (T, T) -> Bool)

/// Returns a matcher matching any Int value.
anyInt()

/// Returns a matcher matching any String value.
anyString()

/// Returns a matcher matching any T value or nil.
any<T>(type: T.Type = T.self)

/// Returns a matcher matching any closure.
anyClosure()

/// Returns a matcher matching any non nil value.
notNil()
```

Matching of nil can be achieved with `eq(nil)`.

Both parameter matchers and call matchers can be chained with methods `or` and `and` like so:

```Swift
verify(mock).greetWithMessage(eq("Hello world").or("Hallo Welt"))
```

### Call matchers

As second parameter of `verify` function you can use call matcher, which specify how many times should be the call made. Supported call matchers are:

```Swift
/// Returns a matcher ensuring a call was made `count` times.
times(count: Int)

/// Returns a matcher ensuring no call was made.
never()

/// Returns a matcher ensuring at least one call was made.
atLeastOnce()

/// Returns a matcher ensuring call was made at least `count` times.
atLeast(count: Int)

/// Returns a matcher ensuring call was made at most `count` times.
atMost(count: Int)
```

## Author

Tadeas Kriz, tadeas@brightify.org

## Inspiration

* [Mockito](http://mockito.org/) - Mocking DSL
* [Hamcrest](http://hamcrest.org/) - Matcher API

## License

Cuckoo is available under the [MIT License](LICENSE).
