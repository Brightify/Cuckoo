import Foundation

class MultiNestedClass {
    private class PrivateNestedClass {
        class ThisClassShouldNotBeMocked2 {
            var property: Int?
        }
    }
}
