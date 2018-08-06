final class ResolvedElementQuery {
    let xcuiElement: XCUIElement

    var matchingSnapshots: [ElementSnapshot] {
        return elementQueryResolvingState.matchingSnapshots
    }
    
    // Was private before usage in logs. But there is not excuse for that.
    var knownSnapshots: [ElementSnapshot] {
        return elementQueryResolvingState.elementSnapshots
    }
    
    private let elementQueryResolvingState: ElementQueryResolvingState
    
    init(
        elementQueryResolvingState: ElementQueryResolvingState,
        xcuiElement: XCUIElement)
    {
        self.elementQueryResolvingState = elementQueryResolvingState
        self.xcuiElement = xcuiElement
    }
    
    func candidatesDescription() -> String? {
        guard !elementQueryResolvingState.matchingResults.isEmpty else {
            return nil
        }
        
        let sortedResults = elementQueryResolvingState.matchingResults.enumerated().sorted { left, right -> Bool in
            left.element.percentageOfMatching > right.element.percentageOfMatching // по убыванию соответствия
        }
        
        var lines = [String]()
        for (index, result) in sortedResults {
            switch result {
            case .match:
                lines.append("Снепшот \(index), полное соответствие:")
                let snapshotDescription = elementQueryResolvingState.elementSnapshots[index].debugDescription
                lines.append(snapshotDescription.mb_indent("    "))
            case .mismatch(let percentage, let description):
                lines.append("Снепшот \(index), соответствие \(percentage):")
                lines.append(description())
            }
        }
        return lines.joined(separator: "\n")
    }
}
