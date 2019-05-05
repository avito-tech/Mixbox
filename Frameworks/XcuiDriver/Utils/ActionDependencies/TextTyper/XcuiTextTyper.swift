import MixboxUiTestsFoundation
import XCTest

public final class XcuiTextTyper: TextTyper {
    private let applicationProvider: ApplicationProvider
    
    public init(applicationProvider: ApplicationProvider) {
        self.applicationProvider = applicationProvider
    }
    
    public func type(instructions: [TextTyperInstruction]) throws {
        let textToType = instructions
            .map(string)
            .joined()
        
        applicationProvider.application.typeText(textToType)
    }
    
    private func string(instruction: TextTyperInstruction) -> String {
        switch instruction {
        case .key(let key):
            return string(key: key)
        case .text(let text):
            return text
        }
    }
    
    private func string(key: TextTyperKey) -> String {
        switch key {
        case .delete:
            return XCUIKeyboardKey.delete.rawValue
        }
    }
}
