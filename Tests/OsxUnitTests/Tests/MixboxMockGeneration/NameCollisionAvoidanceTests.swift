import MixboxMocksGeneration
import XCTest

final class NameCollisionAvoidanceTests: XCTestCase {
    func test() {
        parameterized_test___typeNameAvoidingCollisons___avoids_collisions(
            desiredName: "a",
            takenNames: [],
            itIsExpectedToKeepDesiredName: true
        )
        
        parameterized_test___typeNameAvoidingCollisons___avoids_collisions(
            desiredName: "a",
            takenNames: ["a"],
            itIsExpectedToKeepDesiredName: false
        )
        
        parameterized_test___typeNameAvoidingCollisons___avoids_collisions(
            desiredName: "a",
            takenNames: ["b"],
            itIsExpectedToKeepDesiredName: true
        )
    }
    
    private func parameterized_test___typeNameAvoidingCollisons___avoids_collisions(
        desiredName: String,
        takenNames: Set<String>,
        itIsExpectedToKeepDesiredName: Bool,
        file: StaticString = #file,
        line: UInt = #line)
    {
        XCTAssertNoThrow(try {
            let typeNameAvoidingCollisons = try NameCollisionAvoidance.typeNameAvoidingCollisons(
                desiredName: desiredName,
                takenNames: takenNames
            )
            
            if itIsExpectedToKeepDesiredName {
                XCTAssertEqual(
                    typeNameAvoidingCollisons,
                    desiredName
                )
            } else {
                XCTAssertNotEqual(
                    typeNameAvoidingCollisons,
                    desiredName,
                    file: file,
                    line: line
                )
                
                XCTAssert(
                    takenNames.contains(desiredName),
                    file: file,
                    line: line
                )
                
                XCTAssert(
                    !takenNames.contains(typeNameAvoidingCollisons),
                    file: file,
                    line: line
                )
            }
        }())
    }
}
