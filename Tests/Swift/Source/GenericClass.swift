import Foundation

class GenericClass<T: CustomStringConvertible, U: Codable & CustomStringConvertible, V: Hashable & Equatable> {
    let constant = 10.0

    var readWritePropertyT: T
    var readWritePropertyU: U
    var readWritePropertyV: V

    var optionalProperty: U?

    init(theT: T, theU: U, theV: V) {
        readWritePropertyT = theT
        readWritePropertyU = theU
        readWritePropertyV = theV
    }

    func genericMethodParameter<G: GenericClass<T, U, V>>(g: G) {}

    func genericMethodParameterNested<G: GenericClass<T, [Int], Array<String>>>(g: G) {}

    func genericWhereMethodParameter<G>(g: G) where G: GenericClass<T, [Int], V> {}

    func genericWhereMethodParameterNested<G>(g: G) where G: GenericClass<T, U, Array<String>> {}

    func unequal(one: V, two: V) -> Bool {
        return one != two
    }

    func getThird(foo: T, bar: U, baz: V) -> V {
        return baz
    }

    func print(theT: T) {
        Swift.print(theT)
    }

    func encode(theU: U) -> Data {
        let encoder = JSONEncoder()
        return try! encoder.encode(["root": theU])
    }

    func withClosure(_ closure: (T) -> Int) -> Int {
        return closure(readWritePropertyT)
    }

    func noReturn() {}

    func genericClosure(gg: String, closure: (GenericClass<String, Int, Bool>) -> Void) {
        closure(GenericClass<String, Int, Bool>(theT: "gg", theU: 0, theV: false))
    }
}
