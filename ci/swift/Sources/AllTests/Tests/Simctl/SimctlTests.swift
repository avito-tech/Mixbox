import XCTest
import Simctl
import Bash
import CiFoundation

final class SimctlTests: XCTestCase {
    private let bashExecutor = BashExecutorMock(
        bashResult: BashResult(
            processResult: ProcessResult(
                code: 0,
                stdout: PlainProcessOutput(data: Data()),
                stderr: PlainProcessOutput(data: Data())
            )
        )
    )
    
    func test___list___works_for_xcode_10_1_0() {
        XCTAssertNoThrow(try {
            let list = try simctl("list_xc_10_1_0.json").list()
            
            // devicetypes
            
            XCTAssertEqual(
                list.devicetypes.first?.name,
                "iPhone 4s"
            )
            XCTAssertEqual(
                list.devicetypes.first?.bundlePath,
                "/Applications/Xcode_10_1.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/CoreSimulator/Profiles/DeviceTypes/iPhone 4s.simdevicetype"
            )
            XCTAssertEqual(
                list.devicetypes.first?.identifier,
                "com.apple.CoreSimulator.SimDeviceType.iPhone-4s"
            )
            
            // runtimes
            
            XCTAssertEqual(
                list.runtimes.first?.bundlePath,
                "/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS 9.3.simruntime"
            )
            XCTAssertEqual(
                list.runtimes.first?.availabilityError,
                ""
            )
            XCTAssertEqual(
                list.runtimes.first?.buildversion,
                "13E233"
            )
            XCTAssertEqual(
                list.runtimes.first?.availability,
                "(available)"
            )
            XCTAssertEqual(
                list.runtimes.first?.isAvailable,
                true
            )
            XCTAssertEqual(
                list.runtimes.first?.identifier,
                "com.apple.CoreSimulator.SimRuntime.iOS-9-3"
            )
            XCTAssertEqual(
                list.runtimes.first?.version,
                "9.3"
            )
            XCTAssertEqual(
                list.runtimes.first?.name,
                "iOS 9.3"
            )
            
            XCTAssertEqual(
                bashExecutor.executedCommands,
                [
                    """
                    xcrun simctl list -j > "\(nearHere("list_xc_10_1_0.json"))"
                    """
                ]
            )
        }())
    }
    
    // TODO: 1. better test. 2. test difference (see `RuntimeIdentifier`).
    func test___list___works_for_xcode_10_2_1() {
        XCTAssertNoThrow(try {
            _ = try simctl("list_xc_10_2_1.json").list()
        }())
    }
    
    func test___list___works_for_xcode_10_0_0() {
        XCTAssertNoThrow(try {
            _ = try simctl("list_xc_10_0_0.json").list()
        }())
    }
    
    func test___list___works_for_xcode_11_0_0() {
        XCTAssertNoThrow(try {
            _ = try simctl("list_xc_11_0_0.json").list()
        }())
    }
    
    private func simctl(_ file: String) throws -> SimctlList {
        return SimctlListImpl(
            bashExecutor: bashExecutor,
            temporaryFileProvider: TemporaryFileProviderMock(
                temporaryFilePath: nearHere(file)
            )
        )
    }
    
    private func nearHere(_ fileName: String) -> String {
        return ("\(#file)" as NSString).deletingLastPathComponent + "/\(fileName)"
    }
}
