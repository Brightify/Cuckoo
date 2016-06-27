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

The generated files contain enough information to give you the right amount of power. They work based on inheritance and protocol adoption. This means that only overridable things can be mocked. We currently support all features which fulfill this rule except for things listed in TODO. Due to the complexity of Swift it is not easy to check for all edge cases so if you find some unexpected behavior please report it in issues.  

## TODO

We are still missing support for some important features like:
* static properties
* static methods
* generics

## What will not be supported

Due to the limitations mentioned above, basically all things which don't allow overriding cannot be supported. This includes:
* `struct` - workaround is to use a common protocol
* everything with `final` or `private` modifier
* global constants and functions

## Requirements

Cuckoo works on the following platforms:

- **iOS 8+**
- **Mac OSX 10.9+**
- **tvOS 9+**

We plan to add a **watchOS 2+** support soon.

## Cuckoo

### Installation

#### CocoaPods
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

#### Carthage
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

### Usage

Usage of Cuckoo is similar to [Mockito](http://mockito.org/) and [Hamcrest](http://hamcrest.org/). But there are some differences and limitations caused by generating the mocks and Swift language itself. List of all supported features can be found [here](https://github.com/SwiftKit/CuckooGenerator). You can find complete example in [tests](Tests) concretely in [CuckooAPITest](Tests/CuckooAPITest.swift).

#### Mock initialization

Mocks can be created with parameterless constructor. If you want to spy on object instead, pass it as `spyOn` parameter. Name of mock class always corresponds to name of the mocked class/protocol with 'Mock' prefix. For example mock of protocol `Greeter` has a name `MockGreeter`.  

```Swift
let mock = MockGreeter()
let spy = MockGreeter(spyOn: aRealInstanceOfGreeter)
```

#### Stubbing

Stubbing can be done by calling methods as parameter of `when` function. The stub call must be done on special stubbing object. You can get a reference to it with `stub` function. This function takes an instance of mock which you want to stub and a closure in which you can do the stubbing. Parameter of this closure is the stubbing object.

Note: It is currently possible for the subbing object to escape from the closure. You can still use it to stub calls but it is not recommended practice and behavior of this may change in the future.

After calling the `when` function you can specify what to do next with following methods:

```Swift
/// Invoke `implementation` when invoked.
then(implementation: IN throws -> OUT)

/// Return `output` when invoked.
thenReturn(output: OUT, _ outputs: OUT...)

/// Throw `error` when invoked.
thenThrow(error: ErrorType, _ outputs: OUT...)

/// Invoke real implementation when invoked.
thenCallRealImplementation()

/// Do nothing when invoked.
thenDoNothing()
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

It is possible to chain stubbing. This is useful if you need to set different behavior for multiple calls in order. The last behavior will last for all other calls. Syntax goes like this:

```Swift
when(stub.readWriteProperty.get).thenReturn(10).thenReturn(20)
```

which is equivalent to:

```Swift
when(stub.readWriteProperty.get).thenReturn(10, 20)
```

In both cases first call to `readWriteProperty` will return `10` and every other will return `20`.

You can combine the stubbing method as you like.

When looking for stub match Cuckoo gives the highest priority to last call of `when`. This means that calling `when` multiple times with the same function and matchers effectively overrides previous call. Also more general parameter matchers have to be used before specific ones.

```Swift
when(stub.countCharacters(anyString())).thenReturn(10)
when(stub.countCharacters("a")).thenReturn(1)
```

In this example calling `countCharacters` with `a` will return `1`. If you reversed the order of stubbing then the output would be `10`.

#### Usage in real code

After previous steps the stubbed method can be called. It is up to you to inject this mock into your production code.

Note: Call on mock which wasn't stubbed will cause error. In case of spy, the real code will execute.

#### Verification

For verifying calls there is function `verify`. Its first parameter is mocked object, optional second parameter is call matcher. Then the call with its parameters follows.

```Swift
verify(mock).greetWithMessage("Hello world")
```

Verification of properties is similar to their stubbing.

#### Parameter matchers

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

#### Call matchers

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

#### Resetting mocks

Following functions are used to reset stubbing and/or invocations on mocks.

```Swift
/// Clear all invocations and stubs of mocks.
reset<M: Mock>(mocks: M...)

/// Clear all stubs of mocks.
clearStubs<M: Mock>(mocks: M...)

/// Clear all invocations of mocks.
clearInvocations<M: Mock>(mocks: M...)
```

## Cuckoo generator

### Installation

For normal use you can skip this because [run script](https://github.com/SwiftKit/Cuckoo/blob/master/run) in Cuckoo downloads and builds correct version of the generator automatically.

#### Homebrew

Simply run `brew install cuckoo` and you are ready to go.

#### Custom

This is more complicated path. You need to clone this repository and build it yourself. You can look in the [run script](https://github.com/SwiftKit/Cuckoo/blob/master/run) for more inspiration.

### Usage

Generator can be called through a terminal. Each call consists of command, options and arguments. Options and arguments depends on used command. Options can have additional parameters. Names of all of them are case sensitive. The order goes like this:

```Bash
cuckoo command options arguments
```

#### `generate` command

Generates mock files.

This command accepts arguments, in this case list (separated by spaces) of files for which you want to generate mocks. Also more options can be used to adjust behavior, these are listed below.

##### `--output` (string)

Where to put the generated mocks.

If a path to a directory is supplied, each input file will have a respective output file with mocks.

If a path to a Swift file is supplied, all mocks will be in a single file.

Default value is `GeneratedMocks.swift`.

##### `--testable` (string)

A comma separated list of frameworks that should be imported as @testable in the mock files.

##### `--no-header`

Do not generate file headers.

##### `--no-timestamp`

Do not generate timestamp.

#### `version` command

Prints the version of this generator.

#### `help` command

Display general or command-specific help.

After the `help` you can write name of another command for displaying a command-specific help.

## Authors

* Tadeas Kriz, [tadeas@brightify.org](mailto:tadeas@brightify.org)
* Filip Dolník, [filip@brightify.org](mailto:filip@brightify.org)

## Inspiration

* [Mockito](http://mockito.org/) - Mocking DSL
* [Hamcrest](http://hamcrest.org/) - Matcher API

## Used libraries

* [Commandant](https://github.com/Carthage/Commandant)
* [Result](https://github.com/antitypical/Result)
* [FileKit](https://github.com/nvzqz/FileKit)
* [SourceKitten](https://github.com/jpsim/SourceKitten)

## License

Cuckoo is available under the [MIT License](LICENSE).
