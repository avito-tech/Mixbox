import MixboxUiTestsFoundation

// This class provides matchers.
// It is overcomplicated, because it supports good human readable descriptions, including mismatch descriptions.
// It is useful to see in reports what was wrong and how to make it right.
public final class ElementSnapshotMatchers {
    static func matcherForPredicate(_ predicate: PredicateNode) -> ElementSnapshotMatcher {
        switch predicate {
        case .and(let predicateNodes):
            return ElementSnapshotMatchers.and(predicateNodes.map(matcherForPredicate))
            
        case .or(let predicateNodes):
            return ElementSnapshotMatchers.or(predicateNodes.map(matcherForPredicate))
            
        case .not(let nestedPredicate):
            return ElementSnapshotMatchers.not(matcherForPredicate(nestedPredicate))
            
        case .alwaysTrue:
            return ElementSnapshotMatchers.alwaysTrue()
            
        case .alwaysFalse:
            return ElementSnapshotMatchers.alwaysFalse()
            
        case .accessibilityLabel(let value):
            return ElementSnapshotMatchers.accessibilityLabel(value)
            
        case .accessibilityValue(let value):
            return ElementSnapshotMatchers.accessibilityValue(value)
            
        case .accessibilityPlaceholderValue(let value):
            return ElementSnapshotMatchers.accessibilityPlaceholderValue(value)
            
        case .accessibilityId(let value):
            return ElementSnapshotMatchers.accessibilityId(value)
            
        case .visibleText(let value):
            return ElementSnapshotMatchers.visibleText(value)
            
        case .type(let value):
            return ElementSnapshotMatchers.type(value)
            
        case .isInstanceOf(let value):
            return ElementSnapshotMatchers.isInstanceOf(value)
            
        case .isSubviewOf(let nestedPredicate):
            return ElementSnapshotMatchers.isSubviewOf(matcherForPredicate(nestedPredicate))
        }
    }
    
    static func and(_ matchers: [ElementSnapshotMatcher]) -> ElementSnapshotMatcher {
        let prefix = "Всё из"
        
        return ElementSnapshotMatcher(
            description: ElementSnapshotMatcherDescriptions.joinedDescriptions(
                prefix: prefix,
                matchers: matchers
            ),
            matchingFunction: { snapshot in
                let matchingResults = matchers.map { $0.matches(snapshot: snapshot) }
                let exactMatch = matchingResults.reduce(true) { result, matchingResult in
                    result && matchingResult.matched
                }
                
                if exactMatch {
                    return MatchingResult.match
                } else {
                    let sumOfPercentageOfMatching = matchingResults.reduce(Double(0)) { result, matchingResult in
                        result + matchingResult.percentageOfMatching
                    }
                    
                    return MatchingResult.partialMismatch(
                        percentageOfMatching: sumOfPercentageOfMatching / Double(matchingResults.count),
                        mismatchDescription: ElementSnapshotMatcherDescriptions.joinedFails(
                            prefix: prefix,
                            matchers: matchers,
                            results: matchingResults
                        )
                    )
                }
            }
        )
    }
    
    static func or(_ matchers: [ElementSnapshotMatcher]) -> ElementSnapshotMatcher {
        let prefix = "Любое из"
        
        return ElementSnapshotMatcher(
            description: ElementSnapshotMatcherDescriptions.joinedDescriptions(
                prefix: prefix,
                matchers: matchers
            ),
            matchingFunction: { snapshot in
                let matchingResults = matchers.map { $0.matches(snapshot: snapshot) }
                let exactMatch = matchingResults.reduce(false) { result, matchingResult in
                    result || matchingResult.matched
                }
                
                if exactMatch {
                    return MatchingResult.match
                } else {
                    // 0.1 || 0.9 || 0.2 => 0.9
                    let maxPercentageOfMatching = matchingResults.reduce(Double(0)) { result, matchingResult in
                        max(result, matchingResult.percentageOfMatching)
                    }
                    
                    return MatchingResult.partialMismatch(
                        percentageOfMatching: maxPercentageOfMatching,
                        mismatchDescription: ElementSnapshotMatcherDescriptions.joinedFails(
                            prefix: prefix,
                            matchers: matchers,
                            results: matchingResults
                        )
                    )
                }
            }
        )
    }
    
