import Foundation

protocol MixboxGeneratorIntegrationTestsFixtureBaseProtocolFromSameFile {
    var _mixboxGeneratorIntegrationTestsFixtureBaseProtocolFromSameFileProperty: Int { get }
    func mixboxGeneratorIntegrationTestsFixtureBaseProtocolFromSameFileFunction()
}

// swiftlint:disable syntactic_sugar implicitly_unwrapped_optional
protocol MixboxGeneratorIntegrationTestsFixtureProtocol:
    MixboxGeneratorIntegrationTestsFixtureBaseProtocolFromSameFile,
    MixboxGeneratorIntegrationTestsFixtureBaseProtocolFromOtherFile
{
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
    
    // Closures: Non-escaping
    
    func function(closure: () -> ())
    func function(autoclosure: @autoclosure () -> Int)
    
    // Closures: Escaping
    
    func function(escapingClosure: @escaping () -> ())
    func function(escapingAutoclosure: @escaping @autoclosure () -> Int)
    func function(escapingClosureWithTypealias: @escaping Completion)
    func function(escapingClosureWithGenericTypealias: @escaping GenericClosureHolder<Int, Int>.Closure)
    
    // Closures: Not really
    
    func function(closureLikeArgumentOfImplicitlyUnwrappedOptionalType: (() -> ())!)
    func function(closureLikeArgumentOfOptionalType: (() -> ())?)
    func function(closureLikeArgumentOfArrayType: [() -> ()])
    func function(closureLikeArgumentOfDictionaryType: [Int: () -> ()])
    
    // Closures: Other
    
    func function(
        closureWithPoorlyWrittenAttributes: @escaping(Int?) -> ())
    
    // Function attributes
    
    @inlinable
    func inlinableFunction()
    
    @available(iOS 10.0, *)
    func availableSince10Function()
    
    @available(iOS 999.0, *)
    func availableSince999Function()
    
    // Propertes
    
    var gettable: Int { get }
    var settable: Int { get set }
    
    var gettableClosure: () -> () { get }
    var gettableOptional: Int? { get }
    var gettableArray: [Int?]? { get }
}
