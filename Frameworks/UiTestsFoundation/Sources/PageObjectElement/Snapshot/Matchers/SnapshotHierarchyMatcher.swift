import MixboxFoundation
import MixboxTestsFoundation

public final class SnapshotHierarchyMatcher: Matcher<ElementSnapshot> {
    public enum UnlimitedUInt {
        case finite(UInt)
        case infinite
        
        func next() -> UnlimitedUInt {
            switch self {
            case .finite(let value):
                return .finite(value + 1)
            case .infinite:
                return .infinite
            }
        }
        
        static func <=(lhs: UnlimitedUInt, rhs: UnlimitedUInt) -> Bool {
            switch (lhs, rhs) {
            case (.infinite, .infinite):
                return true
            case (.finite, .infinite):
                return true
            case (.infinite, .finite):
                return false
            case let (.finite(lhs), .finite(rhs)):
                return lhs <= rhs
            }
        }
    }
    
    // Controls range of depth in a tree of snapshots. It contatins no invalid states
    // like -1 or finite numbers for upper range or infinte numbers of lower range.
    // However... tens of thousands elements will cause stackoverflow anyway.
    // But with this class code is more logical anyway.
    public final class SnapshotTreeDepthRange {
        // 0 - means root snapshot, 1 - direct child
        public let firstSnapshotDepth: UInt
        
        // upper boundary of closed range, meaning that if it's .finite(0),
        // first element IS included.
        public let depthRelativeToFirstSnapshot: UnlimitedUInt
        
        public init(
            firstSnapshotDepth: UInt,
            depthRelativeToFirstSnapshot: UnlimitedUInt)
        {
            self.firstSnapshotDepth = firstSnapshotDepth
            self.depthRelativeToFirstSnapshot = depthRelativeToFirstSnapshot
        }
        
        // Shortcuts:
        
        public static func forRecursiveMatching(
            includingRootSnapshot: Bool = false)
            -> SnapshotTreeDepthRange
        {
            return SnapshotTreeDepthRange(
                firstSnapshotDepth: includingRootSnapshot ? 0 : 1,
                depthRelativeToFirstSnapshot: .infinite
            )
        }
        
        public static func forDirectSubviewsMatching(
            includingRootSnapshot: Bool = false,
            depthRelativeToDirectSubviews: UInt = 0)
            -> SnapshotTreeDepthRange
        {
            // Example 1:
            //
            // [Root] -> [Level 1] -> [Level 2]
            // ^------------------------------^
            //
            // includingRootSnapshot: true
            // depthRelativeToDirectSubviews: 2
            // range: (0, .finite(2))
            //
            // Example 2:
            //
            // [Root] -> [Level 1] -> [Level 2]
            //           ^--------------------^
            //
            // includingRootSnapshot: false
            // depthRelativeToDirectSubviews: 2
            // range: (1, .finite(1))
            //
            
            return SnapshotTreeDepthRange(
                firstSnapshotDepth: includingRootSnapshot ? 0 : 1,
                depthRelativeToFirstSnapshot: .finite(
                    depthRelativeToDirectSubviews + (includingRootSnapshot ? 1 : 0) // additional level for root snapshot
                )
            )
        }
    }
    
    // `depth` can allow to configure, for example,
    // whether matcher should match snapshots recursively or not, contain
    // root snapshot or not, etc
    public init(
        matcher: Matcher<ElementSnapshot>,
        snapshotTreeDepthRange: SnapshotTreeDepthRange)
    {
        super.init(
            description: {
                matcher.description.mb_wrapAndIndent(
                    prefix: "has element in hierarchy {", // TODO: Better description
                    postfix: "}"
                )
            },
            matchingFunction: { (snapshot: ElementSnapshot) -> MatchingResult in
                let isMatching = Self.isMatching(
                    snapshot: snapshot,
                    matcher: matcher,
                    snapshotTreeDepthRange: snapshotTreeDepthRange,
                    currentDepthRelativeToRoot: 0
                )
                
                if isMatching {
                    return .match
                } else {
                    return .exactMismatch(
                        mismatchDescription: { "element wasn't found in hierarchy, matcher: \"\(matcher.description)\"" },
                        attachments: { [] }
                    )
                }
            }
        )
    }
    
    // MARK: - Private
    
    private static func isMatching(
        snapshot: ElementSnapshot,
        matcher: Matcher<ElementSnapshot>,
        snapshotTreeDepthRange: SnapshotTreeDepthRange,
        currentDepthRelativeToRoot: UInt)
        -> Bool
    {
        if currentDepthRelativeToRoot < snapshotTreeDepthRange.firstSnapshotDepth {
            // Didn't find first snapshot to match.
            // Will not match current snapshot.
            
            for subSnapshot in snapshot.children {
                let isMatching = Self.isMatching(
                    snapshot: subSnapshot,
                    matcher: matcher,
                    snapshotTreeDepthRange: snapshotTreeDepthRange,
                    currentDepthRelativeToRoot: currentDepthRelativeToRoot + 1
                )
                
                if isMatching {
                    return true
                }
            }
            
            return false
        } else {
            // Found first snapshot to match
            
            let nextDepth: UnlimitedUInt
            
            switch snapshotTreeDepthRange.depthRelativeToFirstSnapshot {
            case .finite:
                nextDepth = .finite(0)
            case .infinite:
                // `.infinite` is just fitting here. One infinite number is
                // always next to each other and equal to each other. So hiererchy
                // can be indefinitely traversed.
                nextDepth = .infinite
            }
            
            return Self.isMatching(
                snapshot: snapshot,
                matcher: matcher,
                snapshotTreeDepthRange: snapshotTreeDepthRange,
                currentDepthRelativeToFirstSnapshot: nextDepth
            )
        }
    }
    
    private static func isMatching(
        snapshot: ElementSnapshot,
        matcher: Matcher<ElementSnapshot>,
        snapshotTreeDepthRange: SnapshotTreeDepthRange,
        currentDepthRelativeToFirstSnapshot: UnlimitedUInt)
        -> Bool
    {
        if currentDepthRelativeToFirstSnapshot <= snapshotTreeDepthRange.depthRelativeToFirstSnapshot {
            if matcher.match(value: snapshot).matched {
                return true
            }
            
            for subSnapshot in snapshot.children {
                let isMatching = Self.isMatching(
                    snapshot: subSnapshot,
                    matcher: matcher,
                    snapshotTreeDepthRange: snapshotTreeDepthRange,
                    currentDepthRelativeToFirstSnapshot: currentDepthRelativeToFirstSnapshot.next()
                )
                
                if isMatching {
                    return true
                }
            }
        }
        
        return false
    }
}