    static func not(_ matcher: ElementSnapshotMatcher) -> ElementSnapshotMatcher {
        let description: () -> String = {
            "Отрицание матчера " + matcher.description()
        }
        return ElementSnapshotMatcher(
            description: description,
            matchingFunction: { snapshot in
                if !matcher.matches(snapshot: snapshot).matched {
                    return .match
                } else {
                    return MatchingResult.exactMismatch(
                        mismatchDescription: { "Отрицание матчера зафейлилось: " + matcher.description() }
                    )
                }
            }
        )
    }
    
    static func alwaysTrue() -> ElementSnapshotMatcher {
        return valueMatcher("Всегда истинно") { _, _ in
            .match
        }
    }
    
    static func alwaysFalse() -> ElementSnapshotMatcher {
        return valueMatcher("Всегда ложно") { _, _ in
            MatchingResult.exactMismatch(mismatchDescription: { "Всегда ложно" })
        }
    }
    
    static func accessibilityLabel(_ value: String) -> ElementSnapshotMatcher {
        return valueMatcher("label == \"\(value)\"") { snapshot, mismatchWithActualResult in
            snapshot.label == value
                ? .match
                : mismatchWithActualResult { "\"\(snapshot.label)\"" }
        }
    }
    
    static func accessibilityValue(_ value: String) -> ElementSnapshotMatcher {
        return valueMatcher("value == \"\(value)\"") { snapshot, mismatchWithActualResult in
            snapshot.originalAccessibilityValue == value
                ? .match
                : mismatchWithActualResult { snapshot.originalAccessibilityValue.flatMap { "\"\($0)\"" } ?? "nil" }
        }
    }
    
    static func accessibilityPlaceholderValue(_ value: String) -> ElementSnapshotMatcher {
        return valueMatcher("placeholderValue == \"\(value)\"") { snapshot, mismatchWithActualResult in
            snapshot.placeholderValue == value
                ? .match
                : mismatchWithActualResult { snapshot.placeholderValue.flatMap { "\"\($0)\"" } ?? "nil" }
        }
    }
    
    static func accessibilityId(_ value: String) -> ElementSnapshotMatcher {
        return valueMatcher("id == \"\(value)\"") { snapshot, mismatchWithActualResult in
            if snapshot.identifier == value {
                return .match
            } else {
                return mismatchWithActualResult { "\"\(snapshot.identifier)\"" }
            }
        }
    }
    
    static func visibleText(_ value: String) -> ElementSnapshotMatcher {
        return valueMatcher("Содержит текст \"\(value)\"") { snapshot, mismatchWithActualResult in
            let actualValue = snapshot.visibleText(fallback: snapshot.label)
            
            if snapshot.visibleText(fallback: snapshot.label) == value {
                return .match
            } else {
                return mismatchWithActualResult { actualValue }
            }
        }
    }
    
    static func type(_ elementType: ElementType) -> ElementSnapshotMatcher {
        return valueMatcher("Тип элемента равен \"\(elementType)\"") { snapshot, mismatchWithActualResult in
            if snapshot.elementType == elementType {
                return .match
            } else {
                return mismatchWithActualResult { snapshot.elementType.flatMap { "\($0)" } ?? "any" }
            }
        }
    }
    
    static func isNotDefinitelyHidden() -> ElementSnapshotMatcher {
        return valueMatcher("Не является явно скрытым") { snapshot, mismatchWithActualResult in
            if let enhancedAccessibilityValue = snapshot.enhancedAccessibilityValue {
                if enhancedAccessibilityValue.isDefinitelyHidden {
                    return mismatchWithActualResult { "вьюшка или один из ее родителей скрыты" }
                } else {
                    return .match
                }
            }
            
            return .match
        }
    }
    
