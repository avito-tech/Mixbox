import UIKit

final class CrashTestsView: TestStackScrollView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        accessibilityIdentifier = "view"
        
        addButton(idAndText: "kill_9") {
            $0.onTap = {
                kill(ProcessInfo.processInfo.processIdentifier, 9)
            }
        }
        
        addButton(idAndText: "exception") {
            $0.onTap = {
                NSException(name: NSExceptionName(rawValue: "name"), reason: "reason", userInfo: ["key": "value"]).raise()
            }
        }
        
        addButton(idAndText: "div_0") {
            $0.onTap = {
                let iLoveDivisionByZeroWarning = arc4random() % 1
                print(1 / iLoveDivisionByZeroWarning)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
