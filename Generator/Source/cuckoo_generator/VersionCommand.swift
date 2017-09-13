//
//  VersionCommand.swift
//  CuckooGenerator
//
//  Created by Tadeas Kriz on 17/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation
import Commandant
import Result

public struct VersionCommand: CommandProtocol {

    static let appVersion = Bundle.allFrameworks.filter {
        $0.bundleIdentifier == "org.brightify.CuckooGeneratorFramework"
        }.first?.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""

    public let verb = "version"
    public let function = "Prints the version of this generator."

    public func run(_ options: Options) -> Result<Void, CuckooGeneratorError> {
        print(VersionCommand.appVersion)
        return .success(())
    }

    public struct Options: OptionsProtocol {
        public static func evaluate(_ m: CommandMode) -> Result<Options, CommandantError<CuckooGeneratorError>> {
            return .success(Options())
        }
    }
}
