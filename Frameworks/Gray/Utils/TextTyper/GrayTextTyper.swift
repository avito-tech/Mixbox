import MixboxUiTestsFoundation
import MixboxFoundation

public final class GrayTextTyper: TextTyper {
    public func type(instructions: [TextTyperInstruction]) throws {
        try instructions.forEach(type)
    }
    
    private func type(instruction: TextTyperInstruction) throws {
        switch instruction {
        case .text(let text):
            try type(text: text)
        case .key(let key):
            try type(key: key)
        }
    }
    
    private func keyboard() throws -> UIKeyboardImpl {
        guard let keyboard = UIKeyboardImpl.sharedInstance() else {
            throw ErrorString("UIKeyboardImpl.sharedInstance() is nil")
        }
        
        return keyboard
    }
    
    private func type(text: String) throws {
        try keyboard().addInputString(text)
    }
    
    private func type(key: TextTyperKey) throws {
        let keyboard = try self.keyboard()
        
        switch key {
        case .delete:
            keyboard.deleteBackward()
        }
    }
}
