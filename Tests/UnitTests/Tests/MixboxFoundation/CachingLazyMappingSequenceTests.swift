import MixboxFoundation
import XCTest

final class CachingLazyMappingSequenceTests: TestCase {
    func test() {
        let cachingLazyMappingSequence = CachingLazyMappingSequence(
            sourceElements: [0, 1, 2, 3],
            transform: { $0 * 2 }
        )
        
        XCTAssertEqual(cachingLazyMappingSequence.mappedElements, [])
        
        _ = cachingLazyMappingSequence.allSatisfy { $0 < 2 } // causes first two elements to be transformed
        
        XCTAssertEqual(cachingLazyMappingSequence.mappedElements, [0, 2])
        
        XCTAssertEqual(cachingLazyMappingSequence.allElements, [0, 2, 4, 6]) // causes all elements to be transformed
        
        XCTAssertEqual(cachingLazyMappingSequence.mappedElements, [0, 2, 4, 6])
    }
}
