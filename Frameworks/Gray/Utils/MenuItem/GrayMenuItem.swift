import MixboxUiTestsFoundation
import MixboxFoundation

final class GrayMenuItem: MenuItem, CustomStringConvertible {
    private let possibleTitles: [String]
    private let elementFinder: ElementFinder
    private let elementMatcherBuilder: ElementMatcherBuilder
    private let elementSimpleGesturesProvider: ElementSimpleGesturesProvider
    private let runLoopSpinnerFactory: RunLoopSpinnerFactory
    
    init(
        possibleTitles: [String],
        elementFinder: ElementFinder,
        elementMatcherBuilder: ElementMatcherBuilder,
        elementSimpleGesturesProvider: ElementSimpleGesturesProvider,
        runLoopSpinnerFactory: RunLoopSpinnerFactory)
    {
        self.possibleTitles = possibleTitles
        self.elementFinder = elementFinder
        self.elementMatcherBuilder = elementMatcherBuilder
        self.elementSimpleGesturesProvider = elementSimpleGesturesProvider
        self.runLoopSpinnerFactory = runLoopSpinnerFactory
    }
    
    // MARK: - MenuItem
    
    func tap() throws {
        let elementSnapshot = try resolveSnapshot()
        
        let elementSimpleGestures = try elementSimpleGesturesProvider.elementSimpleGestures(
            elementSnapshot: elementSnapshot,
            interactionCoordinates: InteractionCoordinatesImpl.center
        )
        
        try elementSimpleGestures.tap()
    }
    
    func waitForExistence(timeout: TimeInterval) throws {
        var errorToThrow: Error?
        
        if timeout > 0 {
            let metCondition = runLoopSpinnerFactory.spinner(timeout: timeout).spinUntil { [weak self] in
                guard let strongSelf = self else {
                    errorToThrow = ErrorString("self is nil in GrayMenuItem")
                    
                    return true // stop
                }
                
                do {
                    _ = try strongSelf.resolveSnapshot()
                    
                    return true // stop
                } catch let error {
                    errorToThrow = error
                    
                    return false // continue
                }
            }
            
            if let error = errorToThrow {
                throw error
            } else if !metCondition {
                throw ErrorString("Failed to wait for existence of element - never met condition or get meaningful info about what happened")
            }
        } else {
            _ = try resolveSnapshot()
        }
    }
    
    private func resolveSnapshot() throws -> ElementSnapshot {
        let element = elementMatcherBuilder
        
        let query = elementFinder.query(
            elementMatcher: element.type == .button && possibleTitles.reduce(AlwaysFalseMatcher()) { result, title in
                result || element.label == title
            }
        )
        
        let resolvedQuery = query.resolveElement(interactionMode: .useUniqueElement)
        let matchingSnapshots = resolvedQuery.matchingSnapshots
        
        guard let first = matchingSnapshots.first else {
            throw ErrorString("Couldn't find \(description)")
        }
        
        guard matchingSnapshots.count == 1 else {
            throw ErrorString("Found multiple matches of \(description)")
        }
        
        return first
    }
    
    // MARK: - CustomStringConvertible
    
    var description: String {
        let titlesDescription = possibleMenuTitlesDescription()
        return "button with one of the possible titles: \(titlesDescription)"
    }
    
    private func possibleMenuTitlesDescription() -> String {
        return possibleTitles
            .map { "\"\($0)\"" }
            .joined(separator: " or ")
    }
}
