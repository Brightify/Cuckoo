import Foundation

@available(swift 4.0)
class Multi {
    class Nested {
        class MultiNestedTestedSubclass: TestedClass { }
        
        private class ThisClassShouldNotBeMocked3 {
            var property: Int?
        }
    }
    
    class Layered {
        class Nested {
            class MultiLayeredNestedTestedSubclass: TestedClass { }
            
            private class ThisClassShouldNotBeMocked3 {
                var property: Int?
            }
        }
    }

    class NestedSubclass: Nested {
        
    }
}
