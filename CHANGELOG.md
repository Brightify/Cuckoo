# Changelog

##

* Added --no-class-mocking parameter to generator

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
