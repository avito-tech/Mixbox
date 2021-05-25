import Foundation
import MixboxUiTestsFoundation
import MixboxTestsFoundation
import XCTest

class SnapshotHierarchyMatcherTests: BaseMatcherTests {
    func test___with_only_root_element() {
        // Simple positive case:
        assertMatches(
            hierarchyDepth: 0,
            targetElement: 0,
            firstSnapshotDepth: 0,
            depthRelativeToFirstSnapshot: .finite(0)
        )
        
        // Element within infinite range:
        assertMatches(
            hierarchyDepth: 0,
            targetElement: 0,
            firstSnapshotDepth: 0,
            depthRelativeToFirstSnapshot: .infinite
        )
        
        // Element outside infinite range:
        assertMismatches(
            hierarchyDepth: 0,
            targetElement: 0,
            firstSnapshotDepth: 1,
            depthRelativeToFirstSnapshot: .infinite
        )
        
        // Element outside range (after):
        assertMismatches(
            hierarchyDepth: 0,
            targetElement: 1,
            firstSnapshotDepth: 0,
            depthRelativeToFirstSnapshot: .finite(0)
        )
        
        // Element outside range (before):
        assertMismatches(
            hierarchyDepth: 0,
            targetElement: 0,
            firstSnapshotDepth: 1,
            depthRelativeToFirstSnapshot: .finite(0)
        )
        
        // Element outside range (before):
        assertMismatches(
            hierarchyDepth: 0,
            targetElement: 1,
            firstSnapshotDepth: 0,
            depthRelativeToFirstSnapshot: .finite(1)
        )
    }
    
    func test___with_multiple_elements() {
        // Simple positive case (finite bounds):
        assertMatches(
            hierarchyDepth: 10,
            targetElement: 5,
            firstSnapshotDepth: 0,
            depthRelativeToFirstSnapshot: .finite(10)
        )
        
        // Simple positive case (infinite bounds):
        assertMatches(
            hierarchyDepth: 10,
            targetElement: 5,
            firstSnapshotDepth: 0,
            depthRelativeToFirstSnapshot: .infinite
        )
        
        // Element within range:
        assertMatches(
            hierarchyDepth: 10,
            targetElement: 5,
            firstSnapshotDepth: 5,
            depthRelativeToFirstSnapshot: .finite(0)
        )
        assertMatches(
            hierarchyDepth: 10,
            targetElement: 5,
            firstSnapshotDepth: 4,
            depthRelativeToFirstSnapshot: .finite(1)
        )
        assertMatches(
            hierarchyDepth: 10,
            targetElement: 5,
            firstSnapshotDepth: 5,
            depthRelativeToFirstSnapshot: .infinite
        )
        
        // Element not within range:
        assertMismatches(
            hierarchyDepth: 10,
            targetElement: 5,
            firstSnapshotDepth: 4,
            depthRelativeToFirstSnapshot: .finite(0)
        )
        assertMismatches(
            hierarchyDepth: 10,
            targetElement: 5,
            firstSnapshotDepth: 6,
            depthRelativeToFirstSnapshot: .finite(0)
        )
        assertMismatches(
            hierarchyDepth: 10,
            targetElement: 5,
            firstSnapshotDepth: 6,
            depthRelativeToFirstSnapshot: .infinite
        )
    }
    
    // Unfortunately we can't test hierarchies with billions of items due to
    // performance and memory limitations (it is possible though,
    // because ElementSnapshot may contain infinite number of children if it refers
    // to itself for example).
    // However, this test actually found an issue, even with 10K+ items it caused stackoverflow.
    func test___with_large_numbers() {
        assertMatches(
            hierarchyDepth: 10000,
            targetElement: 10000,
            firstSnapshotDepth: 0,
            depthRelativeToFirstSnapshot: .infinite
        )
        assertMismatches(
            hierarchyDepth: 10000,
            targetElement: 10001,
            firstSnapshotDepth: 0,
            depthRelativeToFirstSnapshot: .infinite
        )
    }
    
