import Foundation

final class TestCanNotBeContinuedException: NSException {
    init() {
        super.init(
            name: NSExceptionName(rawValue: "TestCanNotBeContinuedException"),
            reason: "TestCanNotBeContinuedException",
            userInfo: [:]
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
