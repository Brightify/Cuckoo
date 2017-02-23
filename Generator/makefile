default: build

build:
	swift build
	.build/debug/TemplateEncoder > Source/CuckooGeneratorFramework/Templates.swift
	swift build
	cp .build/debug/cuckoo_generator .
