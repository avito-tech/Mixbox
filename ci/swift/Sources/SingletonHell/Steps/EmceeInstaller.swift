import Foundation
import CiFoundation

// Translated from `emcee.sh`
// TODO: Rewrite.
public final class EmceeInstaller {
    public static func installEmceeWithDependencies() throws -> String {
        try installLibssh()
        return try installEmcee()
    }
    
    private static func installLibssh() throws {
        _ = try bashExecutor.executeOrThrow(
            command:
            """
            brew ls --versions libssh2 > /dev/null || brew install libssh2
            """
        )
    }
    
    private static func installEmcee() throws -> String {
        print("Installing Emcee...")
        
        let emceePath: String
        
        if let url = Env.MIXBOX_CI_EMCEE_URL.get() {
            let downloadedEmcee = try RemoteFiles.download(url: url)
            
            emceePath = downloadedEmcee
            
            _ = try bashExecutor.executeOrThrow(
                command:
                """
                chmod +x "\(downloadedEmcee)"
                """
            )
        } else {
            let emceeBuildDir = Variables.temporaryDirectory()
            
            let emceePathOrNil = try? bashExecutor.executeAndReturnTrimmedOutputOrThrow(
                command:
                """
                ls -1 "\(emceeBuildDir)"/Emcee/.build/x86_64-*/debug/AvitoRunner | head -1
                """
            )
            
            if let localEmceePath: String = emceePathOrNil, FileManager.default.fileExists(atPath: localEmceePath) {
                emceePath = localEmceePath
            } else {
                let emceeVersion = "25b6a7662a69d2965eee26010d69468ac86ccfde"
                try bash(
                    """
                    cd "\(emceeBuildDir)"
                    
                    git clone "https://github.com/avito-tech/Emcee"
                    cd Emcee
                    
                    git checkout \(emceeVersion)
                    
                    make build
                    """
                )
                
                emceePath = try bash(
                    """
                    ls -1 "\(emceeBuildDir)"/Emcee/.build/x86_64-*/debug/AvitoRunner | head -1
                    """
                )
            }
        }
        
        guard FileManager.default.isExecutableFile(atPath: emceePath) else {
            throw ErrorString("Failed to install Emcee. File is not executable at path: \(emceePath)")
        }
        
        return emceePath
    }
}
