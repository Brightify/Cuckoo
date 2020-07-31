//
//  ObjectiveExamplesTest.swift
//  Cuckoo_OCMock-iOSTests
//
//  Created by Matyáš Kříž on 31/07/2020.
//

import XCTest
import Cuckoo

import CoreBluetooth

class ObjectiveExamplesTest: XCTestCase {
    func testProperties() {
        let mock = objcStub(for: CBCentralManager.self) { stubber, mock in
            stubber.when(mock.delegate).thenReturn(nil)
        }

        let g = mock.delegate

        objcVerify(mock.delegate)
    }
}
