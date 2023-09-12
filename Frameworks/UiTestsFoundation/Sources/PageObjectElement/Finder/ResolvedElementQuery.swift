import MixboxTestsFoundation

public final class ResolvedElementQuery {
    public var matchingSnapshots: [ElementSnapshot] {
        return elementQueryResolvingState.matchingSnapshots
    }
    
    // Was private before usage in logs. But there is not excuse for that.
    public var knownSnapshots: [ElementSnapshot] {
        return elementQueryResolvingState.elementSnapshots
    }
    
    private let elementQueryResolvingState: ElementQueryResolvingState
    
    public init(
        elementQueryResolvingState: ElementQueryResolvingState)
    {
        self.elementQueryResolvingState = elementQueryResolvingState
    }
    
    public func candidatesDescription() -> CandidatesDescription? {
        guard !elementQueryResolvingState.matchingResults.isEmpty else {
            return nil
        }
        
        let sortedResults = elementQueryResolvingState.matchingResults.enumerated().sorted { left, right -> Bool in
            // from more matching to less matching
            left.element.percentageOfMatching > right.element.percentageOfMatching
        }
        
        var attachments = [Attachment]()
        
        var lines = [String]()
        for (index, result) in sortedResults {
            let snapshot = elementQueryResolvingState.elementSnapshots[index]
            
            switch result {
            case .match:
                lines.append("Snapshot \(index), full match:")
                let snapshotDescription = snapshot.debugDescription
                lines.append(snapshotDescription.mb_indent(includingFirstLine: true))
            case .mismatch(let mismatchResult):
                let idSuffix = snapshot.uniqueIdentifier.valueIfAvailable.map { " (uid: \($0)" }
                    ?? (snapshot.accessibilityIdentifier.isEmpty ? "" : " (id: \(snapshot.accessibilityIdentifier)" )
                lines.append("Snapshot \(index), percentage of matching \(mismatchResult.percentageOfMatching):\(idSuffix)")
                lines.append(mismatchResult.mismatchDescription)
                
                let resultAttachments = mismatchResult.attachments
                
                if !resultAttachments.isEmpty {
                    attachments.append(
                        Attachment(
                            name: "Snapshot \(index) mismatch attachments",
                            content: .attachments(mismatchResult.attachments)
                        )
                    )
                }
            }
        }
        
        return CandidatesDescription(
            description: lines.joined(separator: "\n"),
            attachments: attachments
        )
    }
}
