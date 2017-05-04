# Changelog

## 0.9.2

* Fixed crash when source files were using non-ASCII characters - [bug #126](https://github.com/Brightify/Cuckoo/issues/126)
* Added `--exclude` parameter to explicitly exclude some types from mocking - [PR #112](https://github.com/Brightify/Cuckoo/pull/112) - (thanks to nxtstep for the feature)
* Fixed compile errors when generating stubs where inner types were returned - [bug #118](https://github.com/Brightify/Cuckoo/issues/118)

## 0.9.1

* Fixed "too complex to resolve in reasonable time" error in generator
* Fixed directory names for case sensitive file systems - [PR #114](https://github.com/Brightify/Cuckoo/pull/115) - (thanks to sundance2000 for the fix)
* Moved repository from `SwiftKit` to `Brightify` organization on GitHub.

## 0.9.0

* Rewritten Generator to use Stencil
* Use Swift PM for generator binary (results in faster builds)
* This release works with Swift 3.1

## 0.8.4

* Added support for inheritance mocking.  

## 0.8.3

* Added support for `fileprivate` (thanks to lvdstam for implementation).
* Added support for default values (thanks to lvdstam for implementation).
* Fixed wrongly generated code where public class had internal members.

## 0.8.2

* Show error in generator in build log.
* Fixed crash of generator when instance variable type is not explicitly set.
* Fixed support of closures and unwrapped optionals.

## 0.8.1

* Set "Reflection Metadata" to "None" to fix #72

## 0.8.0

* Support for Swift 3
* Added --no-class-mocking parameter to generator
* Added Stub objects

## 0.7.0

* Updated documentation
* Added more automated tests
* Added --file-prefix parameter to generator
* `and` and `or` methods can now be used with `Matchable` (literals)
* Using of custom `Matchable`, `ParameterMatcher` and `CallMatcher` is now easier
* Improved fail messages
* Merged generator and runtime repositories, making updating easier.
* Added support for named arguments in methods.
* Added support for classes with custom initializers.
* Changed usage of spies. Instead of `init(spyOn:)` use `init().spy(on:)`.

## 0.6.0

* Added release notes
* Added stub resetting
* Added `thenCallRealImplementation`
* Added argument capturing
* Added `verifyNoMoreInteractions`
* Added on going stubbing
* Added `thenDoNothing`
