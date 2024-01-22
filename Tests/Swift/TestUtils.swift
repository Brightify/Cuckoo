@testable import Cuckoo

struct TestUtils {
    static func catchCuckooFail(inClosure closure: () -> ()) -> String? {
        let fail = MockManager.fail
        var msg: String?
        MockManager.fail = { (parameters) in
            let (message, _) = parameters
            msg = message
        }
        closure()
        MockManager.fail = fail
        return msg
    }
}
