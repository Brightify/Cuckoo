import Foundation

@objc
protocol ObjcProtocol {
    @objc
    optional func optionalMethod()
}

@objc
class ObjcClass: NSObject {
    @objc
    func objcMethod() {}
}

@objcMembers
class ObjcMembersClass {
    func objcMethod() {}
}
