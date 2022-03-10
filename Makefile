.PHONY: dev

dev:
	(killall Xcode || true)
	tuist generate --no-open
	# Use Bundler if available, otherwise just call system-wide CocoaPods.
	if ! command -v bundle &> /dev/null; then bundle install && bundle exec pod install; else pod install; fi
	xed Cuckoo.xcworkspace

init:
	# Install Tuist if not present.
	if ! command -v tuist &> /dev/null; then curl -Ls https://install.tuist.io | bash; fi
	# Install Gemfile dependencies if `bundle` is available.
	if ! command -v bundle &> /dev/null; then bundle install; fi
	# Pre-generate test file with generated mocks.
	touch "Tests/Swift/Generated/GeneratedMocks.swift"
	# Generate Cuckoo workspace.
	make dev
