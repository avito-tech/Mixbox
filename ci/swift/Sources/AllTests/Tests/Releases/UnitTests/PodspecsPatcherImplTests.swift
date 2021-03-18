import Bash
import Git
import XCTest
import Releases
import CiFoundation

final class PodspecsPatcherImplTests: XCTestCase {
    func test() {
        let temporaryFileProvider = TemporaryFileProviderImpl()
        let repoRootPath = temporaryFileProvider.temporaryFilePath()
        let cocoapodsDirectoryPath = repoRootPath.appending(pathComponent: "cocoapods")
        let fileManager = FileManager()
        
        assertDoesntThrow {
            try fileManager.createDirectory(
                atPath: cocoapodsDirectoryPath,
                withIntermediateDirectories: true
            )
        }
            
        let patcher = PodspecsPatcherImpl(
            repoRootProvider: RepoRootProviderMock(
                repoRootPath: repoRootPath
            )
        )
        
        assertDoesntThrow {
            try patcher.setMixboxPodspecsSource(
                "<source>"
            )
        }
        
        assertDoesntThrow {
            let contents = try String(
                contentsOfFile: repoRootPath.appending(
                    pathComponents: ["cocoapods", "mixbox_podspecs_source.rb"]
                )
            )
            
            XCTAssertEqual(
                contents,
                "$mixbox_podspecs_source = '<source>'"
            )
        }
        
        assertDoesntThrow {
            try fileManager.removeItem(atPath: cocoapodsDirectoryPath)
        }
    }
}
