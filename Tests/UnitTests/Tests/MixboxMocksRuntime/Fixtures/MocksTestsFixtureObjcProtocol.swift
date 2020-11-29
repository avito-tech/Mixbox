import Foundation

@objc
protocol MocksTestsFixtureObjcProtocol {
    @objc
    func objcFunctionWithObjcAttribute()
    
    func objcFunctionWithoutObjcAttribute()
    
    var gettable: Int { get }
    
    var settable: Int { get set }
}
