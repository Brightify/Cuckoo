.PHONY: dev

dev:
	(killall Xcode || true)

	# Generate Xcode structure.
	TUIST_PROJECT_DIR=$(PWD) tuist generate --no-open

	xed Cuckoo.xcworkspace

init:
	# Install Tuist if not present.
	if ! command -v tuist &> /dev/null; then curl -Ls https://install.tuist.io | bash; fi

	# Install Gemfile dependencies if `bundle` is available.
	if ! command -v bundle &> /dev/null; then bundle install; fi

	# Create generated mocks file which will be populated later.
	touch "Tests/Swift/Generated/GeneratedMocks.swift"

	# Generate Cuckoo workspace.
	make dev

ci:
	# Install Tuist if not present.
	if ! command -v tuist &> /dev/null; then curl -Ls https://install.tuist.io | bash; fi

	# Create generated mocks file which will be populated later.
	touch "Tests/Swift/Generated/GeneratedMocks.swift"

	# Generate Cuckoo workspace.
	make dev
