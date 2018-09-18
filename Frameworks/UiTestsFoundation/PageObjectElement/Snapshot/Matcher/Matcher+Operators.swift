public extension Matcher {
    static func &&(left: Matcher, right: Matcher) -> Matcher {
        return AndMatcher([left, right])
    }
    
    static func ||(left: Matcher, right: Matcher) -> Matcher {
        return OrMatcher([left, right])
    }
    
    static prefix func !(matcher: Matcher) -> Matcher {
        return NotMatcher(matcher)
    }
}
