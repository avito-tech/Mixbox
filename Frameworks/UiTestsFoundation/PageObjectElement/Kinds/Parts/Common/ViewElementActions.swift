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
            "нажать \"\(info.elementName)\" и удерживать \(duration) секунд"
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
