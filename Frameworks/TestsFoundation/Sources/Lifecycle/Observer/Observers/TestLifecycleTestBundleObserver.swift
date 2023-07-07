import Foundation

public protocol TestLifecycleTestBundleObserver {
    func onStart(testBundle: Bundle)
    func onStop(testBundle: Bundle)
}
