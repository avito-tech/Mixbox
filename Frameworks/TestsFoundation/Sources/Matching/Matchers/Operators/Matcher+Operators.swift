// TODO: Should we convert AndMatcher([a, AndMatcher([b, c])]) to AndMatcher([a, b, c])?
//       Or should we at least make logs less like a hell if there are a lot of matchers combined with && or ||?
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
