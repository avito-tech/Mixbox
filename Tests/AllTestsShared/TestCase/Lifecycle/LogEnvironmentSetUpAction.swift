import MixboxTestsFoundation
import MixboxFoundation
import MixboxUiKit

public final class LogEnvironmentSetUpAction: SetUpAction {
    private let dateProvider: DateProvider
    private let stepLogger: StepLogger
    private let iosVersionProvider: IosVersionProvider
    
    public init(
        dateProvider: DateProvider,
        stepLogger: StepLogger,
        iosVersionProvider: IosVersionProvider)
    {
        self.dateProvider = dateProvider
        self.stepLogger = stepLogger
        self.iosVersionProvider = iosVersionProvider
    }
    
    public func setUp() -> TearDownAction {
        let device = UIDevice.mb_platformType.rawValue
        let os = iosVersionProvider.iosVersion().majorAndMinor
        
        stepLogger.logEntry(
            date: dateProvider.currentDate(),
            title: "Started test with environment",
            attachments: [
                Attachment(
                    name: "Environment",
                    content: .text(
                        """
                        Device: \(device)
                        OS: iOS \(os)
                        """
                    )
                )
            ]
        )
        
        return NoopTearDownAction()
    }
}
