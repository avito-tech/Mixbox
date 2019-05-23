import XCTest
import CiFoundation
import Di
import Bash

public final class FileDownloaderTests: XCTestCase {
    func test() {
        let di = TeamcityBuildDi()
        try! di.bootstrap()
        let fileDownloader: FileDownloader = try! di.resolve()
        
        let path = try! fileDownloader.download(url: URL(string: "https://example.com")!)
        
        XCTAssert(FileManager.default.fileExists(atPath: path))
        
        try? FileManager.default.removeItem(atPath: path)
    }
}

