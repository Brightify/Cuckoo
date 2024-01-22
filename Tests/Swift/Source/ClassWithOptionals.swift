class ClassWithOptionals {

    var value: Int? = 0

    var uValue: Int! = 0

    var array: [Int?] = []

    var closure: (Int?) -> Void = { _ in }

    func returnValue() -> Int? {
        return value
    }

    func returnUValue() -> Int! {
        return uValue
    }

    func returnArray() -> [Int?] {
        return array
    }

    func parameter(parameter: Int?) {
    }

    func uParameter(parameter: Int!) {
    }
}
