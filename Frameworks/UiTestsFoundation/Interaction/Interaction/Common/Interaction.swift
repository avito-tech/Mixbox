// Used to save and perform later something for
// element with matcher.
//
// It is a "command" pattern
public protocol Interaction: class {
    var description: InteractionDescription { get }
    
    func perform() -> InteractionResult
}
