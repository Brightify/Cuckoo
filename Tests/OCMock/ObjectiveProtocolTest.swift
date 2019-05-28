//
//  ObjectiveProtocolTest.swift
//  Cuckoo+OCMock_iOSTests
//
//  Created by Matyáš Kříž on 28/05/2019.
//

import XCTest
import WebKit
import Cuckoo

class ObjectiveProtocolTest: XCTestCase {
    func testThenDoNothing() {
        let mock = objectiveStub(for: UIScrollViewDelegate.self) { stubber, mock in
            stubber.when(mock.scrollViewDidScrollToTop!(objectiveAny())).thenDoNothing()
        }

        mock.scrollViewDidScrollToTop!(UIScrollView())

        objectiveVerify(mock.scrollViewDidScrollToTop!(objectiveAny()))
    }

    func testThenReturn() {
        let tableView = UITableView()
        let mock = objectiveStub(for: UITableViewDelegate.self) { stubber, mock in
            stubber.when(mock.tableView!(objectiveAny(), canFocusRowAt: IndexPath(row: 0, section: 22))).thenReturn(true)
            stubber.when(mock.tableView!(tableView, canFocusRowAt: IndexPath(row: 1, section: 22))).thenReturn(true)
            stubber.when(mock.tableView!(objectiveAny(), canFocusRowAt: IndexPath(row: 1, section: 22))).thenReturn(false)
        }

        XCTAssertTrue(mock.tableView!(tableView, canFocusRowAt: IndexPath(row: 0, section: 22)))
        XCTAssertTrue(mock.tableView!(tableView, canFocusRowAt: IndexPath(row: 1, section: 22)))
        XCTAssertFalse(mock.tableView!(UITableView(), canFocusRowAt: IndexPath(row: 1, section: 22)))

        objectiveVerify(mock.tableView!(objectiveAny(), canFocusRowAt: IndexPath(row: 0, section: 22)))
        objectiveVerify(mock.tableView!(tableView, canFocusRowAt: IndexPath(row: 0, section: 22)))
        objectiveVerify(mock.tableView!(objectiveAny(), canFocusRowAt: IndexPath(row: 1, section: 22)))
        objectiveVerify(mock.tableView!(tableView, canFocusRowAt: IndexPath(row: 1, section: 22)))
        objectiveVerify(mock.tableView!(objectiveAny(), canFocusRowAt: IndexPath(row: 1, section: 22)))
        objectiveVerify(mock.tableView!(tableView, canFocusRowAt: IndexPath(row: 1, section: 22)))
    }

    func testThen() {
        let webView = WKWebView()
        let mock = objectiveStub(for: WKNavigationDelegate.self) { stubber, mock in
            stubber.when(mock.webView!(objectiveAny(), didFinish: objectiveAny())).then { _ in print("Good boi!") }
            stubber.when(mock.webView!(objectiveAny(), didFail: objectiveAny(), withError: TestError.unknown)).then { _ in print("oh no") }
        }

        mock.webView!(webView, didFinish: WKNavigation())
        mock.webView!(webView, didFail: WKNavigation(), withError: TestError.unknown)

        objectiveVerify(mock.webView!(objectiveAny(), didFinish: objectiveAny()))
        objectiveVerify(mock.webView!(webView, didFinish: objectiveAny()))
        objectiveVerify(mock.webView!(objectiveAny(), didFail: objectiveAny(), withError: TestError.unknown))
        objectiveVerify(mock.webView!(webView, didFail: objectiveAny(), withError: TestError.unknown))
    }

    func testThenWithReturn() {
        let range = NSRange()
        let mock = objectiveStub(for: UITextFieldDelegate.self) { stubber, mock in
            stubber.when(mock.textField?(objectiveAny(), shouldChangeCharactersIn: range, replacementString: "Hello from the other side, ObjC!")).then { args in
                let (textField, range, replacementString) = (args[0] as! UITextField, args[1] as! NSRange, args[2] as! String)
                return replacementString.contains("Hello")
            }
        }

        XCTAssertTrue(mock.textField!(UITextField(), shouldChangeCharactersIn: range, replacementString: "Hello from the other side, ObjC!"))

        objectiveVerify(mock.textField!(objectiveAny(), shouldChangeCharactersIn: range, replacementString: "Hello from the other side, ObjC!"))
    }

    // NOTE: This is an example of a wrong way to test an optional method.
    func testWrongTesting() {
        let mock = objectiveStub(for: UITableViewDelegate.self) { stubber, mock in
            // Returning `nil` from an optional method on a protocol is a no-no.
            stubber.when(mock.tableView!(objectiveAny(), canFocusRowAt: IndexPath(row: 12, section: 22))).thenReturn(nil)
        }

        // You can be sure to trigger some `NSException` if you do return `nil` from an optional protocol method.
        objectiveAssertThrows(mock.tableView!(UITableView(), canFocusRowAt: IndexPath(row: 12, section: 22)))

        objectiveVerify(mock.tableView!(objectiveAny(), canFocusRowAt: IndexPath(row: 12, section: 22)))
    }
}
