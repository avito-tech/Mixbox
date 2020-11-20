import Foundation

// swiftlint:disable syntactic_sugar
protocol ProtocolToMock {
    // Number of arguments
    func function()
    func function(argument0: Int, argument1: Int)
    
    // Labels
    func function(_ noLabel: Int)
    func function(label: Int)
    
    // Throwing
    func throwingFunction() throws
    
    // Return value
    func function() -> Int
    func function() -> Int?
    func function() -> Int??
    func function() -> [Int]
    func function() -> [Int: Int]
    func function() -> () -> ()
    
    // Argument types
    func function(optional: Int?)
    func function(doubleOptional: Int??)
    func function(otherWayOfSpecifyingOptionality: Optional<Int>)
    
    // Closures
    
    // TODO: Fix non-escaping closures
    // func function(closure: () -> ())
    // func function(autoclosure: @autoclosure () -> Int)
    
    func function(escapingClosure: @escaping () -> ())
    
    func function(escapingAutoclosure: @escaping @autoclosure () -> Int)
    
    // Function attributes
    
    @inlinable
    func inlinableFunction()
    
    @available(iOS 10.0, *)
    func availableSince10Function()
    
    @available(iOS 999.0, *)
    func availableSince999Function()
}
