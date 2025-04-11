- Loosen dependency requirements to make updating cuckoo versions easier

- Fix Path-related warnings from CuckooPluginFile
- Run GHA for pull requests.
- Fix swiftlang dependencies

- Fix crash when stubbing function that takes Sendable closure
- Make `make` more reliable.
- Fix errors when using Swift 6 strict concurrency checking

- Add back Generator.xcodeproj for local building.

- Downgrade SwiftPM version.

- Temporarily omit OCMock from SPM.

- Fix podspec.
- Improve code readability.
- Add GitHub test action.
- docs: update README.md for contribute section
- Add public imports to configuration
- Update Tuist.
- Automatically prepend changelog.
- Remove Carthage support.
- Simplify project and add watchOS support.
- Fixed typeErasure template when method.isThrowing
- Fix automatic version file generation during release.
- Update Version.swift
- Fix OCMock integration not working properly.

## 1.4.1
- Sidestep `SourceKit`'s off-by-one bug when parsing generic parameter inheritance.
- Fix incorrect `where` clause parsing.

## 1.4.0
- Add tvOS targets and schemes.
- Integrate `tuist`, fixing Carthage issues.
- Fix type equality check to rule out whitespace inconsistencies.

## 1.3.2
- Fix `image not found` error for iOS 13 and beyond.

## 1.3.1
- **Swift Package Manager support**
- Added tvOS target (thanks @rodrigoff).
- Fixed accessibility to match enclosing container.
- Restructured README.

## 1.3.0
- Fix closure generation where explicit return type is required in `withoutActuallyEscaping` since swift 5.1 (XCode 11)
- Switch swift_version to 5.0 for Cocoapods

## 1.2.0
#### Features
- Objective-C mocking! Mock system classes/protocols as well as dynamic Swift classes. This is an optional subspec `Cuckoo/OCMock`.
- Convenience matchers for sequences and dictionaries. No need to use `equal(to:)` anymore, passing the `Array`/`Set`/`Dictionary` itself is enough from now on!

## 1.1.1
- Fix property, initializer, and function accessibility in public protocols.

## 1.1.0
#### Features:
- Add a simple type guesser based on assigned value.

#### Fixes:
- Fix accessibility problems.

## 1.0.6
- Fix a bug where adding a private name to a function made it generate twice and fail the compilation.

## 1.0.5
- Fix generic protocol generation and type erasure with multiple methods of same name.
- Fix a bug concerning empty public name methods with no private ones.
- Exit `run` script with error if it fails to get generator download URL.

## 1.0.4
- The `run` script doesn't use `realpath` command anymore because it's not available by default on Mac OS.
- Remove redundant stubbing of optional classes.

## 1.0.3
- Add support for optional read-only properties.

## 1.0.2
- Fix `where` clause that doesn't work in Swift 4.
- Fix some `run` script bugs.

## 1.0.1
- Fix `any()` not working anymore by itself with optional parameters in functions.

## 1.0.0
#### Features:
- **Generics** is now fully supported! This includes generic classes, protocols and methods.
- `Dictionary` matching out of the box.
- Better closure matching. Now allowing up to 7 parameter closures.
- `rethrows` functions now work properly.
- Allow non-optional values to be passed as matchers for `Optional`s just like in normal Swift code.
- Add support for inout method parameters.

#### Fixes:
- Update the `build_generator` script to work with Swift 5.
- Fix not being able to put `Optional` into functions accepting `Optional`s.
- Accessibility of variables and functions in `public` classes are now `public` as well.

## 0.13.0
- Updated for **Xcode 10.2** and **Swift 5**.

## 0.12.1
- Add class accessibility support.
- Add support for attributes (e.g. `@available`).
- Add support for subimport (e.g. `import struct UICat.Food`).
- Add `--clean` option to the run script to always build or download the generator (promptly forget to add its documentation to `README.md`).
- Ignore `final` classes (because we mock by inheritance).
- Smaller fixes and improvements in the whole project.

