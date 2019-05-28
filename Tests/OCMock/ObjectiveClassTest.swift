//
//  ObjectiveClassTest.swift
//  Cuckoo+OCMock_iOSTests
//
//  Created by Matyáš Kříž on 28/05/2019.
//

import XCTest
import Cuckoo

class ObjectiveClassTest: XCTestCase {
    func testThenDoNothing() {
        let mock = objectiveStub(for: UIView.self) { stubber, mock in
            stubber.when(mock.addSubview(objectiveAny())).thenDoNothing()
        }

        mock.addSubview(UIView())

        objectiveVerify(mock.addSubview(objectiveAny()))
    }

    func testThenReturn() {
        let mock = objectiveStub(for: UIView.self) { stubber, mock in
            stubber.when(mock.endEditing(true)).thenReturn(true)
            stubber.when(mock.endEditing(false)).thenReturn(false)
        }

        XCTAssertTrue(mock.endEditing(true))
        XCTAssertFalse(mock.endEditing(false))

        objectiveVerify(mock.endEditing(true))
        objectiveVerify(mock.endEditing(false))
    }

    func testThen() {
        let tableView = UITableView()
        let mock = objectiveStub(for: UITableViewController.self) { stubber, mock in
            stubber.when(mock.numberOfSections(in: tableView)).thenReturn(1)
            stubber.when(mock.tableView(tableView, accessoryButtonTappedForRowWith: IndexPath(row: 420, section: 69))).then { args in
                let (tableView, indexPath) = (args[0] as! UITableView, args[1] as! IndexPath)
                print(tableView, indexPath)
                print("Owie")
            }
        }

        XCTAssertEqual(mock.numberOfSections(in: tableView), 1)
        mock.tableView(tableView, accessoryButtonTappedForRowWith: IndexPath(row: 420, section: 69))

        objectiveVerify(mock.numberOfSections(in: tableView))
        objectiveVerify(mock.tableView(tableView, accessoryButtonTappedForRowWith: IndexPath(row: 420, section: 69)))
    }

    func testThenWithReturn() {
        let event = UIEvent()
        let view = UIView()
        let mock = objectiveStub(for: UIView.self) { stubber, mock in
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
        }

        XCTAssertTrue(mock.endEditing(false))
        XCTAssertNil(mock.hitTest(.zero, with: event))
        XCTAssertEqual(mock.hitTest(CGPoint(x: 145.5, y: 0.444), with: event), view)
        XCTAssertEqual(mock.userActivity?.activityType, "activity")

        objectiveVerify(mock.endEditing(false))
        objectiveVerify(mock.hitTest(.zero, with: event))
        objectiveVerify(mock.hitTest(CGPoint(x: 145.5, y: 0.444), with: event))
        objectiveVerify(mock.userActivity?.activityType)
    }

    func testThenThrow() {
        let mock = objectiveStub(for: UINavigationController.self) { stubber, mock in
            stubber.when(mock.resignFirstResponder()).thenThrow(TestError.unknown)
        }

        objectiveAssertThrows(errorHandler: { print($0) }, mock.resignFirstResponder())

        objectiveVerify(mock.resignFirstResponder())
    }

    func testNetworkRequest() {
        var savedCompletionHandler: ((Data?, URLResponse?, Error?) -> Void)?
        let dataTaskMock = objectiveStub(for: URLSessionDataTask.self) { stubber, mock in
            stubber.when(mock.resume()).then { _ in
                guard let data = "Hello, upgraded Cuckoo!".data(using: .utf8) else {
                    savedCompletionHandler?(nil, nil, TestError.unknown)
                    return
                }
                savedCompletionHandler?(data, nil, nil)
            }
        }

        let url = URL(string: "https://github.com/Brightify/Cuckoo")!
        let mock = objectiveStub(for: URLSession.self) { stubber, mock in
            stubber.when(mock.dataTask(with: url, completionHandler: objectiveAnyClosure())).then { args in
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
}
