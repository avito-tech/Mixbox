import MixboxFoundation
import MixboxIpcCommon

public final class InteractionFailureDebuggerImpl: InteractionFailureDebugger {
    private let synchronousAlertDisplayer: SynchronousAlertDisplayer
    private let synchronousPageObjectElementGenerationWizardRunner: SynchronousPageObjectElementGenerationWizardRunner
    
    public init(
        synchronousAlertDisplayer: SynchronousAlertDisplayer,
        synchronousPageObjectElementGenerationWizardRunner: SynchronousPageObjectElementGenerationWizardRunner)
    {
        self.synchronousAlertDisplayer = synchronousAlertDisplayer
        self.synchronousPageObjectElementGenerationWizardRunner = synchronousPageObjectElementGenerationWizardRunner
    }
    
    public func performDebugging() throws -> InteractionFailureDebuggingResult {
        try displayAlert()
        
        try runPageObjectElementGenerationWizard()
        
        return .failureWasNotFixed
    }
    
    private func displayAlert() throws {
        try synchronousAlertDisplayer.display(
            alert: Alert(
                title: "Error",
                description: "Error"
            )
        )
    }
    
    private func runPageObjectElementGenerationWizard() throws {
        try synchronousPageObjectElementGenerationWizardRunner.run()
    }
}
