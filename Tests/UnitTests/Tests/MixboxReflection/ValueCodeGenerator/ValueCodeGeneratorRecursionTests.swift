import XCTest
import MixboxReflection
import UIKit

final class ValueCodeGeneratorRecursionTests: BaseValueCodeGeneratorTests {
    func test___generateCode___doesnt_fall_into_recursion() {
        class Pooh {
            weak var thatsNotHoney: Pooh?
        }
        
        let pooh = Pooh()
        pooh.thatsNotHoney = pooh
        
        check(
            pooh,
            """
            Pooh(
                thatsNotHoney: <circular reference to Pooh>
            )
            """
        )
    }
}
