import MixboxIpcCommon

extension BaseUiTestCase {
    func mainScreenBounds() -> CGRect {
        synchronousIpcClient.callOrFail(method: GetUiScreenMainBoundsIpcMethod())
    }
    
    func mainScreenScale() -> CGFloat {
        synchronousIpcClient.callOrFail(method: GetUiScreenMainScaleIpcMethod())
    }
}
