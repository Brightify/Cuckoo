Feature: Generate command

	# Recorded tests

	Scenario: class with attributes
		When I run `runcuckoo generate --no-timestamp --output ClassWithAttributes.swift SourceFiles/ClassWithAttributes.swift`
		Then the file "Expected/ClassWithAttributes.swift" should be equal to file "ClassWithAttributes.swift"

	Scenario: class with init
		When I run `runcuckoo generate --no-timestamp --output ClassWithInit.swift SourceFiles/ClassWithInit.swift`
		Then the file "Expected/ClassWithInit.swift" should be equal to file "ClassWithInit.swift"

	Scenario: class with optionals
		When I run `runcuckoo generate --no-timestamp --output ClassWithOptionals.swift SourceFiles/ClassWithOptionals.swift`
		Then the file "Expected/ClassWithOptionals.swift" should be equal to file "ClassWithOptionals.swift"

	Scenario: output not specified
		When I run `runcuckoo generate --no-timestamp SourceFiles/TestedClass.swift SourceFiles/TestedProtocol.swift`
		Then the file "Expected/GeneratedMocks.swift" should be equal to file "GeneratedMocks.swift"

	Scenario: imports
		When I run `runcuckoo generate --no-timestamp --output Imports.swift SourceFiles/Imports.swift`
		Then the file "Expected/Imports.swift" should be equal to file "Imports.swift"

	Scenario: multiple classes
		When I run `runcuckoo generate  --no-timestamp --output MultipleClasses.swift SourceFiles/MultipleClasses.swift`
		Then the file "Expected/MultipleClasses.swift" should be equal to file "MultipleClasses.swift"

	Scenario: no header
		When I run `runcuckoo generate --no-header --output NoHeader.swift SourceFiles/EmptyClass.swift`
		Then the file "Expected/NoHeader.swift" should be equal to file "NoHeader.swift"

	Scenario: struct
		When I run `runcuckoo generate --no-timestamp --output Struct.swift SourceFiles/Struct.swift`
		Then the file "Expected/Struct.swift" should be equal to file "Struct.swift"

	Scenario: testableFrameworks
		When I run `runcuckoo generate --no-timestamp --testable "Cuckoo,A b,A-c,A.d" --output TestableFrameworks.swift SourceFiles/EmptyClass.swift`
		Then the file "Expected/TestableFrameworks.swift" should be equal to file "TestableFrameworks.swift"

	Scenario: --no-class-mocking
		When I run `runcuckoo generate --no-timestamp --no-class-mocking --output TestedProtocol.swift SourceFiles/TestedClass.swift SourceFiles/TestedProtocol.swift`
		Then the file "Expected/TestedProtocol.swift" should be equal to file "TestedProtocol.swift"

	# Not recorded tests

	Scenario: success
		When I run `runcuckoo generate --output Actual.swift SourceFiles/EmptyClass.swift`
		Then the exit status should be 0

	Scenario: non existing input file
		When I run `runcuckoo generate --output Actual.swift non_existing_file.swift`
		Then the output should contain:
		"""
		Could not read contents of `non_existing_file.swift`
		"""
		And the exit status should be 1

	Scenario: implicit instance variable type
		When I run `runcuckoo generate --output Actual.swift SourceFiles/ImplicitInstanceVariableType.swift`
		Then the output should contain:
		"""
		Type of instance variable variable could not be inferred. Please specify it explicitly.
		"""
		And the exit status should be 1

	# Tests reusing code from recoreded tests (if they fail these will fail because of it.)

	Scenario: in file
		When I run `runcuckoo generate --no-timestamp --output Actual.swift SourceFiles/TestedClass.swift SourceFiles/TestedProtocol.swift`
		Then the file "Expected/GeneratedMocks.swift" should be equal to file "Actual.swift"

	Scenario: in directory
		When I run `runcuckoo generate --no-timestamp --output . SourceFiles/ClassWithAttributes.swift SourceFiles/Imports.swift`
		Then the file "Expected/ClassWithAttributes.swift" should be equal to file "ClassWithAttributes.swift"
		And the file "Expected/Imports.swift" should be equal to file "Imports.swift"

	Scenario: in file with file-prefix
		When I run `runcuckoo generate --no-timestamp --file-prefix Mock --output Actual.swift SourceFiles/TestedClass.swift SourceFiles/TestedProtocol.swift`
		Then the file "Expected/GeneratedMocks.swift" should be equal to file "Actual.swift"
		
	Scenario: in directory with file-prefix
		When I run `runcuckoo generate --no-timestamp --file-prefix Mock --output . SourceFiles/ClassWithAttributes.swift SourceFiles/Imports.swift`
		Then the file "Expected/ClassWithAttributes.swift" should be equal to file "MockClassWithAttributes.swift"
		And the file "Expected/Imports.swift" should be equal to file "MockImports.swift"