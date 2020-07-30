@testable import MixboxInAppServices
import XCTest

final class VisibilityCheckForLoopOptimizerImplTests: TestCase {
    override func setUp() {
        super.setUp()
        
        self.continueAfterFailure = false
    }
    
    func test___foreach___doesnt_iterate___for_zero_number_of_points() {
        XCTAssertEqual(
            points(number: 0, x: 10, y: 10).count,
            0
        )
    }
    
    func test___foreach___iterate_central_point___for_number_of_points_equals_to_one() {
        XCTAssertEqual(
            points(number: 1, x: 10, y: 10),
            points([(5, 5)])
        )
    }

    func test___foreach___iterate_correctly___for_perfectly_divided_grid() {
        XCTAssertEqual(
            points(number: 4, x: 4, y: 4),
            points([
                (1, 1), (3, 1),
                (1, 3), (3, 3)
            ])
        )
    }
    
    func test___foreach___doesnt_optimize___if_image_size_has_less_points_than_number_of_points_in_grid() {
        XCTAssertEqual(
            points(number: 100, x: 10, y: 10).count,
            100
        )
    }
    
    func test___foreach___never_iterates_same_point_twice() {
        // 0..10 + prime numbers
        let dataSet = [
            0, 1, 2, 3, 5, 6, 7, 8, 9, 10,
            11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97
        ]
        for number in [9999, 10000, 10001] {
            for x in dataSet {
                for y in dataSet {
                    assertThereIsNoDuplicates(number: number, x: x, y: y)
                }
            }
        }
    }
    
    private func assertThereIsNoDuplicates(number: Int, x: Int, y: Int) {
        let size = IntSize(width: x, height: y)
        let optimizer = VisibilityCheckForLoopOptimizerImpl(
            numberOfPointsInGrid: number,
            useHundredPercentAccuracy: false
        )
        var points = Set<IntPoint>()
        optimizer.forEachPoint(imageSize: size) { (x, y) in
            let point = IntPoint(x: x, y: y)
            let (inserted, _) = points.insert(point)
            
            XCTAssert(inserted, "Duplicated point: \(point). Number of points: \(number), size: \(size)")
        }
    }
    
    private func points(_ tuples: [(Int, Int)]) -> [IntPoint] {
        return tuples.map { x, y in
            IntPoint(x: x, y: y)
        }
    }
    
    private func points(number: Int, x: Int, y: Int) -> [IntPoint] {
        let size = IntSize(width: x, height: y)
        let optimizer = VisibilityCheckForLoopOptimizerImpl(
            numberOfPointsInGrid: number,
            useHundredPercentAccuracy: false
        )
        var points = [IntPoint]()
        optimizer.forEachPoint(imageSize: size) { (x, y) in
            points.append(IntPoint(x: x, y: y))
        }
        return points
    }
}

extension IntPoint: CustomStringConvertible {
    public var description: String {
        return "(\(x), \(y))"
    }
}

extension IntSize: CustomStringConvertible {
    public var description: String {
        return "(\(width), \(height))"
    }
}
