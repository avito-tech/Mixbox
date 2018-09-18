import XCTest
import MixboxTestsFoundation

class SimulatorFileSystemRootTests: XCTestCase {
    func test_osxPath_returnsPath_ifFileExists() {
        let root = NSTemporaryDirectory()
        
        givenFilesInSimulatorRootDirectory(root) {
            dir("data") {
                dir("dbs") {
                    file("some.db")
                }
            }
        }
        
        XCTAssertEqual(
            SimulatorFileSystemRoot(osxRoot: root).osxPath("data/dbs/some.db"),
            root.mb_appendingPathComponent("data/dbs/some.db")
        )
    }
    
    func test_osxPath_returnsPath_ifFileDoesntExist() {
        let root = NSTemporaryDirectory()
        
        givenFilesInSimulatorRootDirectory(root) {
            // nothing
        }
        
        XCTAssertEqual(
            SimulatorFileSystemRoot(osxRoot: root).osxPath("this-path-does-not-exist"),
            root.mb_appendingPathComponent("this-path-does-not-exist")
        )
    }
    
    func test_current_works() {
        guard let current = SimulatorFileSystemRoot.current else {
            XCTFail("Can not get current simulator root")
            return
        }
        XCTAssert(
            FileManager.default.fileExists(atPath: current.osxPath("")),
            "Current SimulatorFileSystemRoot does not exists on OSX file system"
        )
    }
    
    // Making stubs
    
    private var currentDirectory = ""
    
    private func givenFilesInSimulatorRootDirectory(_ root: String, _ closure: () -> ()) {
        currentDirectory = root
        
        closure()
    }
    
    private func dir(_ name: String, _ closure: () -> () = {}) {
        let initialCurrentDir = currentDirectory
        
        currentDirectory = currentDirectory.mb_appendingPathComponent(name)
        do {
            try FileManager.default.createDirectory(atPath: currentDirectory, withIntermediateDirectories: true, attributes: [:])
        } catch let e {
            XCTFail("Caught \(e)")
        }
        closure()
        currentDirectory = initialCurrentDir
    }
    
    private func file(_ name: String) {
        let path = currentDirectory.mb_appendingPathComponent(name)
        FileManager.default.createFile(atPath: path, contents: nil, attributes: [:])
    }
}
