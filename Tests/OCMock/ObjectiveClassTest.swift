//
//  ObjectiveClassTest.swift
//  Cuckoo+OCMock_iOSTests
//
//  Created by Matyáš Kříž on 28/05/2019.
//

import OCMock
import Cuckoo
import XCTest

#if os(iOS)
class ObjectiveClassTest: XCTestCase {
    func testThenDoNothing() {
        let mock = objcStub(for: UIView.self) { stubber, mock in
            stubber.when(mock.addSubview(objcAny())).thenDoNothing()
        }

        mock.addSubview(UIView())

        objcVerify(mock.addSubview(objcAny()))
    }

    func testThenReturn() {
        let subViews = [UIView()]
        let mock = objcStub(for: UIView.self) { stubber, mock in
            stubber.when(mock.endEditing(true)).thenReturn(true)
            stubber.when(mock.endEditing(false)).thenReturn(false)
            stubber.when(mock.subviews).thenReturn(subViews)
        }

        XCTAssertTrue(mock.endEditing(true))
        XCTAssertFalse(mock.endEditing(false))
        XCTAssertEqual(mock.subviews, subViews)
        
        objcVerify(mock.endEditing(true))
        objcVerify(mock.endEditing(false))
        objcVerify(mock.subviews)
    }

    func testThen() {
        let tableView = UITableView()
        let mock = objcStub(for: UITableViewController.self) { stubber, mock in
            stubber.when(mock.numberOfSections(in: tableView)).thenReturn(1)
            stubber.when(mock.tableView(tableView, accessoryButtonTappedForRowWith: IndexPath(row: 420, section: 69))).then { args in
                let (tableView, indexPath) = (args[0] as! UITableView, args[1] as! IndexPath)
                print(tableView, indexPath)
                print("Owie")
            }
        }

        XCTAssertEqual(mock.numberOfSections(in: tableView), 1)
        mock.tableView(tableView, accessoryButtonTappedForRowWith: IndexPath(row: 420, section: 69))

        objcVerify(mock.numberOfSections(in: tableView))
        objcVerify(mock.tableView(tableView, accessoryButtonTappedForRowWith: IndexPath(row: 420, section: 69)))
    }

    func testThenWithReturn() {
        let event = UIEvent()
        let view = UIView()
        let mock = objcStub(for: UIView.self) { stubber, mock in
            stubber.when(mock.endEditing(false)).then { args in
                print("Hello, \(args).")
                return true
            }
            stubber.when(mock.hitTest(CGPoint.zero, with: event)).then { args in
                print("Hello, \(args).")
                return nil
            }
            stubber.when(mock.hitTest(CGPoint(x: 145.5, y: 0.444), with: event)).then { args in
                print("Hello, \(args).")
                return view
            }
            stubber.when(mock.userActivity).then { args in
                print("Hello, \(args).")
                return NSUserActivity(activityType: "activity")
            }
            stubber.when(mock.subviews).then { args in
                print("Hello, \(args).")
                return []
            }
        }

        XCTAssertTrue(mock.endEditing(false))
        XCTAssertNil(mock.hitTest(.zero, with: event))
        XCTAssertEqual(mock.hitTest(CGPoint(x: 145.5, y: 0.444), with: event), view)
        XCTAssertEqual(mock.userActivity?.activityType, "activity")
        XCTAssertEqual(mock.subviews, [])

        objcVerify(mock.endEditing(false))
        objcVerify(mock.hitTest(.zero, with: event))
        objcVerify(mock.hitTest(CGPoint(x: 145.5, y: 0.444), with: event))
        objcVerify(mock.userActivity?.activityType)
        objcVerify(mock.subviews)
    }

    func testThenThrow() {
        let mock = objcStub(for: UINavigationController.self) { stubber, mock in
            stubber.when(mock.resignFirstResponder()).thenThrow(TestError.unknown)
        }

        objectiveAssertThrows(errorHandler: { print($0) }, mock.resignFirstResponder())

        objcVerify(mock.resignFirstResponder())
    }

