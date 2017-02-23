//#!/usr/bin/swift -F Carthage/Build/Mac
//
//  main.swift
//  SwiftMockGenerator
//
//  Created by Tadeas Kriz on 12/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation
import Commandant

let registry = CommandRegistry<CuckooGeneratorError>()
registry.register(GenerateMocksCommand())
registry.register(VersionCommand())

let helpCommand = HelpCommand(registry: registry)
registry.register(helpCommand)

registry.main(defaultVerb: helpCommand.verb) { error in
    switch error {
    case .stderrUsed:
        break
    default:
        fputs(error.description + "\n", stderr)
    }
}
