import Brew
import CiFoundation
import Bash
import Foundation
import RemoteFiles

public final class EmceeInstallerImpl: EmceeInstaller {
    private let brew: Brew
    private let fileDownloader: FileDownloader
    private let bashExecutor: BashExecutor
    private let emceeExecutableUrl: URL
    
    public init(
        brew: Brew,
        fileDownloader: FileDownloader,
        bashExecutor: BashExecutor,
        emceeExecutableUrl: URL)
    {
        self.brew = brew
        self.fileDownloader = fileDownloader
        self.bashExecutor = bashExecutor
        self.emceeExecutableUrl = emceeExecutableUrl
    }
    
    public func installEmcee() throws -> String {
        try installLibssh()
        return try downloadEmcee()
    }
    
    private func installLibssh() throws {
        try brew.installLibrary(name: "libssh2")
    }
    
    private func downloadEmcee() throws -> String {
        let emceePath = try fileDownloader.download(url: emceeExecutableUrl)
        
        _ = try bashExecutor.executeOrThrow(
            command:
            """
            chmod +x "\(emceePath)"
            """
        )
        
        guard FileManager.default.isExecutableFile(atPath: emceePath) else {
            throw ErrorString("Failed to install Emcee. File is not executable at path: \(emceePath)")
        }
        
        return emceePath
    }
}
