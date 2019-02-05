import Foundation

final class CrashingCellException: NSException {
    init() {
        super.init(
            name: NSExceptionName(rawValue: "CrashingCellException"),
            reason: "CrashingCellException",
            userInfo: nil
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
