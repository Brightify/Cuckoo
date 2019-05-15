# Changelog

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
