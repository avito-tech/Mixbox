import XCTest
import Di
import Bash

final class TeamcityBuildDiTests: XCTestCase {
    func test___TeamcityBuildDi___is_valid() {
        let di = TeamcityBuildDi()
        
        XCTAssertNoThrow(try {
            try di.bootstrap()
            try di.validate()
            }())
    }
    
    func test___TeamcityBuildDi___resolved() {
        let di = TeamcityBuildDi()
        
        XCTAssertNoThrow(try {
            try di.bootstrap()
            _ = try di.resolve() as BashExecutor
            }())
    }
}
