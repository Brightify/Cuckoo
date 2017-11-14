.PHONY: xcodeproj

xcodeproj:
	cd Generator && swift package generate-xcodeproj --output ./CuckooGenerator.xcodeproj

dev: xcodeproj