## 0.12.0
- Add first draft of a new Mock initialization DSL.
- Add `enableDefaultImplementation` to protocol `Mock`.
- Reintroduce support for pre-0.11.0 Cuckoo spies.
- Add **regular expression** `class` and `protocol` matching.
- Add **glob** switch that parses input paths as globs enabling for easier project scaling.
- Build generator by default. Download using `--download [VERSION]` option.
- Modify the `run` bash script to allow the user to build rather than download the `cuckoo_generator`.
- Add a debug flag that generates general info above methods when used.
- Fix escaping closure (crashing in Xcode 10).

## 0.11.0
- Added contribution guide.
- **BREAKING CHANGE**: Spies were reworked. They now use superclasses as their victims if enabled. Please see the Readme for more information.
- **BREAKING CHANGE**: Verification of properties' `get` is now a method you have to call, instead of a property. This change was made to remove the "unused result" warning.  [bug #141](https://github.com/Brightify/Cuckoo/issues/141)

## 0.10.2
- Double the maximum parameters in `call` and `callThrows` methods. [bug #145](https://github.com/Brightify/Cuckoo/issues/145)
- Make the generator deterministic by sorting input files.
    - [bug #157](https://github.com/Brightify/Cuckoo/issues/157)
    - [PR #158 - kudos to IanKeen](https://github.com/Brightify/Cuckoo/pull/158)
- Add `equalTo` for `Array` and `Set` where `Element` is `Equatable`.

## 0.10.1
- Fixed some errors with getters [bug #151](https://github.com/Brightify/Cuckoo/issues/151)

## 0.10.0
- Updated for **Swift 4** (Xcode 9 GM)

## 0.9.2
- Fixed crash when source files were using non-ASCII characters - [bug #126](https://github.com/Brightify/Cuckoo/issues/126)
- Added `--exclude` parameter to explicitly exclude some types from mocking - [PR #112](https://github.com/Brightify/Cuckoo/pull/112) - (thanks to nxtstep for the feature)
- Fixed compile errors when generating stubs where inner types were returned - [bug #118](https://github.com/Brightify/Cuckoo/issues/118)
- Added possibility to reset multiple mocks with different types at once - [but #103](https://github.com/Brightify/Cuckoo/issues/103)

## 0.9.1
- Fixed "too complex to resolve in reasonable time" error in generator
- Fixed directory names for case sensitive file systems - [PR #114](https://github.com/Brightify/Cuckoo/pull/115) - (thanks to sundance2000 for the fix)
- Moved repository from `SwiftKit` to `Brightify` organization on GitHub.

## 0.9.0
- Rewritten Generator to use Stencil
- Use Swift PM for generator binary (results in faster builds)
- This release works with Swift 3.1

## 0.8.4
- Added support for inheritance mocking.

## 0.8.3
- Added support for `fileprivate` (thanks to lvdstam for implementation).
- Added support for default values (thanks to lvdstam for implementation).
- Fixed wrongly generated code where public class had internal members.

## 0.8.2
- Show error in generator in build log.
- Fixed crash of generator when instance variable type is not explicitly set.
- Fixed support of closures and unwrapped optionals.

## 0.8.1
- Set "Reflection Metadata" to "None" to fix #72

## 0.8.0
- Support for **Swift 3**
- Added --no-class-mocking parameter to generator
- Added Stub objects

## 0.7.0
- Updated documentation
- Added more automated tests
- Added --file-prefix parameter to generator
- `and` and `or` methods can now be used with `Matchable` (literals)
- Using of custom `Matchable`, `ParameterMatcher` and `CallMatcher` is now easier
- Improved fail messages
- Merged generator and runtime repositories, making updating easier.
- Added support for named arguments in methods.
- Added support for classes with custom initializers.
- Changed usage of spies. Instead of `init(spyOn:)` use `init().spy(on:)`.

## 0.6.0
- Added release notes
- Added stub resetting
- Added `thenCallRealImplementation`
- Added argument capturing
- Added `verifyNoMoreInteractions`
- Added on going stubbing
- Added `thenDoNothing`
