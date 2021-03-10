import Bash
import Git
import XCTest
import ReleaseToCocoapodsTask
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
            try patcher.setMixboxFrameworkPodspecsVersion(
                Version(major: 1, minor: 2, patch: 3)
            )
        }
        
        assertDoesntThrow {
            let contents = try String(
                contentsOfFile: repoRootPath.appending(
                    pathComponents: ["cocoapods", "mixbox_version.rb"]
                )
            )
            
            XCTAssertEqual(
                contents,
                "$mixbox_version = '1.2.3'"
            )
        }
        
        assertDoesntThrow {
            try fileManager.removeItem(atPath: cocoapodsDirectoryPath)
        }
    }
}
