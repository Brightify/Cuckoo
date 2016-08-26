Feature: Generate command
	Scenario: in file
		When I run `runcuckoo generate --no-timestamp --output Actual.swift SourceFiles/TestedClass.swift SourceFiles/TestedProtocol.swift`
		Then the file "SourceFiles/Expected/GeneratedMocks.swift" should be equal to file "Actual.swift"
	Scenario: in directory
		When I run `runcuckoo generate --no-timestamp --output . SourceFiles/ClassWithAttributes.swift SourceFiles/Imports.swift`
		Then the file "SourceFiles/Expected/ClassWithAttributes.swift" should be equal to file "ClassWithAttributes.swift"
		And the file "SourceFiles/Expected/Imports.swift" should be equal to file "Imports.swift"
	Scenario: output not specified
		When I run `runcuckoo generate --no-timestamp SourceFiles/TestedClass.swift SourceFiles/TestedProtocol.swift`
		Then the file "SourceFiles/Expected/GeneratedMocks.swift" should be equal to file "GeneratedMocks.swift"
	Scenario: testableFrameworks
		When I run `runcuckoo generate --no-timestamp --testable "Cuckoo,A b,A-c,A.d" --output Actual.swift SourceFiles/EmptyClass.swift`
		Then the file "SourceFiles/Expected/TestableFrameworks.swift" should be equal to file "Actual.swift"
	Scenario: non existing input file
		When I run `runcuckoo generate non_existing_file.swift`
		Then the output should contain:
		"""
		Could not read contents of `non_existing_file.swift`
		"""
	Scenario: no header
		When I run `runcuckoo generate --no-header --output Actual.swift SourceFiles/EmptyClass.swift`
		Then the file "SourceFiles/Expected/NoHeader.swift" should be equal to file "Actual.swift"
	Scenario: multiple classes in one file
		When I run `runcuckoo generate  --no-timestamp --output Actual.swift SourceFiles/MultipleClasses.swift`
		Then the file "SourceFiles/Expected/MultipleClasses.swift" should be equal to file "Actual.swift"
	Scenario: class with attributes
		When I run `runcuckoo generate --no-timestamp --output Actual.swift SourceFiles/ClassWithAttributes.swift`
		Then the file "SourceFiles/Expected/ClassWithAttributes.swift" should be equal to file "Actual.swift"
	Scenario: imports
		When I run `runcuckoo generate --no-timestamp --output Actual.swift SourceFiles/Imports.swift`
		Then the file "SourceFiles/Expected/Imports.swift" should be equal to file "Actual.swift"
	Scenario: struct
		When I run `runcuckoo generate --no-timestamp --output Actual.swift SourceFiles/Struct.swift`
		Then the file "SourceFiles/Expected/Struct.swift" should be equal to file "Actual.swift"
	Scenario: in file with file-prefix
		When I run `runcuckoo generate --no-timestamp --file-prefix Mock --output Actual.swift SourceFiles/TestedClass.swift SourceFiles/TestedProtocol.swift`
		Then the file "SourceFiles/Expected/GeneratedMocks.swift" should be equal to file "Actual.swift"
	Scenario: in directory with file-prefix
		When I run `runcuckoo generate --no-timestamp --file-prefix Mock --output . SourceFiles/ClassWithAttributes.swift SourceFiles/Imports.swift`
		Then the file "SourceFiles/Expected/ClassWithAttributes.swift" should be equal to file "MockClassWithAttributes.swift"
		And the file "SourceFiles/Expected/Imports.swift" should be equal to file "MockImports.swift"