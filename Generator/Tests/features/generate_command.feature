Feature: Generate command
	Scenario: in file
		When I run `runcuckoo generate --no-timestamp --output Actual.swift SourceFiles/TestedClass.swift SourceFiles/TestedProtocol.swift`
		Then the file "SourceFiles/Expected/GeneratedMocks.swift" should be equal to file "Actual.swift"