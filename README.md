# Cuckoo
## Mock your Swift objects!

[![Platform](https://img.shields.io/cocoapods/p/Cuckoo.svg?style=flat)](http://cocoapods.org/pods/Cuckoo)
[![CocoaPods ready](https://img.shields.io/badge/CocoaPods-ready-brightgreen?style=flat)](http://cocoapods.org/pods/Cuckoo)
[![SPM ready](https://img.shields.io/badge/SwiftPM-ready-brightgreen?style=flat)](https://swift.org/package-manager)
[![License](https://img.shields.io/cocoapods/l/Cuckoo.svg?style=flat)](http://cocoapods.org/pods/Cuckoo)

## Introduction
Cuckoo was created due to lack of a proper Swift mocking framework. We built the DSL to be very similar to [Mockito](http://mockito.org/), so anyone coming from Java/Android can immediately pick it up and use it.

## How does it work
Cuckoo has two parts. One is the **runtime** and the other one is an OS X command-line tool simply called **Cuckoonator**.

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

- **iOS 13+**
- **macOS 10.15+**
- **tvOS 13+**
- **watchOS 8+**

## Cuckoo
### 1. Installation
#### Swift Package Manager

URL: `https://github.com/Brightify/Cuckoo.git`

**WARNING**: Make sure to add Cuckoo to test targets only.

When you're all set, go to your test target's Build Phases and add plug-in `CuckooPluginSingleFile` to the **Run Build Tool Plug-ins**.

#### CocoaPods
Cuckoo runtime is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your **test target** in your Podfile:

```ruby
pod 'Cuckoo', '~> 2.0'
```

And add the following `Run script` build phase to your test target's `Build Phases` above the `Compile Sources` phase:

```bash
# Skip for indexing
if [ $ACTION == "indexbuild" ]; then
  exit 0
fi

# Skip for preview builds
if [ "${ENABLE_PREVIEWS}" = "YES" ]; then
  exit 0
fi

"${PODS_ROOT}/Cuckoo/run"
```

After running once, locate `GeneratedMocks.swift` and drag it into your Xcode test target group.

**IMPORTANT**: To make your mocking journey easier, make absolutely sure that the run script is above the `Compile Sources` phase.

**NOTE**: From Xcode 15 the flag `ENABLE_USER_SCRIPT_SANDBOXING` in Build Settings is `Yes` by default. That means Xcode will sandbox the script so reading input files and writing output file will be forbidden. As a result running above script may fail to access the files. To prevent Xcode from sandboxing the script, change this option to `No`.

Input files can be also specified directly in `Run script` in `Input Files` form.

Note: All paths in the Run script must be absolute. Variable `PROJECT_DIR` automatically points to your project directory.
**Remember to include paths to inherited Classes and Protocols for mocking/stubbing parent and grandparents.**

### 2. Cuckoofile customization
At the root of your project, create `Cuckoofile.toml` configuration file:

```toml
# You can define a fallback output for all modules that don't define their own.
output = "Tests/Swift/Generated/GeneratedMocks.swift"

[modules.MyProject]
output = "Tests/Swift/Generated/GeneratedMocks+MyProject.swift"
# Standard imports added to the generated file(s).
imports = ["Foundation"]
# Public imports if needed due to imports being internal by default from Swift 6.
publicImports = ["ExampleModule"]
# @testable imports if needed.
testableImports = ["RxSwift"]
sources = [
    "Tests/Swift/Source/*.swift",
]
exclude = ["ExcludedTestClass"]
# Optionally you can use a regular expression to filter only specific classes/protocols.
# regex = ""

[modules.MyProject.options]
# glob = false
# Docstrings are preserved by default, comments are omitted.
keepDocumentation = false
# enableInheritance = false
# protocolsOnly = true
# omitHeaders = true

# If specified, Cuckoo can also get sources for the module from an Xcode target.
[modules.MyProject.xcodeproj]
# Path to folder with .xcodeproj, omit this if it's at the same level as Cuckoofile.
path = "Generator"
target = "Cuckoonator"

# You can define as many modules as you need, each with different sources/options/output.
[modules.AnotherProject]
# ...
```

### 3. Usage
Usage of Cuckoo is similar to [Mockito](http://mockito.org/) and [Hamcrest](http://hamcrest.org/). However, there are some differences and limitations caused by generating the mocks and Swift language itself. List of all the supported features can be found below. You can find complete examples in [tests](Tests).

#### Mock initialization
Mocks can be created with the same constructors as the mocked type. Name of mock class always corresponds to the name of the mocked class/protocol with `Mock` prefix (e.g. mock of protocol `Greeter` is called `MockGreeter`).

```swift
let mock = MockGreeter()
```

#### Spy
Spies are a special type of Mocks where each call is forwarded to the victim by default. When you need a spy, give Cuckoo a class, then you'll then be able to call `enableSuperclassSpy()` (or `withEnabledSuperclassSpy()`) on a mock instance and it will behave like a spy for the parent class.

```swift
let spy = MockGreeter().withEnabledSuperclassSpy()
```

#### Stubbing
Stubbing can be done by calling methods as a parameter of the `when` function. The stub call must be done on special stubbing object. You can get a reference to it with the `stub` function. This function takes an instance of the mock that you want to stub and a closure in which you can do the stubbing. The parameter of this closure is the stubbing object.

Note: It is currently possible for the subbing object to escape from the closure. You can still use it to stub calls but it is not recommended in practice as the behavior of this may change in the future.

After calling the `when` function you can specify what to do next with following methods:

```swift
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

The available methods depend on the stubbed method characteristics. For example, the `thenThrow` method isn't available for a method that isn't throwing or rethrowing.

An example of stubbing a method looks like this:

```swift
stub(mock) { stub in
  when(stub.greetWithMessage("Hello world")).then { message in
    print(message)
  }
}
```

As for a property:

```swift
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

```swift
let original = OriginalClass<Int>(value: 12)
mock.enableDefaultImplementation(original)
```

For passing classes into the method, nothing changes whether you're mocking a class or a protocol. However, there is a difference if you're using a `struct` to conform to the original protocol we are mocking:

```swift
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

```swift
when(stub.readWriteProperty.get).thenReturn(10).thenReturn(20)
```

which is equivalent to:

```swift
when(stub.readWriteProperty.get).thenReturn(10, 20)
```

The first call to `readWriteProperty` will return `10` and all calls after that will return `20`.

You can combine the stubbing methods as you like.

##### Overriding of stubbing
When looking for stub match Cuckoo gives the highest priority to the last call of `when`. This means that calling `when` multiple times with the same function and matchers effectively overrides the previous call. Also more general parameter matchers have to be used before specific ones.

```swift
when(stub.countCharacters(anyString())).thenReturn(10)
when(stub.countCharacters("a")).thenReturn(1)
```

In this example calling `countCharacters` with `a` will return `1`. If you reversed the order of stubbing then the output would always be `10`.

#### Usage in real code
After previous steps the stubbed method can be called. It is up to you to inject this mock into your production code.

Note: Call on mock which wasn't stubbed will cause an error. In case of a spy, the real code will execute.

#### Verification
For verifying calls there is function `verify`. Its first parameter is the mocked object, optional second parameter is the call matcher. Then the call with its parameters follows.

```swift
verify(mock).greetWithMessage("Hello world")
```

Verification of properties is similar to their stubbing.

You can check if there are no more interactions on mock with function `verifyNoMoreInteractions`.

With Swift's generic types, it is possible to use a generic parameter as the return type. To properly verify these methods, you need to be able to specify the return type.

```swift
// Given:
func genericReturn<T: Codable>(for: String) -> T? { ... }

// Verify
verify(mock).genericReturn(for: any()).with(returnType: String?.self)
```

##### Argument capture
You can use `ArgumentCaptor` to capture arguments in verification of calls (doing that in stubbing is not recommended). Here is an example code:

```swift
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
You can mock any object that conforms to the `Matchable` protocol. Standard built-in types like `Int`, `String`, already conform thanks to Cuckoo. Automatic conformance synthesis applies for `Array` and the like.

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

```swift
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

```swift
verify(mock).greetWithMessage("Hello world".or("Hallo Welt"))
```

#### Call matchers
As a second parameter of the `verify` function you can use instances of `CallMatcher`. Its primary function is to assert how many times was the call made. But the `matches` function has a parameter of type `[StubCall]` which means you can use a custom `CallMatcher` to inspect the stub calls or for some side effect.

Note: Call matchers are applied after the parameter matchers. So you get only stub calls of the desired method with correct arguments.

Standard call matchers are:

```swift
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

```swift
/// Clears all invocations and stubs of given mocks.
reset<M: Mock>(_ mocks: M...)

/// Clears all stubs of given mocks.
clearStubs<M: Mock>(_ mocks: M...)

/// Clears all invocations of given mocks.
clearInvocations<M: Mock>(_ mocks: M...)
```

#### Stub objects
Stubs are used for suppressing real code. Stubs are different from Mocks in that they don't support stubbing nor verification. They can be created with the same constructors as the mocked type. Name of stub class always corresponds to name of the mocked class/protocol with `Stub` suffix (e.g. stub of protocol `Greeter` is called `GreeterStub`).

```swift
let stub = GreeterStub()
```

When a method is called or a property accessed/set on a stub, nothing happens. If a value is to be returned from a method or a property, `DefaultValueRegistry` provides a default value. Stubs can be used to set implicit (no) behavior to mocks without the need to use `thenDoNothing()` like this: `MockGreeter().spy(on: GreeterStub())`.

##### DefaultValueRegistry
`DefaultValueRegistry` is used by Stubs to get default values for return types. It knows only default Swift types, sets, arrays, dictionaries, optionals, and tuples (up to 6 values). Tuples for more values can be added through extensions. Custom types must be registered before use with `DefaultValueRegistry.register<T>(value: T, forType: T.Type)`. Furthermore, default values set by Cuckoo can also be overridden by this method. Sets, arrays, etc. do not have to be registered if their generic type is already registered.

`DefaultValueRegistry.reset()` returns the registry to its clean slate before the `register` method made any changes.

##### Type inference
Cuckoo does a simple type inference on all variables which allows for much cleaner source code on your side. There are a total 3 ways the inference tries to extract the type name from a variable:

```swift
// From the explicitly declared type:
let constant1: MyType

// From the initial value:
let constant2 = MyType(...)

// From the explicitly specified type `as MyType`:
let constant3 = anything as MyType
```

## Cuckoo run script
#### Build Options
These options are only used for downloading or building the generator and don't interfere with the result of the generated mocks.

When the [run script](run) is executed without any parameters, it simply searches for the `cuckoonator` file and builds it from source code if it's missing, running the generator afterwards.

To download the generator from GitHub instead of building it, use the `--download` option as the first argument (i.e. `run --download`). If you're having issues with rather long build time (especially in CI), this might be the way to fix it.

**NOTE**: If you encounter Github API rate limit using the `--download` option, the [run script](run) refers to the environment variable `GITHUB_ACCESS_TOKEN`.
Add this line (replacing the Xs with your [GitHub token](https://github.com/settings/tokens), no additional permissions are needed) to the script build phase above the `run` call:
```bash
export GITHUB_ACCESS_TOKEN="XXXXXXX"
```

The build option `--clean` forces either build or download of the version specified even if the generator is present.
The run script also syncs the generator to the correct version (either by building from source or downloading with `--download`) if needed.

We recommend only using `--clean` when you're trying to fix a compile problem as it forces the build (or download) every time which makes the testing way longer than it needs to be.

## Objective-C Support
For Objective-C support, Cuckoo wraps `OCMock` and uses its battle-tested functionality to bring support for mocking various Objective-C classes and protocols to Swift.

For example:
```swift
let tableView = UITableView()
// stubbing the class is very similar to stubbing with Cuckoo, note the `objcStub` method.
let mock = objcStub(for: UITableViewController.self) { stubber, mock in
  stubber.when(mock.numberOfSections(in: tableView)).thenReturn(1)
  stubber.when(mock.tableView(tableView, accessoryButtonTappedForRowWith: IndexPath(row: 14, section: 2))).then { args in
    // An unfortunate drawback is that arguments will miss type information, so the closure needs to cast them manually.
    let (tableView, indexPath) = (args[0] as! UITableView, args[1] as! IndexPath)
    print(tableView, indexPath)
  }
}

// Invoking is exactly the same as you'd expect.
XCTAssertEqual(mock.numberOfSections(in: tableView), 1)
mock.tableView(tableView, accessoryButtonTappedForRowWith: IndexPath(row: 14, section: 2))

// `objcVerify` replaces `verify` to test the interaction with methods/variables.
objcVerify(mock.numberOfSections(in: tableView))
objcVerify(mock.tableView(tableView, accessoryButtonTappedForRowWith: IndexPath(row: 14, section: 2)))
```

Detailed usage is available in Cuckoo tests along with DOs and DON'Ts of this Swift-ObjC bridge.

## Contribute
Cuckoo is open for everyone and we'd like you to help us make the best Swift mocking library. For Cuckoo development, follow these steps:
1. Make sure you have the latest stable version of Xcode installed.
2. Clone the **Cuckoo** repository.
3. **For the initial setup**, open a terminal and run `make init` at the root of the cloned **Cuckoo** repository. This will install necessary tools (including Tuist if not already installed), generate the project, install dependencies, and open it in Xcode.
4. **For subsequent usage or when switching branches**, run `make` at the root of the cloned **Cuckoo** repository. This will generate the project, install dependencies, and open it in Xcode.
5. Select any scheme of `Cuckoo-iOS`, `Cuckoo-tvOS`, or `Cuckoo-macOS` and verify by running the tests (⌘+U).
6. Peek around or file a pull request with your changes.

**NOTE**: Make sure to run `make` again whenever you checkout another branch, the project utilizes [Tuist](https://github.com/tuist/tuist) for project generation.

The project consists of two parts - runtime and code generator. When you open the `Cuckoo.xcworkspace` in Xcode, you'll see these directories:
    - `Source` - runtime sources
    - `Tests` - tests for the runtime part
    - `Generator.xcodeproj` - project containing generator source code (use the `Generator` scheme to run it)

Thank you for your help!

## Inspiration
- [Mockito](http://mockito.org/) - Mocking DSL
- [Hamcrest](http://hamcrest.org/) - Matcher API

## Used libraries
- [ArgumentParser](https://github.com/apple/swift-argument-parser)
- [FileKit](https://github.com/nvzqz/FileKit)
- [SwiftSyntax](https://github.com/apple/swift-syntax)

## License
Cuckoo is available under the [MIT License](LICENSE).
