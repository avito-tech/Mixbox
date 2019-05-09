import MixboxTestsFoundation

final class CurrentApplicationCurrentSimulatorFileSystemRootProviderTests: TestCase {
    func test() {
        let provider = CurrentApplicationCurrentSimulatorFileSystemRootProvider()
        
        do {
            let current = try provider.currentSimulatorFileSystemRoot()
            
            XCTAssert(
                FileManager.default.fileExists(atPath: current.osxPath("")),
                "Current SimulatorFileSystemRoot does not exists on OSX file system"
            )
        } catch {
            XCTFail("Failed to get current simulator root: \(error)")
            return
        }
    }
}