    // This causes stack overflow. Code can only work with hierarchies with depths
    // not more than about 10K elements. I bet that this is an acceptable limitation.
    func disabled_test___with_large_numbers() {
        assertMatches(
            hierarchyDepth: 1000000,
            targetElement: 1000000,
            firstSnapshotDepth: 0,
            depthRelativeToFirstSnapshot: .infinite
        )
    }
    
    // Shortcut to `assert` (see below) that is 1 line shorter.
    private func assertMatches(
        hierarchyDepth: Int,
        targetElement: Int,
        firstSnapshotDepth: UInt,
        depthRelativeToFirstSnapshot: SnapshotHierarchyMatcher.UnlimitedUInt,
        file: StaticString = #filePath,
        line: UInt = #line)
    {
        assert(
            matches: true,
            hierarchyDepth: hierarchyDepth,
            targetElement: targetElement,
            firstSnapshotDepth: firstSnapshotDepth,
            depthRelativeToFirstSnapshot: depthRelativeToFirstSnapshot,
            file: file,
            line: line
        )
    }
    
    private func assertMismatches(
        hierarchyDepth: Int,
        targetElement: Int,
        firstSnapshotDepth: UInt,
        depthRelativeToFirstSnapshot: SnapshotHierarchyMatcher.UnlimitedUInt,
        file: StaticString = #filePath,
        line: UInt = #line)
    {
        assert(
            matches: false,
            hierarchyDepth: hierarchyDepth,
            targetElement: targetElement,
            firstSnapshotDepth: firstSnapshotDepth,
            depthRelativeToFirstSnapshot: depthRelativeToFirstSnapshot,
            file: file,
            line: line
        )
    }
    
    // Example:
    //
    // matches == true
    // hierarchyDepth == 2
    // targetElement == 2
    // firstSnapshotDepth == 1
    // depthRelativeToFirstSnapshot == 1
    //
    // Hierarchy:
    //
    // Root(id="0")                                range:[1...2]
    //      |
    //      +--Child(id="1")                             ^      firstSnapshotDepth == 1
    //          |                                        |
    //          +--Child(id="2")  <-  targetElement      v      depthRelativeToFirstSnapshot == 1
    //
    // Views that can not be matched: 0
    // Views that can be matched: 1, 2
    //
    // `targetElement` is `2` and `matches` is `true`, so assert will be successfull.
    //
    private func assert(
        matches: Bool,
        hierarchyDepth: Int,
        targetElement: Int,
        firstSnapshotDepth: UInt,
        depthRelativeToFirstSnapshot: SnapshotHierarchyMatcher.UnlimitedUInt,
        file: StaticString = #filePath,
        line: UInt = #line)
    {
        assert(
            matches: matches,
            hierarchyDepth: hierarchyDepth,
            matcher: matcher(
                targetElement: targetElement,
                range: SnapshotHierarchyMatcher.SnapshotTreeDepthRange(
                    firstSnapshotDepth: firstSnapshotDepth,
                    depthRelativeToFirstSnapshot: depthRelativeToFirstSnapshot
                )
            ),
            file: file,
            line: line
        )
    }
    
    private func matcher(
        targetElement: Int,
        range: SnapshotHierarchyMatcher.SnapshotTreeDepthRange)
        -> SnapshotHierarchyMatcher
    {
        return SnapshotHierarchyMatcher(
            matcher: matcherBuilder.id == "\(targetElement)",
            snapshotTreeDepthRange: range
        )
    }
    
    private func assert(
        matches: Bool,
        hierarchyDepth: Int,
        matcher: SnapshotHierarchyMatcher,
        file: StaticString = #filePath,
        line: UInt = #line)
    {
        let root = ElementSnapshotStub {
            $0.accessibilityIdentifier = "0"
            $0.children = []
        }
        
        var ptr: ElementSnapshotStub = root
        for i in 0..<hierarchyDepth {
            let subview = ElementSnapshotStub {
                $0.accessibilityIdentifier = "\(i + 1)"
                $0.children = []
            }
            ptr.add(child: subview)
            ptr = subview
        }
        
        if matches {
            assertMatches(
                matcher: matcher,
                value: root,
                file: file,
                line: line
            )
        } else {
            assertMismatches(
                matcher: matcher,
                value: root,
                file: file,
                line: line
            )
        }
    }
}
