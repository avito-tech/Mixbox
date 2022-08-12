import Bash
import Git
import XCTest
import Releases
import TeamcityDi

// swiftlint:disable multiline_arguments multiline_parameters

final class NextReleaseVersionProviderImplTests: XCTestCase {
    // Integration test without mocks
    func test___nextReleaseVersion___doesnt_throw() {
        assertDoesntThrow {
            let di = TeamcityBuildDi()
            try di.bootstrap(overrides: { _ in })
            let nextReleaseVersionProvider: NextReleaseVersionProvider = try di.resolve()
            let headCommitHashProvider: HeadCommitHashProvider = try di.resolve()
            let settings: MixboxReleaseSettingsProvider = try di.resolve()
            
            do {
                let version = try nextReleaseVersionProvider.nextReleaseVersion(
                    majorVersion: settings.majorVersion,
                    minorVersion: settings.minorVersion,
                    commitHashToRelease: try headCommitHashProvider.headCommitHash(),
                    // doesn't work otherwise, e.g. if "master" is used then it will be always behind
                    // head on pull requests, tests will not work with "master" or "origin/master", so we use "HEAD".
                    releaseBranchName: "HEAD"
                )
                
                // Patch version is ignored here, the code of its calculation is checked in other tests.
                // Major & minor version are always as in MixboxReleaseSettingsProviderImpl.
                XCTAssertEqual(version.major, settings.majorVersion)
                XCTAssertEqual(version.minor, settings.minorVersion)
            } catch {
                // Other possible correct outcome is this:
                XCTAssert(
                    "\(error)".starts(with: "This commit hash is already released: ")
                )
            }
        }
    }
    
    func test___nextReleaseVersion___increments_version_by_N___for_N_commits_since_release() {
        check(
            tags: [
                GitTag(name: "0.0.1", sha: "B")
            ],
            revisions: [
                "C",
                "B",
                "A"
            ],
            nextVersion: 0, 0,
            expectedVersion: 0, 0, 2
        )
        
        check(
            tags: [
                GitTag(name: "0.0.1", sha: "B")
            ],
            revisions: [
                "D",
                "C",
                "B",
                "A"
            ],
            nextVersion: 0, 0,
            expectedVersion: 0, 0, 3
        )
    }
    
    func test___nextReleaseVersion___resets_patch_version___if_minor_or_major_version_are_changed_by_1() {
        check(
            tags: [
                GitTag(name: "0.0.1", sha: "A")
            ],
            revisions: [
                "B",
                "A"
            ],
            nextVersion: 0, 1,
            expectedVersion: 0, 1, 0
        )
        
        check(
            tags: [
                GitTag(name: "0.0.1", sha: "A")
            ],
            revisions: [
                "B",
                "A"
            ],
            nextVersion: 1, 0,
            expectedVersion: 1, 0, 0
        )
    }
    
    func test___nextReleaseVersion___throws_error___if_there_are_two_version_for_a_single_commit() {
        check(
            tags: [
                GitTag(name: "0.0.1", sha: "B"),
                GitTag(name: "0.0.2", sha: "B")
            ],
            revisions: [
                "C",
                "B",
                "A"
            ],
            nextVersion: 0, 0,
            expectedError: "Unexpected case: multiple released versions for same commit hash B"
        )
    }
    
    func test___nextReleaseVersion___throws_error___if_some_major_or_minor_version_is_skipped() {
        // Here versions 0.1 are skipped (jump from 0.0.1 to 1.1.0)
        check(
            tags: [
                GitTag(name: "0.0.1", sha: "B")
            ],
            revisions: [
                "C",
                "B",
                "A"
            ],
            nextVersion: 1, 1,
            expectedError: "Unexpected version increment. Seems like you jump several minor or major versions at once. Example: jumping from 2.0.0 to 4.0.0 is unexpected (to 3.0.0 is expected). Example: jumping from 2.1.0 to 3.1.0 is unexpected (to 3.0.0 is expected)."
        )
    }
    
    func test___nextReleaseVersion___throws_error___if_commit_is_already_released() {
        for majorVersion in [0, 1] {
            check(
                tags: [
                    GitTag(name: "0.0.3", sha: "C"), // this is commit to release, and it is already released
                    GitTag(name: "0.0.2", sha: "B"),
                    GitTag(name: "0.0.1", sha: "A")
                ],
                revisions: [
                    "C",
                    "B",
                    "A"
                ],
                nextVersion: majorVersion, 0,
                expectedError: "This commit hash is already released: C (0.0.3)."
            )
        }
    }
    
    private func check(
        tags: [GitTag],
        revisions: [String],
        nextVersion nextMajorVersion: Int, _ nextMinorVersion: Int,
        expectedVersion expectedMajorVersion: Int, _ expectedMinorVersion: Int, _ expectedPatchVersion: Int)
    {
        assertDoesntThrow {
            let nextReleaseVersion = try self.nextReleaseVersion(
                tags: tags,
                revisions: revisions,
                nextMajorVersion: nextMajorVersion,
                nextMinorVersion: nextMinorVersion
            )
            
            XCTAssertEqual(nextReleaseVersion.major, expectedMajorVersion)
            XCTAssertEqual(nextReleaseVersion.minor, expectedMinorVersion)
            XCTAssertEqual(nextReleaseVersion.patch, expectedPatchVersion)
        }
    }
    
    private func check(
        tags: [GitTag],
        revisions: [String],
        nextVersion nextMajorVersion: Int, _ nextMinorVersion: Int,
        expectedError: String)
    {
        do {
            _ = try self.nextReleaseVersion(
                tags: tags,
                revisions: revisions,
                nextMajorVersion: nextMajorVersion,
                nextMinorVersion: nextMinorVersion
            )
        } catch {
            XCTAssertEqual(
                "\(error)",
                expectedError
            )
        }
    }
    
    private func nextReleaseVersion(
        tags: [GitTag],
        revisions: [String],
        nextMajorVersion: Int,
        nextMinorVersion: Int)
        throws
        -> Version
    {
        let headCommitHash = try revisions.first.unwrapOrThrow()
        
        let nextReleaseVersionProvider = NextReleaseVersionProviderImpl(
            repositoryVersioningInfoProvider: RepositoryVersioningInfoProviderImpl(
                gitTagsProvider: GitTagsProviderMock(
                    gitTags: tags
                ),
                gitRevListProvider: GitRevListProviderMock(
                    revList: revisions
                ),
                headCommitHashProvider: HeadCommitHashProviderMock(
                    headCommitHash: headCommitHash
                )
            )
        )
        
        return try nextReleaseVersionProvider.nextReleaseVersion(
            majorVersion: nextMajorVersion,
            minorVersion: nextMinorVersion,
            commitHashToRelease: headCommitHash,
            releaseBranchName: "doesn't matter"
        )
    }
}
