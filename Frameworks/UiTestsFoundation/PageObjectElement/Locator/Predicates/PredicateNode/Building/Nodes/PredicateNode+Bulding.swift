public extension PredicateNode {
    static func &&(left: PredicateNode, right: PredicateNode) -> PredicateNode {
        return .and([left, right])
    }
    
    static func ||(left: PredicateNode, right: PredicateNode) -> PredicateNode {
        return .or([left, right])
    }
    
    static prefix func !(predicate: PredicateNode) -> PredicateNode {
        return .not(predicate)
    }
}
