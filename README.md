# Cuckoo
## Mock your Swift objects!

[![CI Status](http://img.shields.io/travis/SwiftKit/Cuckoo.svg?style=flat)](https://travis-ci.org/SwiftKit/Cuckoo)
[![Version](https://img.shields.io/cocoapods/v/Cuckoo.svg?style=flat)](http://cocoapods.org/pods/Cuckoo)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/Cuckoo.svg?style=flat)](http://cocoapods.org/pods/Cuckoo)
[![Platform](https://img.shields.io/cocoapods/p/Cuckoo.svg?style=flat)](http://cocoapods.org/pods/Cuckoo)
[![Slack Status](http://swiftkit.brightify.org/badge.svg)](http://swiftkit.brightify.org)

## Introduction

Cuckoo was created due to lack of a proper Swift mocking framework. We built the DSL to be very similar to [Mockito](http://mockito.org/), so anyone using it in Java/Android can immediately pick it up and use it.

To have a chat, [join our Slack team](http://swiftkit.brightify.org)!

## How does it work

Cuckoo has two parts. One is the [runtime](https://github.com/SwiftKit/Cuckoo) and the other one is an OS X command-line tool simply called [CuckooGenerator](https://github.com/SwiftKit/CuckooGenerator).

Unfortunately Swift does not have a proper reflection, so we decided to use a compile-time generator to go through files you specify and generate supporting structs/classes that will be used by the runtime in your test target.

The generated files contain enough information to give you the right amount of power. They work based on inheritance and protocol adoption. This means that only overridable things can be mocked. We currently support all features which fulfill this rule except for things listed in TODO. Due to the complexity of Swift it is not easy to check for all edge cases so if you find some unexpected behavior please report it in issues.  

## Changelog

List of all changes and new features can be found [here](CHANGELOG.md).

## TODO

We are still missing support for some important features like:  

* <del>inheritance (grandparent methods)</del>
* generics  
* type inference for instance variables (you need to write it explicitly, otherwise it will be replaced with "__UnknownType")  

## What will not be supported

Due to the limitations mentioned above, basically all things which don't allow overriding cannot be supported. This includes:
* `struct` - workaround is to use a common protocol
* everything with `final` or `private` modifier
* global constants and functions
* static properties and methods

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
# Define output file. Change "$PROJECT_DIR/Tests" to your test's root source folder, if it's not the default name.
OUTPUT_FILE="$PROJECT_DIR/Tests/GeneratedMocks.swift"
echo "Generated Mocks File = $OUTPUT_FILE"

# Define input directory. Change "$PROJECT_DIR" to your project's root source folder, if it's not the default name.
INPUT_DIR="$PROJECT_DIR"
echo "Mocks Input Directory = $INPUT_DIR"

# Generate mock files, include as many input files as you'd like to create mocks for.
${PODS_ROOT}/Cuckoo/run generate --testable "$PROJECT_NAME" \
--output "${OUTPUT_FILE}" \
"$INPUT_DIR/FileName1.swift" \
"$INPUT_DIR/FileName2.swift" \
"$INPUT_DIR/FileName3.swift"
# ... and so forth

# After running once, locate `GeneratedMocks.swift` and drag it into your Xcode test target group.
```

Input files can be also specified directly in `Run script` in `Input Files` form. To force run script to rebuild generator even if it already exists, use `--clean` as first argument.

Notes: All paths in the Run script must be absolute. Variable `PROJECT_DIR` automatically points to your project directory.  
Also include paths to inherited Classes and Protocols for mocking/stubbing parent and grandparents.  

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

Usage of Cuckoo is similar to [Mockito](http://mockito.org/) and [Hamcrest](http://hamcrest.org/). But there are some differences and limitations caused by generating the mocks and Swift language itself. List of all supported features can be found below. You can find complete example in [tests](Tests).

#### Mock initialization

Mocks can be created with the same constructors as the mocked type. If you want to spy on object you can call `spy(on: Type)` method. Name of mock class always corresponds to name of the mocked class/protocol with `Mock` prefix. For example mock of protocol `Greeter` has a name `MockGreeter`.  

```Swift
let mock = MockGreeter()
let spy = MockGreeter().spy(on: aRealInstanceOfGreeter)
```

#### Stubbing

Stubbing can be done by calling methods as parameter of `when` function. The stub call must be done on special stubbing object. You can get a reference to it with `stub` function. This function takes an instance of mock which you want to stub and a closure in which you can do the stubbing. Parameter of this closure is the stubbing object.

Note: It is currently possible for the subbing object to escape from the closure. You can still use it to stub calls but it is not recommended practice and behavior of this may change in the future.

After calling the `when` function you can specify what to do next with following methods:

```Swift
/// Invokes `implementation` when invoked.
then(_ implementation: IN throws -> OUT)

/// Returns `output` when invoked.
thenReturn(_ output: OUT, _ outputs: OUT...)

/// Throws `error` when invoked.
thenThrow(_ error: ErrorType, _ errors: Error...)

/// Invokes real implementation when invoked.
thenCallRealImplementation()

/// Does nothing when invoked.
thenDoNothing()
```

Which methods can be used depends on the stubbed method. For example you cannot use the `thenThrow` method with method which cannot throw exception.

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

Notice the `get` and `set` these will be used in verification later.

##### Chain stubbing

It is possible to chain stubbing. This is useful if you need to set different behavior for multiple calls in order. The last behavior will last for all other calls. Syntax goes like this:

```Swift
when(stub.readWriteProperty.get).thenReturn(10).thenReturn(20)
```

which is equivalent to:

```Swift
when(stub.readWriteProperty.get).thenReturn(10, 20)
```

In both cases first call to `readWriteProperty` will return `10` and every other will return `20`.

You can combine the stubbing methods as you like.

##### Overriding of stubbing

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

You can check if there are no more interactions on mock with function `verifyNoMoreInteractions`.

##### Argument capture

You can use `ArgumentCaptor` to capture arguments in verification of calls (doing that in stubbing is not recommended). Here is an example code:

```Swift
mock.readWriteProperty = 10
mock.readWriteProperty = 20
mock.readWriteProperty = 30

let argumentCaptor = ArgumentCaptor<Int>()
verify(mock, times(3)).readWriteProperty.set(argumentCaptor.capture())
argumentCaptor.value // Returns 30
argumentCaptor.allValues // Returns [10, 20, 30]
```

As you can see, method `capture()` is used to create matcher for the call and then you can get the arguments via properties `value` and `allValues`. `value` returns last captured argument or nil if none. `allValues` returns array with all captured values.

#### Parameter matchers

As parameters of methods in stubbing and verification you can use objects which conform to `Matchable` protocol.

These basic values are extended to conform to `Matchable`:

* `Bool`
* `String`
* `Float`
* `Double`
* `Character`
* `Int`
* `Int8`
* `Int16`
* `Int32`
* `Int64`
* `UInt`
* `UInt8`
* `UInt16`
* `UInt32`
* `UInt64`

Note: Optional types (for example `Int?`) cannot be used directly. You need to wrap them with `equal(to)` function.

`ParameterMatcher` also conform to `Matchable`. You can create your own `ParameterMatcher` instances or if you want to directly use your custom types there is the `Matchable` protocol. Standard instances of `ParameterMatcher` can be obtain via these functions:

```Swift
/// Returns an equality matcher.
equal<T: Equatable>(to value: T)

/// Returns an identity matcher.
equal<T: AnyObject>(to value: T)

/// Returns a matcher using the supplied function.
equal<T>(to value: T, equalWhen equalityFunction: (T, T) -> Bool)

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

Matching of nil can be achieved with `equal(to: nil)`.

`Matchable` can be chained with methods `or` and `and` like so:

```Swift
verify(mock).greetWithMessage("Hello world".or("Hallo Welt"))
```

#### Call matchers

As a second parameter of `verify` function you can use instances of `CallMatcher`. Its primary function is to assert how many times was the call made. But the `matches` function has a parameter of type `[StubCall]` which means you can use custom `CallMatcher` to inspect the stub calls or for some side effect.

Note: Call matchers are applied after the parameter matchers. So you get only stub calls of wanted method with correct arguments.

Standard call matchers are:

```Swift
/// Returns a matcher ensuring a call was made `count` times.
times(_ count: Int)

/// Returns a matcher ensuring no call was made.
never()

/// Returns a matcher ensuring at least one call was made.
atLeastOnce()

/// Returns a matcher ensuring call was made at least `count` times.
atLeast(_ count: Int)

/// Returns a matcher ensuring call was made at most `count` times.
atMost(_ count: Int)
```

As with `Matchable` you can chain `CallMatcher` with methods `or` and `and`. But you cannot mix `Matchable` and `CallMatcher` together.

#### Resetting mocks

Following functions are used to reset stubbing and/or invocations on mocks.

```Swift
/// Clears all invocations and stubs of mocks.
reset<M: Mock>(_ mocks: M...)

/// Clears all stubs of mocks.
clearStubs<M: Mock>(_ mocks: M...)

/// Clears all invocations of mocks.
clearInvocations<M: Mock>(_ mocks: M...)
```

#### Stub objects

Stubs are used in case when you want to suppress real code. Stubs are different from Mocks in that they don't support stubbing and verification. They can be created with the same constructors as the mocked type. Name of stub class always corresponds to name of the mocked class/protocol with `Stub` suffix. For example stub of protocol `Greeter` has a name `GreeterStub`.  

```Swift
let stub = GreeterStub()
```

When method or property is called on stub nothing happens. If some type has to be returned then `DefaultValueRegistry` will provide default value. Stubs can be used to set implicit (no) behavior to mocks without the need to use `thenDoNothing()` like this: `MockGreeter().spy(on: GreeterStub())`.

##### DefaultValueRegistry

`DefaultValueRegistry` is used in Stubs to get default values for return types. It knows only default Swift types, sets, arrays, dictionaries, optionals and tuples (up to 6 values). Tuples for more values can be added with extensions. Custom types must be registered before usage with `DefaultValueRegistry.register<T>(value: T, forType: T.Type)`. Default values can be changed with the same method. Sets, arrays, etc. do not have to be registered if their generic type is already registered.

Method `DefaultValueRegistry.reset()` can be used to delete all value registered by user.

## Cuckoo generator

### Installation

For normal use you can skip this because [run script](run) in Cuckoo downloads and builds correct version of the generator automatically.

#### Custom

This is more complicated path. You need to clone this repository and build it yourself. You can look in the [run script](run) for more inspiration.

### Usage

Generator can be called through a terminal. Each call consists of command, options and arguments. Options and arguments depends on used command. Options can have additional parameters. Names of all of them are case sensitive. The order goes like this:

```
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

##### `--exclude` (string)

A comma separated list of classes and protocols that should be skipped during mock generation.  

##### `--no-header`

Do not generate file headers.

##### `--no-timestamp`

Do not generate timestamp.

##### `--no-inheritance`

Do not mock/stub parents and grandparents.

##### `--file-prefix`

Names of generated files in directory will start with this prefix. Only works when output path is directory.

##### `--no-class-mocking`

Do not generate mocks for classes.

#### `version` command

Prints the version of this generator.

#### `help` command

Display general or command-specific help.

After the `help` you can write name of another command for displaying a command-specific help.

## Authors

* Tadeas Kriz, [tadeas@brightify.org](mailto:tadeas@brightify.org)
* Filip Dolník, [filip@brightify.org](mailto:filip@brightify.org)
* Adriaan (Arjan) Duijzer [arjan@nxtstep.nl](mailto:arjan@nxtstep.nl)

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
