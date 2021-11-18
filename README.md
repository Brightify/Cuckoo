# Cuckoo
## Mock your Swift objects!

[![CI Status](https://img.shields.io/travis/Brightify/Cuckoo?style=flat)](https://travis-ci.org/Brightify/Cuckoo)
[![Version](https://img.shields.io/cocoapods/v/Cuckoo.svg?style=flat)](http://cocoapods.org/pods/Cuckoo)
[![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-brightgreen?style=flat)](https://swift.org/package-manager)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-brightgreen?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/Cuckoo.svg?style=flat)](http://cocoapods.org/pods/Cuckoo)
[![Platform](https://img.shields.io/cocoapods/p/Cuckoo.svg?style=flat)](http://cocoapods.org/pods/Cuckoo)

## Introduction
Cuckoo was created due to lack of a proper Swift mocking framework. We built the DSL to be very similar to [Mockito](http://mockito.org/), so anyone coming from Java/Android can immediately pick it up and use it.

## How does it work
Cuckoo has two parts. One is the [runtime](https://github.com/Brightify/Cuckoo) and the other one is an OS X command-line tool simply called [CuckooGenerator](https://github.com/SwiftKit/CuckooGenerator).

Unfortunately Swift does not have a proper reflection, so we decided to use a compile-time generator to go through files you specify and generate supporting structs/classes that will be used by the runtime in your test target.

The generated files contain enough information to give you the right amount of power. They work based on inheritance and protocol adoption. This means that only overridable things can be mocked. Due to the complexity of Swift it is not easy to check for all edge cases so if you find some unexpected behavior, please file an issue.

## Changelog
List of all changes and new features can be found [here](CHANGELOG.md).

## Features
Cuckoo is a powerful mocking framework that supports:

- [x] inheritance (grandparent methods)
- [x] generics
- [x] simple type inference for instance variables (works with initializers, `as TYPE` notation, and can be overridden by specifying type explicitly)
- [x] [Objective-C mocks utilizing OCMock](#objective-c-support)

## What will not be supported
Due to the limitations mentioned above, unoverridable code structures are not supportable by Cuckoo. This includes:
- `struct` - workaround is to use a common protocol
- everything with `final` or `private` modifier
- global constants and functions
- static properties and methods

## Requirements
Cuckoo works on the following platforms:

- **iOS 8+**
- **Mac OSX 10.9+**
- **tvOS 9+**

**watchOS** support is not yet possible due to missing XCTest library.

Note: Version `1.2.0` is the last one supporting **Swift 4.2**. Use versions `1.3.0`+ for **Swift 5** and up.

## Cuckoo
### 1. Installation
#### CocoaPods
Cuckoo runtime is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your test target in your Podfile:

```Ruby
pod "Cuckoo"
```

And add the following `Run script` build phase to your test target's `Build Phases` above the `Compile Sources` phase:

```Bash
if [ $ACTION == "indexbuild" ]; then
  echo "Not running Cuckoo generator during indexing."
  exit 0 
fi

# Skip for preview builds
if [ "${ENABLE_PREVIEWS}" = "YES" ]; then
  echo "Not running Cuckoo generator during preview builds."
  exit 0
fi

# Define output file. Change "${PROJECT_DIR}/${PROJECT_NAME}Tests" to your test's root source folder, if it's not the default name.
OUTPUT_FILE="${PROJECT_DIR}/${PROJECT_NAME}Tests/GeneratedMocks.swift"
echo "Generated Mocks File = ${OUTPUT_FILE}"

# Define input directory. Change "${PROJECT_DIR}/${PROJECT_NAME}" to your project's root source folder, if it's not the default name.
INPUT_DIR="${PROJECT_DIR}/${PROJECT_NAME}"
echo "Mocks Input Directory = ${INPUT_DIR}"

# Generate mock files, include as many input files as you'd like to create mocks for.
"${PODS_ROOT}/Cuckoo/run" generate --testable "${PROJECT_NAME}" \
--output "${OUTPUT_FILE}" \
"${INPUT_DIR}/FileName1.swift" \
"${INPUT_DIR}/FileName2.swift" \
"${INPUT_DIR}/FileName3.swift"
# ... and so forth, the last line should never end with a backslash

# After running once, locate `GeneratedMocks.swift` and drag it into your Xcode test target group.
```

**IMPORTANT**: To make your mocking journey easier, make absolutely sure that the run script is above the `Compile Sources` phase.

**NOTE**: To avoid race condition errors when Xcode parallelizes build phases, add the path of the `OUTPUT_FILE` into the "Output Files" section of the build phase. If you find that `OUTPUT_FILE` still doesn't regenerate with new changes, adding mocked files to the "Input Files" section of the build phase might help.

Input files can be also specified directly in `Run script` in `Input Files` form.

Note: All paths in the Run script must be absolute. Variable `PROJECT_DIR` automatically points to your project directory.
**Remember to include paths to inherited Classes and Protocols for mocking/stubbing parent and grandparents.**

#### Swift Package Manager

To use Cuckoo with Apple's Swift package manager, add the following as a dependency to your `Package.swift`:

```swift
.package(url: "https://github.com/Brightify/Cuckoo.git", .upToNextMajor(from: "1.5.0"))
```

after that add `"Cuckoo"` as a dependency of the test target.

If you're unsure, take a look at this example `PackageDescription`:

```swift
// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Friendlyst",
    products: [
        .library(
            name: "Friendlyst",
            targets: ["Friendlyst"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Brightify/Cuckoo.git", .upToNextMajor(from: "1.5.0"))
    ],
    targets: [
        .target(
            name: "Friendlyst",
            dependencies: [],
            path: "Source"),
        .testTarget(
            name: "FriendlystTests",
            dependencies: ["Cuckoo"],
            path: "Tests"),
    ]
)
```

Cuckoo relies on a script that is currently not downloadable using SwiftPM. However, for convenience, you can copy this line into the terminal to download the latest `run` script. Unfortunately if there are changes in the `run` script, you'll need to execute this line again.
```Bash
curl -Lo run https://raw.githubusercontent.com/Brightify/Cuckoo/master/run && chmod +x run
```

When you're all set, use the same `Run script` phase as above and replace
```Bash
"${PODS_ROOT}/Cuckoo/run"
```
with
```Bash
"${PROJECT_DIR}/run" --download
```

The `--download` option is necessary because the `Generator` sources are not cloned in your project (they're in DerivedData,  out of reach). You can add a version (e.g. `1.5.0`) after it to get a specific version of the `cuckoo_generator`. Use `--clean` as well to replace the current `cuckoo_generator` if you're changing versions.

#### Carthage
To use Cuckoo with [Carthage](https://github.com/Carthage/Carthage) add this line to your Cartfile:
```
github "Brightify/Cuckoo"
```

Then use the `Run script` from above and replace
```Bash
"${PODS_ROOT}/Cuckoo/run"
```
with
```Bash
"Carthage/Checkouts/Cuckoo/run"
```

Don't forget to add the Framework into your project.

### 2. Usage
Usage of Cuckoo is similar to [Mockito](http://mockito.org/) and [Hamcrest](http://hamcrest.org/). However, there are some differences and limitations caused by generating the mocks and Swift language itself. List of all the supported features can be found below. You can find complete examples in [tests](Tests).

#### Mock initialization
Mocks can be created with the same constructors as the mocked type. Name of mock class always corresponds to name of the mocked class/protocol with `Mock` prefix (e.g. mock of protocol `Greeter` is called `MockGreeter`).

```Swift
let mock = MockGreeter()
```

#### Spy
Spies are a special case of Mocks where each call is forwarded to the victim by default. Since Cuckoo version `0.11.0` we changed the way spies work. When you need a spy, give Cuckoo a class to mock instead of a protocol. You'll then be able to call `enableSuperclassSpy()` (or `withEnabledSuperclassSpy()`) on a mock instance and it will behave like a spy for the parent class.

```Swift
let spy = MockGreeter().withEnabledSuperclassSpy()
```

Note: The behavior was changed due to a limitation of Swift. Since we can't create a real proxy for the spy, calls inside the spy were not caught by the Mock and it was confusing. If you rely on the old behavior (i.e. you use spies with final classes), let us know on Slack or create an issue.

#### Stubbing
Stubbing can be done by calling methods as a parameter of the `when` function. The stub call must be done on special stubbing object. You can get a reference to it with the `stub` function. This function takes an instance of the mock that you want to stub and a closure in which you can do the stubbing. The parameter of this closure is the stubbing object.

Note: It is currently possible for the subbing object to escape from the closure. You can still use it to stub calls but it is not recommended in practice as the behavior of this may change in the future.

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

The available methods depend on the stubbed method characteristics. For example you cannot use the `thenThrow` method with a method that isn't throwing or rethrowing.

An example of stubbing a method looks like this:

```Swift
stub(mock) { stub in
  when(stub.greetWithMessage("Hello world")).then { message in
    print(message)
  }
}
```

As for a property:

```Swift
stub(mock) { stub in
  when(stub.readWriteProperty.get).thenReturn(10)
  when(stub.readWriteProperty.set(anyInt())).then {
    print($0)
  }
}
```

Notice the `get` and `set`, these will be used in verification later.

##### Enabling default implementation
In addition to stubbing, you can enable default implementation using an instance of the original class that's being mocked. Every method/property that is not stubbed will behave according to the original implementation.

Enabling the default implementation is achieved by simply calling the provided method:

```Swift
let original = OriginalClass<Int>(value: 12)
mock.enableDefaultImplementation(original)
```

For passing classes into the method, nothing changes whether you're mocking a class or a protocol. However, there is a difference if you're using a `struct` to conform to the original protocol we are mocking:

```Swift
let original = ConformingStruct<String>(value: "Hello, Cuckoo!")
mock.enableDefaultImplementation(original)
// or if you need to track changes:
mock.enableDefaultImplementation(mutating: &original)
```

Note that this only concerns `struct`s. `enableDefaultImplementation(_:)` and `enableDefaultImplementation(mutating:)` are different in state tracking.

The standard non-mutating method `enableDefaultImplementation(_:)` creates a copy of the `struct` for default implementation and works with that. However, the mutating method `enableDefaultImplementation(mutating:)` takes a reference to the struct and the changes of the `original` are reflected in the default implementation calls even after enabling default implementation.

We recommend using the non-mutating method for enabling default implementation unless you need to track the changes for consistency within your code.

##### Chain stubbing
It is possible to chain stubbing. This is useful for when you need to define different behavior for multiple calls in order. The last behavior will be used for all calls after that. The syntax goes like this:

```Swift
when(stub.readWriteProperty.get).thenReturn(10).thenReturn(20)
```

which is equivalent to:

```Swift
when(stub.readWriteProperty.get).thenReturn(10, 20)
```

The first call to `readWriteProperty` will return `10` and all calls after that will return `20`.

You can combine the stubbing methods as you like.

##### Overriding of stubbing
When looking for stub match Cuckoo gives the highest priority to the last call of `when`. This means that calling `when` multiple times with the same function and matchers effectively overrides the previous call. Also more general parameter matchers have to be used before specific ones.

```Swift
when(stub.countCharacters(anyString())).thenReturn(10)
when(stub.countCharacters("a")).thenReturn(1)
```

In this example calling `countCharacters` with `a` will return `1`. If you reversed the order of stubbing then the output would always be `10`.

#### Usage in real code
After previous steps the stubbed method can be called. It is up to you to inject this mock into your production code.

Note: Call on mock which wasn't stubbed will cause an error. In case of a spy, the real code will execute.

#### Verification
For verifying calls there is function `verify`. Its first parameter is the mocked object, optional second parameter is the call matcher. Then the call with its parameters follows.

```Swift
verify(mock).greetWithMessage("Hello world")
```

Verification of properties is similar to their stubbing.

You can check if there are no more interactions on mock with function `verifyNoMoreInteractions`.

With Swift's generic types, it is possible to use a generic parameter as the return type. To properly verify these methods, you need to be able to specify the return type.

```Swift
// Given:
func genericReturn<T: Codable>(for: String) -> T? { ... }

// Verify
verify(mock).genericReturn(for: any()).with(returnType: String?.self)
```

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

### 3. Matchers
Cuckoo makes use of *matchers* to connect your mocks to your code under test.

#### A) Automatic matchers for known types
You can mock any object that conforms to the `Matchable` protocol.
These basic values are extended to conform to `Matchable`:

- `Bool`
- `String`
- `Float`
- `Double`
- `Character`
- `Int`
- `Int8`
- `Int16`
- `Int32`
- `Int64`
- `UInt`
- `UInt8`
- `UInt16`
- `UInt32`
- `UInt64`

Matchers for `Array`, `Dictionary`, and `Set` are automatically synthesized as long as the type of the element conforms to `Matchable`.

#### B) Custom matchers
If Cuckoo doesn't know the type you are trying to compare, you have to write your own method `equal(to:)` using a `ParameterMatcher`. Add this method to your test file:

```swift
func equal(to value: YourCustomType) -> ParameterMatcher<YourCustomType> {
  return ParameterMatcher { tested in
    // Implementation of equality test for your custom type.
  }
}
```

⚠️ Trying to match an object with an unknown or non-`Matchable` type may lead to:

```
Command failed due to signal: Segmentation fault: 11
```

For details or an example (with Alamofire), see [this issue](https://github.com/Brightify/Cuckoo/issues/124).

#### Parameter matchers
`ParameterMatcher` itself also conforms to `Matchable`. You can create your own `ParameterMatcher` instances or if you want to directly use your custom types there is the `Matchable` protocol. Standard instances of `ParameterMatcher` can be obtained via these functions:

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

/// Returns a matcher matching any throwing closure.
anyThrowingClosure()

/// Returns a matcher matching any non nil value.
notNil()
```

Cuckoo also provides plenty of convenience matchers for sequences and dictionaries, allowing you to check if a sequence is a superset of a certain sequence, contains at least one of its elements, or is completely disjunct from it.

`Matchable` can be chained with methods `or` and `and` like so:

```Swift
verify(mock).greetWithMessage("Hello world".or("Hallo Welt"))
```

#### Call matchers
As a second parameter of the `verify` function you can use instances of `CallMatcher`. Its primary function is to assert how many times was the call made. But the `matches` function has a parameter of type `[StubCall]` which means you can use a custom `CallMatcher` to inspect the stub calls or for some side effect.

Note: Call matchers are applied after the parameter matchers. So you get only stub calls of the desired method with correct arguments.

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

As with `Matchable` you can chain `CallMatcher` with methods `or` and `and`. However, you can't mix `Matchable` and `CallMatcher` together.

#### Resetting mocks
Following functions are used to reset stubbing and/or invocations on mocks.

```Swift
/// Clears all invocations and stubs of given mocks.
reset<M: Mock>(_ mocks: M...)

/// Clears all stubs of given mocks.
clearStubs<M: Mock>(_ mocks: M...)

/// Clears all invocations of given mocks.
clearInvocations<M: Mock>(_ mocks: M...)
```

#### Stub objects
Stubs are used for suppressing real code. Stubs are different from Mocks in that they don't support stubbing nor verification. They can be created with the same constructors as the mocked type. Name of stub class always corresponds to name of the mocked class/protocol with `Stub` suffix (e.g. stub of protocol `Greeter` is called `GreeterStub`).

```Swift
let stub = GreeterStub()
```

When a method is called or a property accessed/set on a stub, nothing happens. If a value is to be returned from a method or a property, `DefaultValueRegistry` provides a default value. Stubs can be used to set implicit (no) behavior to mocks without the need to use `thenDoNothing()` like this: `MockGreeter().spy(on: GreeterStub())`.

##### DefaultValueRegistry
`DefaultValueRegistry` is used by Stubs to get default values for return types. It knows only default Swift types, sets, arrays, dictionaries, optionals, and tuples (up to 6 values). Tuples for more values can be added through extensions. Custom types must be registered before use with `DefaultValueRegistry.register<T>(value: T, forType: T.Type)`. Furthermore, default values set by Cuckoo can also be overridden by this method. Sets, arrays, etc. do not have to be registered if their generic type is already registered.

`DefaultValueRegistry.reset()` returns the registry to its clean slate before the `register` method made any changes.

##### Type inference
Cuckoo does a simple type inference on all variables which allows for much cleaner source code on your side. There are a total 3 ways the inference tries to extract the type name from a variable:

```Swift
// From the explicitly declared type:
let constant1: MyType

// From the initial value:
let constant2 = MyType(...)

// From the explicitly specified type `as MyType`:
let constant3 = anything as MyType
```

## Cuckoo generator
### Installation
For normal use you can skip this because the [run script](run) downloads or builds the correct version of the generator automatically.

#### Custom
So you have chosen a more complicated path. You can clone this repository and build it yourself. Take a look at the [run script](run) for more inspiration.

### Usage
Generator can be executed manually through the terminal. Each call consists of build options, a command, generator options, and arguments. Options and arguments depend on the command used. Options can have additional parameters. Names of all of them are case sensitive. The order goes like this:

```
cuckoo build_options command generator_options arguments
```

#### Build Options
These options are only used for downloading or building the generator and don't interfere with the result of the generated mocks.

When the [run script](run) is executed without any build options (they are only valid when specified **BEFORE** the `command`), it simply searches for the `cuckoo_generator` file and builds it from source code if it's missing.

To download the generator from GitHub instead of building it, use the `--download [version]` option as the first argument (i.e. `run --download generate ...` or `run --download 1.5.0 generate ...` to fetch a specific version). If you're having issues with rather long build time (especially in CI), this might be the way to fix it.

**NOTE**: If you encounter Github API rate limit using the `--download` option, the [run script](run) refers to the environment variable `GITHUB_ACCESS_TOKEN`.
Add this line (replacing the Xs with your [GitHub token](https://github.com/settings/tokens), no additional permissions are needed) to the script build phase above the `run` call:
```Bash
export GITHUB_ACCESS_TOKEN="XXXXXXX"
```

The build option `--clean` forces either build or download of the version specified even if the generator is present. At the moment the [run script](run) doesn't enforce the generator version to be the same as the Cuckoo version. We recommend using this option after updating Cuckoo as well as if you're having mysterious compile errors in the generated mocks. Please try to use this option first to verify that your generator isn't outdated before filing an issue about incorrectly generated mocks.

We recommend only using `--clean` when you're trying to fix a compile problem as it forces the build (or download) every time which makes the testing way longer than it needs to be.

#### Generator commands
##### `generate` command
Generates mock files.

This command accepts options that can be used to adjust the behavior of the generator, these are listed below.

After the options come arguments, in this case a list (separated by spaces) of files for which you want to generate mocks or that are required for correct inheritance mocking.

###### `--output` (string)
Absolute path to where the generated mocks will be stored.

If a path to a directory is supplied, each input file will be mapped to its own output file with mocks.

If a path to a file is supplied, all mocks will be generated into this single file.

The default value is `GeneratedMocks.swift`.

###### `--testable` (string)[,(string)...]
A comma separated list of frameworks that should be imported as @testable in the mock files.

###### `--exclude` (string)[,(string)...]
A comma separated list of classes and protocols that should be skipped during mock generation.

###### `--no-header`
Do not generate file headers.

###### `--no-timestamp`
Do not generate timestamp.

###### `--no-inheritance`
Do not mock/stub parents and grandparents.

###### `--file-prefix` (string)
Names of generated files in directory will start with this prefix. Only works when output path is directory.

###### `--no-class-mocking`
Do not generate mocks for classes.

###### `--regex` (string)
A regular expression pattern that is used to match Classes and Protocols. All that do not match are excluded. Can be used alongside `--exclude` in which case the `--exclude` has higher priority.

###### `-g` or `--glob`
Activate [glob](https://en.wikipedia.org/wiki/Glob_(programming)) parsing for specified input paths.

###### `-d` or `--debug`
Run generator in debug mode. There is more info output as well as included in the generated mocks (e.g. method parameter info).

#### `version` command
Prints the version of this generator.

#### `help` command
Display general or command-specific help.

After the `help` command you can specify the name of another command for displaying command-specific information.

## Objective-C Support
Cuckoo subspec `Cuckoo/OCMock` brings support for mocking Objective-C classes and protocols.

Example usage:
```Swift
let tableView = UITableView()
// stubbing the class is very similar to stubbing with Cuckoo
let mock = objcStub(for: UITableViewController.self) { stubber, mock in
  stubber.when(mock.numberOfSections(in: tableView)).thenReturn(1)
  stubber.when(mock.tableView(tableView, accessoryButtonTappedForRowWith: IndexPath(row: 14, section: 2))).then { args in
    // `args` is [Any] of the arguments passed and the closure needs to cast them manually
    let (tableView, indexPath) = (args[0] as! UITableView, args[1] as! IndexPath)
    print(tableView, indexPath)
  }
}

// calling stays the same
XCTAssertEqual(mock.numberOfSections(in: tableView), 1)
mock.tableView(tableView, accessoryButtonTappedForRowWith: IndexPath(row: 14, section: 2))

// `objcVerify` is used to verify the interaction with the methods/variables
objcVerify(mock.numberOfSections(in: tableView))
objcVerify(mock.tableView(tableView, accessoryButtonTappedForRowWith: IndexPath(row: 14, section: 2)))
```

Detailed usage is available in Cuckoo tests along with DOs and DON'Ts of this Swift-ObjC bridge.

So far, only CocoaPods is supported. To install, simply add this line to your `Podfile`:
```Ruby
pod 'Cuckoo/OCMock'
```

## Contribute
Cuckoo is open for everyone and we'd like you to help us make the best Swift mocking library. For Cuckoo development, follow these steps:
1. Make sure you have latest stable version of Xcode installed
2. Clone the **Cuckoo** repository
3. In Terminal, run: `make dev` from inside the **Cuckoo** directory
4. Open `Cuckoo.xcodeproj`
5. Select either `Cuckoo-iOS` or `Cuckoo-macOS` scheme and verify by running the tests (⌘+U)
6. Peek around or file a pull request with your changes

The project consists of two parts - runtime and code generator. When you open the `Cuckoo.xcodeproj` in Xcode, you'll see these directories:
    - `Source` - runtime sources
    - `Tests` - tests for the runtime part
    - `CuckoGenerator.xcodeproj` - project generated by `make dev` containing Generator source code

Thank you for your help!

## Inspiration
- [Mockito](http://mockito.org/) - Mocking DSL
- [Hamcrest](http://hamcrest.org/) - Matcher API

## Used libraries
- [Commandant](https://github.com/Carthage/Commandant)
- [FileKit](https://github.com/nvzqz/FileKit)
- [SourceKitten](https://github.com/jpsim/SourceKitten)

## License
Cuckoo is available under the [MIT License](LICENSE).
