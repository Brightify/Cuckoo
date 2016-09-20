//#!/usr/bin/swift -F Carthage/Build/Mac
//
//  main.swift
//  SwiftMockGenerator
//
//  Created by Tadeas Kriz on 12/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Commandant

let registry = CommandRegistry<CuckooGeneratorError>()
registry.register(command: GenerateMocksCommand())
registry.register(command: VersionCommand())

let helpCommand = HelpCommand(registry: registry)
registry.register(command: helpCommand)

registry.main(defaultVerb: helpCommand.verb) { error in
    fputs(error.description + "\n", stderr)
}