    static func isInstanceOf(_ anyClass: AnyClass) -> ElementSnapshotMatcher {
        let className = "\(anyClass)"
        return valueMatcher("Является инстансом класса \(className)") { snapshot, mismatchWithActualResult in
            let uikitClass = snapshot.uikitClass
            let customClass = snapshot.customClass
            
            if className == uikitClass || className == customClass {
                return .match
            } else {
                return mismatchWithActualResult {
                    let alternatives = [uikitClass, customClass].flatMap { $0 }.map { "\"" + $0 + "\"" }
                    
                    switch alternatives.count {
                    case 0:
                        return "неизвестен"
                    case 1:
                        return alternatives[0]
                    default:
                        return alternatives.joined(separator: " или ")
                    }
                }
            }
        }
    }
    
    static func isSubviewOf(_ parentMatcher: ElementSnapshotMatcher) -> ElementSnapshotMatcher {
        return ElementSnapshotMatcher(
            description: { "Является сабвью " + parentMatcher.description() },
            matchingFunction: { snapshot -> MatchingResult in
                var results = [MatchingResult]()
                
                var parentPointer = snapshot.parent
                while let parent = parentPointer {
                    let matchingResult = parentMatcher.matches(snapshot: parent)
                    results.append(matchingResult)
                    
                    if matchingResult.matched {
                        return .match
                    }
                    parentPointer = parent.parent
                }
                
                results.sort(by: { left, right -> Bool in
                    left.percentageOfMatching > right.percentageOfMatching
                })
                
                if let bestMatch = results.first {
                    switch bestMatch {
                    case .match:
                        return .match
                    case .mismatch(let percentageOfMatching, let mismatchDescription):
                        return MatchingResult.partialMismatch(
                            percentageOfMatching: percentageOfMatching,
                            mismatchDescription: {
                                "Является сабвью - нет, лучший кандидат зафейлился " + mismatchDescription()
                            }
                        )
                    }
                } else {
                    return MatchingResult.exactMismatch(
                        mismatchDescription: { "Является сабвью (актуальный результат - не имеет супервью)" }
                    )
                }
            }
        )
    }
    
    private static func valueMatcher(
        _ description: @escaping @autoclosure () -> String,
        matchingFunction: @escaping (
            _ snapshot: ElementSnapshot,
            _ mismatchWithActualResult: @escaping (@escaping () -> String) -> (MatchingResult))
            -> MatchingResult)
        -> ElementSnapshotMatcher
    {
        return ElementSnapshotMatcher(
            description: description,
            matchingFunction: { snapshot in
                matchingFunction(snapshot) { actualResult in
                    MatchingResult.exactMismatch(
                        mismatchDescription: {
                            var result = actualResult()
                            
                            if result.isEmpty {
                                result = "пустая строка"
                            }
                            
                            return description() + " (актуальное значение: " + result + ")"
                        }
                    )
                }
            }
        )
    }
}

private final class ElementSnapshotMatcherDescriptions {
    static func matchDescription(matcherDescription: @escaping @autoclosure () -> String) -> String {
        return "(v) " + matcherDescription()
    }
    
    static func mismatchDescription(matcherDescription: @escaping @autoclosure () -> String) -> String {
        return "(x) " + matcherDescription()
    }
    
    static func fail(matcher: ElementSnapshotMatcher, result: MatchingResult) -> String {
        switch result {
        case .match:
            return matchDescription(matcherDescription: matcher.description())
        case .mismatch(_, let mismatchDescription):
            return self.mismatchDescription(matcherDescription: mismatchDescription())
        }
    }
    
    static func joinedDescriptions(
        prefix: String,
        matchers: [ElementSnapshotMatcher])
        -> () -> String
    {
        return {
            return prefix + " " + joined(strings: matchers.map { $0.description() })
        }
    }
    
    static func joinedFails(
        prefix: String,
        matchers: [ElementSnapshotMatcher],
        results: [MatchingResult])
        -> () -> String
    {
        return {
            return prefix + " " + joined(
                strings: zip(matchers, results).map { matcher, result in
                    fail(matcher: matcher, result: result)
                }
            )
        }
    }
    
    static func joined(strings: [String]) -> String {
        return strings.joined(separator: "\n").mb_wrapAndIndent(
            prefix: "[",
            postfix: "]"
        )
    }
}
