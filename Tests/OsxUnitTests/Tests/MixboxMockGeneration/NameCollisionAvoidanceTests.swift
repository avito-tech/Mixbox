import MixboxMocksGeneration
import XCTest

final class NameCollisionAvoidanceTests: XCTestCase {
    func test___typeNameAvoidingCollisons___avoids_collisions() {
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
    
    func test___typeNameAvoidingCollisons___generate_deterministic_names() {
        let desiredName = "name"
        let takenNames = Set([desiredName])
        
        XCTAssertNoThrow(try {
            let lhs = try NameCollisionAvoidance.typeNameAvoidingCollisons(
                desiredName: desiredName,
                takenNames: takenNames
            )
            let rhs = try NameCollisionAvoidance.typeNameAvoidingCollisons(
                desiredName: desiredName,
                takenNames: takenNames
            )
            
            XCTAssertEqual(lhs, rhs)
        }())
    }
    
    private func parameterized_test___typeNameAvoidingCollisons___avoids_collisions(
        desiredName: String,
        takenNames: Set<String>,
        itIsExpectedToKeepDesiredName: Bool,
        file: StaticString = #filePath,
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
