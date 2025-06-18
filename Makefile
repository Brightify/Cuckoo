.PHONY: dev

dev:
	(killall Xcode || true)

	# Create generated mocks file which will be populated later.
	touch "Tests/Swift/Generated/GeneratedMocks.swift"

	mise install

	# Generate Xcode structure.
	TUIST_PROJECT_DIR=$(PWD) tuist generate --no-open

	xed Cuckoo.xcworkspace
