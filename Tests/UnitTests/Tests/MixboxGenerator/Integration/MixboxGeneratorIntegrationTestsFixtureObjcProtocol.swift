import Foundation

@objc
protocol MixboxGeneratorIntegrationTestsFixtureObjcProtocol {
    @objc
    func objcFunctionWithObjcAttribute()
    
    func objcFunctionWithoutObjcAttribute()
    
    var gettable: Int { get }
    
    var settable: Int { get set }
}