    func testArgumentClosure() {
        var savedCompletionHandler: ((Data?, URLResponse?, Error?) -> Void)?
        let dataTaskMock = objcStub(for: URLSessionDataTask.self) { stubber, mock in
            stubber.when(mock.resume()).then { _ in
                guard let data = "Hello, upgraded Cuckoo!".data(using: .utf8) else {
                    savedCompletionHandler?(nil, nil, TestError.unknown)
                    return
                }
                savedCompletionHandler?(data, nil, nil)
            }
        }

        let url = URL(string: "https://github.com/Brightify/Cuckoo")!
        let mock = objcStub(for: URLSession.self) { stubber, mock in
            stubber.when(mock.dataTask(with: url, completionHandler: objcAnyClosure())).then { args in
                // NOTE: when you need to get a closure from an argument, this is the only way to do it
                let completionHandler = objectiveArgumentClosure(from: args[1]) as (Data?, URLResponse?, Error?) -> Void
                savedCompletionHandler = completionHandler
                return dataTaskMock
            }
        }

        mock.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
        }.resume()
    }

    func testStubPriority() {
        let mock = objcStub(for: UITextField.self) { stubber, mock in
            stubber.when(mock.shouldChangeText(in: objcAny(), replacementText: "pappa pia")).thenReturn(false)
            stubber.when(mock.shouldChangeText(in: objcAny(), replacementText: "mamma mia")).thenReturn(true)
            // NOTE: In ObjC mocking, the general `objcAny()` must be at the bottom, else it captures all the other stubs declared after it.
            stubber.when(mock.shouldChangeText(in: objcAny(), replacementText: objcAny())).thenReturn(false)
        }

        XCTAssertFalse(mock.shouldChangeText(in: objcAny(), replacementText: "pappa pia"))
        XCTAssertTrue(mock.shouldChangeText(in: objcAny(), replacementText: "mamma mia"))
        XCTAssertFalse(mock.shouldChangeText(in: objcAny(), replacementText: "lalla lia"))

        objcVerify(mock.shouldChangeText(in: objcAny(), replacementText: "pappa pia"))
        objcVerify(mock.shouldChangeText(in: objcAny(), replacementText: "mamma mia"))
        objcVerify(mock.shouldChangeText(in: objcAny(), replacementText: "lalla lia"))
    }

    func testSwiftClass() {
        let mock = objcStub(for: SwiftClass.self) { stubber, mock in
            stubber.when(mock.dudka(lelo: "heya")).thenReturn(false)
            stubber.when(mock.dudka(lelo: "heyda")).thenReturn(true)
        }

        XCTAssertFalse(mock.dudka(lelo: "heya"))
        XCTAssertTrue(mock.dudka(lelo: "heyda"))

        objcVerify(mock.dudka(lelo: objcAny()))
    }
    
    func testVerifyAtLeast() {
        let mock = objcStub(for: UIView.self) { stubber, mock in
            stubber.when(mock.addSubview(objcAny())).thenDoNothing()
        }

        mock.addSubview(UIView())
        mock.addSubview(UIView())
        mock.addSubview(UIView())
        mock.addSubview(UIView())

        objcVerify(mock.addSubview(objcAny()), .atLeast(2))
    }
    
    func testVerifyAtMost() {
        let mock = objcStub(for: UIView.self) { stubber, mock in
            stubber.when(mock.addSubview(objcAny())).thenDoNothing()
        }

        mock.addSubview(UIView())
        mock.addSubview(UIView())

        objcVerify(mock.addSubview(objcAny()), .atMost(3))
    }
    
    func testVerifyExactly() {
        let mock = objcStub(for: UIView.self) { stubber, mock in
            stubber.when(mock.endEditing(true)).thenReturn(true)
            stubber.when(mock.endEditing(false)).thenReturn(true)
            stubber.when(mock.addSubview(objcAny())).thenDoNothing()
        }

        mock.endEditing(true)
        mock.endEditing(false)
        mock.endEditing(true)
        mock.endEditing(true)
        
        mock.addSubview(UIView())
        mock.addSubview(UIView())
        
        
        objcVerify(mock.endEditing(true), .exactly(3))
        objcVerify(mock.endEditing(false), .exactly(1))
        objcVerify(mock.addSubview(objcAny()), .exactly(2))
    }
}

class SwiftClass: NSObject {
    @objc
    // `dynamic` modifier is necessary
    dynamic func dudka(lelo: String) -> Bool {
        return false
    }
}
#else
#warning("macOS tests are missing.")
#endif
