//
//  CuckooGeneratorError.swift
//  CuckooGenerator
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation
import FileKit

public enum CuckooGeneratorError: Error {
    case ioError(FileKitError)
    case unknownError(Error)
    case stderrUsed
    
    public var description: String {
        switch self {
        case .ioError(let error):
            return error.description
        case .unknownError(let error):
            return "\(error)"
        case .stderrUsed:
            return ""
        }
    }
}
