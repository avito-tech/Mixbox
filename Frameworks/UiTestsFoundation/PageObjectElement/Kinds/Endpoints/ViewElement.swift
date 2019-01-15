import MixboxTestsFoundation

public final class ViewElement:
    BaseElementWithDefaultInitializer,
    ViewElementActions,
    ViewElementChecks,
    ViewElementUtils
{
    public var assert: ViewElementChecks & Element {
        return ViewElement(implementation: implementation.withAssertsInsteadOfChecks())
    }
}

public enum SwipeDirection {
    case up
    case down
    case left
    case right
}

// Use this in tests (without file & line):

public protocol ViewElementActions: class {}
public extension ViewElementActions where Self: Element {
    func tap(
        normalizedCoordinate: CGPoint? = nil,
        absoluteOffset: CGVector? = nil,
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
    {
        let actionSettings = ActionSettings(file: file, line: line, description: description) { info in
            "тапнуть по \"\(info.elementName)\""
        }
        
        implementation.actions.tap(
            normalizedCoordinate: normalizedCoordinate,
            absoluteOffset: absoluteOffset,
            actionSettings: actionSettings
        )
    }
    
    func press(
        duration: Double = 0.5,
        normalizedCoordinate: CGPoint? = nil,
        absoluteOffset: CGVector? = nil,
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
    {
        let actionSettings = ActionSettings(file: file, line: line, description: description) { info in
            "тапнуть по \"\(info.elementName)\""
        }
        
        implementation.actions.press(
            duration: duration,
            normalizedCoordinate: normalizedCoordinate,
            absoluteOffset: absoluteOffset,
            actionSettings: actionSettings
        )
    }
    
    func swipeToDirection(
        _ direction: SwipeDirection,
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
    {
        let actionSettings = ActionSettings(file: file, line: line, description: description) { info in
            switch direction {
            case .up:
                return "в \(info.elementName) свайп вверх"
            case .down:
                return "в \(info.elementName) свайп вниз"
            case .left:
                return "в \(info.elementName) свайп влево"
            case .right:
                return "в \(info.elementName) свайп вправо"
            }
        }
        
        implementation.actions.swipe(
            direction: direction,
            actionSettings: actionSettings
        )
    }
    
    func swipeUp(
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
    {
        swipeToDirection(
            .up,
            file: file,
            line: line,
            description: description
        )
    }
    
    func swipeDown(
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
    {
        swipeToDirection(
            .down,
            file: file,
            line: line,
            description: description
        )
    }
    
    func swipeLeft(
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
    {
        swipeToDirection(
            .left,
            file: file,
            line: line,
            description: description
        )
    }
    
    func swipeRight(
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
    {
        swipeToDirection(
            .right,
            file: file,
            line: line,
            description: description
        )
    }
}

public protocol ViewElementChecks: class {}
public extension ViewElementChecks where Self: Element {
    @discardableResult
    func isDisplayed(
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
        -> Bool
    {
        let checkSettings = CheckSettings(file: file, line: line, description: description) { info in
            "отображается \"\(info.elementName)\""
        }
        
        return implementation.checks.isDisplayed(checkSettings: checkSettings)
    }
    
    @discardableResult
    func isNotDisplayed(
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
        -> Bool
    {
        let checkSettings = CheckSettings(file: file, line: line, description: description) { info in
            "не отображается \"\(info.elementName)\""
        }
        
        return implementation.checks.isNotDisplayed(checkSettings: checkSettings)
    }
    
    @discardableResult
    func isInHierarchy(
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
        -> Bool
    {
        let checkSettings = CheckSettings(file: file, line: line, description: description) { info in
            "\"\(info.elementName)\" присутствует в иерархии"
        }
        
        return implementation.checks.isInHierarchy(checkSettings: checkSettings)
    }
    
    @discardableResult
    func becomesTallerAfter(
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil,
        action: @escaping () -> ())
        -> Bool 
    {
        let checkSettings = CheckSettings(file: file, line: line, description: description) { info in
            "увеличился \"\(info.elementName)\""
        }
        
        return implementation.checks.becomesTallerAfter(action: action, checkSettings: checkSettings)
    }

    @discardableResult
    func becomesShorterAfter(
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil,
        action: @escaping () -> ()) 
        -> Bool
    {
        let checkSettings = CheckSettings(file: file, line: line, description: description) { info in
            "уменьшился \"\(info.elementName)\""
        }

        return implementation.checks.becomesShorterAfter(action: action, checkSettings: checkSettings)
    }
    
    @discardableResult
    func hasValue(
        _ value: String,
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
        -> Bool
    {
        let checkSettings = CheckSettings(file: file, line: line, description: description) { info in
            "в \"\(info.elementName)\" accessibility value = \(value)"
        }
        
        return implementation.checks.hasValue(value, checkSettings: checkSettings)
    }
    
    @discardableResult
    func hasHostDefinedValue(
        forKey key: String,
        referenceValue: String,
        comparator: HostDefinedValueComparator,
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
        -> Bool
    {
        let checkSettings = CheckSettings(file: file, line: line, description: description) { info in
            "в \"\(info.elementName)\"[\(key)] совпадает с референсным \(referenceValue)"
        }
        
        return implementation.checks.hasHostDefinedValue(
            forKey: key,
            referenceValue: referenceValue,
            checkSettings: checkSettings,
            comparator: comparator
        )
    }
    
    @discardableResult
    func matchesReference(
        snapshot: String,
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
        -> Bool
    {
        let checkSettings = CheckSettings(file: file, line: line, description: description) { info in
            "снапшот \"\(info.elementName)\""
        }
        
        return implementation.checks.matchesReference(
            snapshot: snapshot,
            checkSettings: checkSettings
        )
    }
    
    @discardableResult
    func matchesReference(
        image: UIImage,
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
        -> Bool
    {
        let checkSettings = CheckSettings(file: file, line: line, description: description) { info in
            "снапшот \"\(info.elementName)\""
        }
        
        return implementation.checks.matchesReference(
            image: image,
            checkSettings: checkSettings
        )
    }
    
    @discardableResult
    func matches(
        minimalPercentageOfVisibleArea: CGFloat = 0.2,
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil,
        matcher: @escaping (ElementMatcherBuilder) -> ElementMatcher)
        -> Bool
    {
        let checkSettings = CheckSettings(file: file, line: line, description: description) { info in
            "в '\(info.elementName)' \(ElementMatcherBuilder.build(matcher).description)"
        }
        
        return implementation.checks.matches(
            checkSettings: checkSettings,
            minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea,
            matcher: matcher
        )
    }
}

public protocol ViewElementUtils: class { }
public extension ViewElementUtils where Self: Element {
    func takeSnapshot(
        file: StaticString = #file,
        line: UInt = #line,
        description: HumanReadableInteractionDescriptionBuilder? = nil)
        -> UIImage?
    {
        let utilsSettings = UtilsSettings(file: file, line: line, description: description) { info in
            "снапшот \"\(info.elementName)\""
        }
    
        return implementation.utils.takeSnapshot(utilsSettings: utilsSettings)
    }
}
