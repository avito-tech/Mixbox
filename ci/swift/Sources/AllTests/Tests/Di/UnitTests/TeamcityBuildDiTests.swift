import XCTest
import Di
import Bash

final class TeamcityBuildDiTests: XCTestCase {
    func test___TeamcityBuildDi___is_valid() {
        let di = TeamcityBuildDi()
        
        XCTAssertNoThrow(try {
            try di.bootstrap(overrides: { _ in })
            try di.validate()
            }())
    }
    
    func test___TeamcityBuildDi___resolved() {
        let di = TeamcityBuildDi()
        
        XCTAssertNoThrow(try {
            try di.bootstrap(overrides: { _ in })
            _ = try di.resolve() as BashExecutor
            }())
    }
}
