//
//  VersionCommand.swift
//  CuckooGenerator
//
//  Created by Tadeas Kriz on 17/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Commandant
import Result

public struct VersionCommand: CommandType {
    
    static let appVersion = NSBundle.allFrameworks().filter {
        $0.bundleIdentifier == "org.brightify.CuckooGeneratorFramework"
        }.first?.objectForInfoDictionaryKey("CFBundleShortVersionString") as? String ?? ""
    
    public let verb = "version"
    public let function = "Prints the version of this generator."
    
    public func run(options: Options) -> Result<Void, CuckooGeneratorError> {
        print(VersionCommand.appVersion)
        return .Success()
    }
    
    public struct Options: OptionsType {
        public static func evaluate(m: CommandMode) -> Result<Options, CommandantError<CuckooGeneratorError>> {
            return .Success(Options())
        }
    }
}