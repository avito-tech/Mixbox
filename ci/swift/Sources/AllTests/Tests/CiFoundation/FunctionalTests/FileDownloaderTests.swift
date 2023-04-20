import XCTest
import CiFoundation
import Bash
import RemoteFiles
import TeamcityDi
import DI

public final class FileDownloaderTests: XCTestCase {
    func test() {
        do {
            let di = DiMaker<TeamcityBuildDependencies>.makeDi()
            
            let fileDownloader: FileDownloader = try di.resolve()
            
            guard let url = URL(string: "https://example.com") else {
                throw ErrorString("Couldn't make url")
            }
            
            let path = try fileDownloader.download(url: url)
            
            XCTAssert(FileManager.default.fileExists(atPath: path))
            
            try? FileManager.default.removeItem(atPath: path)
        } catch {
            XCTFail("\(error)")
        }
    }
}
