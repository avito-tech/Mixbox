import Foundation

@objc
protocol ObjcProtocolToMock {
    @objc
    func objcFunctionWithObjcAttribute()
    
    func objcFunctionWithoutObjcAttribute()
    
    var gettable: Int { get }
    
    var settable: Int { get set }
}
