import MixboxDi
import XCTest
import Dip

final class DipDependencyInjectionTests: TestCase {
    func test___resolve___resolves_lastly_registered_dependency() {
        assertDoesntThrow {
            let di = DipDependencyInjection(dependencyContainer: DependencyContainer())
            
            di.register(type: Int.self) { _ in 1 }
            di.register(type: Int.self) { _ in 2 }
            
            XCTAssertEqual(2, try di.resolve())
        }
    }
    
    func test___register___doesnt_cause_retain_cycle() {
        weak var weakDi: DipDependencyInjection?
        
        assertDoesntThrow {
            let di = DipDependencyInjection(dependencyContainer: DependencyContainer())
            
            weakDi = di
            
            di.register(type: Double.self) { _ in 1 }
            di.register(type: Int.self) { di in
                Int(try di.resolve() as Double)
            }
            
            // Little self-check of the test
            XCTAssertEqual(1, try di.resolve())
            XCTAssertNotNil(weakDi)
        }
        
        XCTAssertNil(weakDi)
    }
}
