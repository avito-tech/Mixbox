// Execute things once.
// Possible extension: generic return type (I didn't find advantages of it over lazy yet).
// E.g.:
//
//  let onceToken: OnceToken<Int>
//  ...
//  return onceToken.executeOnce { 2 + 2 } // 4
//
public protocol OnceToken {
    func wasExecuted() -> Bool
    func executeOnce(_ closure: () throws -> ()) rethrows
}
