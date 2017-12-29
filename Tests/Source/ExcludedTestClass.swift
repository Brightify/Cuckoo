//
//  ExcludedTestClass.swift
//  Cuckoo
//
//  Created by Arjan Duijzer on 29/12/2017.
//  Copyright © 2017 Brightify. All rights reserved.
//

class ExcludedTestClass {

    func shouldNotBeAvailable() {
    }

}

class IncludedTestClass {

    func shouldExist() {

    }

}

protocol IncludedProtocol {}

protocol ExcludedProtocol {}
