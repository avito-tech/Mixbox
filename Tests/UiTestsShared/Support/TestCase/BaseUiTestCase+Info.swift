import MixboxIpcCommon

extension BaseUiTestCase {
    func mainScreenBounds() -> CGRect {
        synchronousIpcClient.callOrFail(method: GetUiScreenMainBoundsIpcMethod())
    }
}
