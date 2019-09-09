import MixboxFoundation
import XCTest

final class CollectionExtensionTests: TestCase {
    private struct EquatablePair: Equatable {
        let first: Int
        let second: Int
        
        init(_ tuple: (Int, Int)) {
            (first, second) = tuple
        }
    }
    
    private let empty = [Int]()
    
    // MARK: - mb_chunked
    
    // Positive cases
    
    func test___mb_chunked___returns_correct_chunks___for_obviously_correct_input() {
        XCTAssertEqual(
            try [1, 2, 3].mb_chunked(chunkSize: 1),
            [[1], [2], [3]]
        )
    
        XCTAssertEqual(
            try [1, 2, 3].mb_chunked(chunkSize: 2),
            [[1, 2], [3]]
        )
        
        XCTAssertEqual(
            try [1, 2, 3].mb_chunked(chunkSize: 3),
            [[1, 2, 3]]
        )
    
        XCTAssertEqual(
            try [1, 2, 3].mb_chunked(chunkSize: 4),
            [[1, 2, 3]]
        )
    }
    
    // Errors
    
    func test___mb_chunked___throws_error_for_negative_chunkSize() {
        assertThrows(error: "chunkSize should not be negative (chunkSize == -1)") {
            _ = try [1, 2, 3].mb_chunked(chunkSize: -1)
        }
    }
    
    func test___mb_chunked___throws_error___for_zero_chunkSize___for_non_empty_collection() {
        assertThrows(error: "Can not chunk non-empty collection into empty chunks (chunkSize == 0)") {
            _ = try [1, 2, 3].mb_chunked(chunkSize: 0)
        }
    }
    
    // Empty collection
    
    func test___mb_chunked___throws_error__for_empty_collection___if_chunkSize_is_negative() {
        assertThrows(error: "chunkSize should not be negative (chunkSize == -1)") {
            _ = try empty.mb_chunked(chunkSize: -1)
        }
    }
    
    func test___mb_chunked___returns_zero_chunks___for_empty_collection___if_chunkSize_is_zero() {
        XCTAssertEqual(
            try [Int]().mb_chunked(chunkSize: 0),
            [[Int]]()
        )
    }
    
    func test___mb_chunked___returns_zero_chunks___for_empty_collection___if_chunkSize_is_positive() {
        XCTAssertEqual(
            try [Int]().mb_chunked(chunkSize: 1),
            [[Int]]()
        )
        
        XCTAssertEqual(
            try [Int]().mb_chunked(chunkSize: 2),
            [[Int]]()
        )
    }
    
    // Int boundary values
    
    func test___mb_chunked___works_with_int_max() {
        XCTAssertEqual(
            try [1].mb_chunked(chunkSize: Int.max),
            [[1]]
        )
    }
    
    func test___mb_chunked___works_with_int_min() {
        assertThrows(error: "chunkSize should not be negative (chunkSize == \(Int.min))") {
            _ = try [1].mb_chunked(chunkSize: Int.min)
        }
    }
    
    // MARK: - mb_zip
    
    func test___mb_zip() {
        XCTAssertEqual(
            mb_zip([1], [2], pad: 0).map { EquatablePair($0) },
            zip([1], [2]).map { EquatablePair($0) }
        )
        
        XCTAssertEqual(
            mb_zip(empty, [2], pad: 0).map { EquatablePair($0) },
            zip([0], [2]).map { EquatablePair($0) }
        )
        
        XCTAssertEqual(
            mb_zip([1], empty, pad: 0).map { EquatablePair($0) },
            zip([1], [0]).map { EquatablePair($0) }
        )
        
        XCTAssertEqual(
            mb_zip(empty, empty, pad: 0).map { EquatablePair($0) },
            zip(empty, empty).map { EquatablePair($0) }
        )
    }
    
    // MARK: - mb_elementAtIndex
    
    func test___mb_elementAtIndex() {
        XCTAssertEqual(
            [1].mb_elementAtIndex(0),
            1
        )
        
        XCTAssertEqual(
            [1].mb_elementAtIndex(1),
            nil
        )
        
        XCTAssertEqual(
            [1].mb_elementAtIndex(-1),
            nil
        )
        
        XCTAssertEqual(
            empty.mb_elementAtIndex(0),
            nil
        )
        
        XCTAssertEqual(
            empty.mb_elementAtIndex(1),
            nil
        )
        
        XCTAssertEqual(
            empty.mb_elementAtIndex(-1),
            nil
        )
        
        XCTAssertEqual(
            [1].mb_elementAtIndex(Int.min),
            nil
        )
        
        XCTAssertEqual(
            [1].mb_elementAtIndex(Int.max),
            nil
        )
    }
    
    // MARK: - mb_only
    
    func test___mb_only() {
        XCTAssertEqual(
            empty.mb_only,
            nil
        )
        
        XCTAssertEqual(
            [1].mb_only,
            1
        )
        
        XCTAssertEqual(
            [1, 2].mb_only,
            nil
        )
    }
}
