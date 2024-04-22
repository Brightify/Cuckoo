import XCTest
import Cuckoo

#if os(iOS)
import WebKit

final class ObjectiveProtocolTest: XCTestCase {
    func testThenDoNothing() {
        let mock = objcStub(for: UIScrollViewDelegate.self) { stubber, mock in
            stubber.when(mock.scrollViewDidScrollToTop!(objcAny())).thenDoNothing()
        }

        mock.scrollViewDidScrollToTop!(UIScrollView())

        objcVerify(mock.scrollViewDidScrollToTop!(objcAny()))
    }

    func testThenReturn() {
        let tableView = UITableView()
        let mock = objcStub(for: UITableViewDelegate.self) { stubber, mock in
            stubber.when(mock.tableView!(objcAny(), canFocusRowAt: IndexPath(row: 0, section: 22))).thenReturn(true)
            stubber.when(mock.tableView!(tableView, canFocusRowAt: IndexPath(row: 1, section: 22))).thenReturn(true)
            stubber.when(mock.tableView!(objcAny(), canFocusRowAt: IndexPath(row: 1, section: 22))).thenReturn(false)
        }

        XCTAssertTrue(mock.tableView!(tableView, canFocusRowAt: IndexPath(row: 0, section: 22)))
        XCTAssertTrue(mock.tableView!(tableView, canFocusRowAt: IndexPath(row: 1, section: 22)))
        XCTAssertFalse(mock.tableView!(UITableView(), canFocusRowAt: IndexPath(row: 1, section: 22)))

        objcVerify(mock.tableView!(objcAny(), canFocusRowAt: IndexPath(row: 0, section: 22)))
        objcVerify(mock.tableView!(tableView, canFocusRowAt: IndexPath(row: 0, section: 22)))
        objcVerify(mock.tableView!(objcAny(), canFocusRowAt: IndexPath(row: 1, section: 22)), .atLeast(1))
        objcVerify(mock.tableView!(tableView, canFocusRowAt: IndexPath(row: 1, section: 22)))
        objcVerify(mock.tableView!(objcAny(), canFocusRowAt: IndexPath(row: 1, section: 22)), .atLeast(1))
        objcVerify(mock.tableView!(tableView, canFocusRowAt: IndexPath(row: 1, section: 22)))
    }

    func testThen() {
        let webView = WKWebView()
        let mock = objcStub(for: WKNavigationDelegate.self) { stubber, mock in
            stubber.when(mock.webView!(objcAny(), didFinish: objcAny())).then { _ in print("Good boi!") }
            stubber.when(mock.webView!(objcAny(), didFail: objcAny(), withError: TestError.unknown)).then { _ in print("oh no") }
        }

        mock.webView!(webView, didFinish: WKNavigation())
        mock.webView!(webView, didFail: WKNavigation(), withError: TestError.unknown)

        objcVerify(mock.webView!(objcAny(), didFinish: objcAny()))
        objcVerify(mock.webView!(webView, didFinish: objcAny()))
        objcVerify(mock.webView!(objcAny(), didFail: objcAny(), withError: TestError.unknown))
        objcVerify(mock.webView!(webView, didFail: objcAny(), withError: TestError.unknown))
    }

    func testThenWithReturn() {
        let range = NSRange()
        let mock = objcStub(for: UITextFieldDelegate.self) { stubber, mock in
            stubber.when(mock.textField?(objcAny(), shouldChangeCharactersIn: range, replacementString: objcAny())).then { args in
                let (textField, range, replacementString) = (args[0] as! UITextField, args[1] as! NSRange, args[2] as! String)
                return replacementString.contains("Hello")
            }
        }

        XCTAssertTrue(mock.textField!(UITextField(), shouldChangeCharactersIn: range, replacementString: "Hello from the other side, ObjC!"))
        XCTAssertFalse(mock.textField!(UITextField(), shouldChangeCharactersIn: range, replacementString: "TadeasKriz is a HaXoR."))

        objcVerify(mock.textField!(objcAny(), shouldChangeCharactersIn: range, replacementString: "Hello from the other side, ObjC!"))
        objcVerify(mock.textField!(objcAny(), shouldChangeCharactersIn: range, replacementString: "TadeasKriz is a HaXoR."))
        objcVerify(mock.textField!(objcAny(), shouldChangeCharactersIn: range, replacementString: objcAny()), .atLeast(1))
    }

    // NOTE: This is an example of a wrong way to test an optional method.
    func testWrongTesting() {
        let mock = objcStub(for: UITableViewDelegate.self) { stubber, mock in
            // Returning `nil` from an optional method on a protocol is a no-no.
            stubber.when(mock.tableView!(objcAny(), canFocusRowAt: IndexPath(row: 12, section: 22))).thenReturn(nil)
        }

        // You can be sure to trigger some `NSException` if you do return `nil` from an optional protocol method.
        objectiveAssertThrows(mock.tableView!(UITableView(), canFocusRowAt: IndexPath(row: 12, section: 22)))

        objcVerify(mock.tableView!(objcAny(), canFocusRowAt: IndexPath(row: 12, section: 22)))
    }
}
#else
#warning("macOS tests are missing.")
#endif
