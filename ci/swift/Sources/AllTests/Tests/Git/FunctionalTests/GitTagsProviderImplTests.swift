import Bash
import Git
import XCTest
import TeamcityDi
import DI

public final class GitTagsProviderImplTests: XCTestCase {
    func test() {
        assertDoesntThrow {
            let di = DiMaker<TeamcityBuildDependencies>.makeDi()
            
            let gitTagsProvider: GitTagsProvider = try di.resolve()
            
            let gitTags = try gitTagsProvider.gitTags()
            
            let knownTag = try gitTags.first { tag in
                tag.name == "0.2.5"
            }.unwrapOrThrow()
            
            XCTAssertEqual(
                knownTag.sha,
                "82d3bf3992cfb889c1f9f9812a09d8c33e7687d7"
            )
        }
    }
}
