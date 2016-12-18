//
//  StderrPrint.swift
//  CuckooGenerator
//
//  Created by Filip Dolnik on 18.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation

public private(set) var stderrUsed = false

func stderrPrint(_ item: Any) {
    stderrUsed = true
    fputs("error: \(item)\n", stderr)
}
