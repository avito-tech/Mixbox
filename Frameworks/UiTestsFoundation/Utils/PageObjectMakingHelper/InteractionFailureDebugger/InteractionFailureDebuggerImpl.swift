import MixboxFoundation
import MixboxIpcCommon

public final class InteractionFailureDebuggerImpl: InteractionFailureDebugger {
    private let alertDisplayer: AlertDisplayer
    private let pageObjectElementGenerationWizardRunner: PageObjectElementGenerationWizardRunner
    
    public init(
        alertDisplayer: AlertDisplayer,
        pageObjectElementGenerationWizardRunner: PageObjectElementGenerationWizardRunner)
    {
        self.alertDisplayer = alertDisplayer
        self.pageObjectElementGenerationWizardRunner = pageObjectElementGenerationWizardRunner
    }
    
    public func performDebugging() throws -> InteractionFailureDebuggingResult {
        try displayAlert()
        
        try runPageObjectElementGenerationWizard()
        
        return .failureWasNotFixed
    }
    
    private func displayAlert() throws {
        try alertDisplayer.display(
            alert: Alert(
                title: "Error",
                description: "Error"
            )
        )
    }
    
    private func runPageObjectElementGenerationWizard() throws {
        try pageObjectElementGenerationWizardRunner.run()
    }
}
