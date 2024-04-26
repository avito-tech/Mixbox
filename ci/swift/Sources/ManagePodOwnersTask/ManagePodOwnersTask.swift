import Cocoapods
import Releases
import Tasks

public final class ManagePodOwnersTask: LocalTask {
    private let cocoapodsTrunkInfo: CocoapodsTrunkInfo
    private let cocoapodsTrunkAddOwner: CocoapodsTrunkAddOwner
    private let cocoapodsTrunkRemoveOwner: CocoapodsTrunkRemoveOwner
    private let listOfPodspecsToPushProvider: ListOfPodspecsToPushProvider
    
    public init(
        cocoapodsTrunkInfo: CocoapodsTrunkInfo,
        cocoapodsTrunkAddOwner: CocoapodsTrunkAddOwner,
        cocoapodsTrunkRemoveOwner: CocoapodsTrunkRemoveOwner,
        listOfPodspecsToPushProvider: ListOfPodspecsToPushProvider)
    {
        self.cocoapodsTrunkInfo = cocoapodsTrunkInfo
        self.cocoapodsTrunkAddOwner = cocoapodsTrunkAddOwner
        self.cocoapodsTrunkRemoveOwner = cocoapodsTrunkRemoveOwner
        self.listOfPodspecsToPushProvider = listOfPodspecsToPushProvider
    }
    
    public func execute() throws {
        let ownerEmails = [
            "artyom.razinov@gmail.com",
            "arazinov@avito.ru",
            "asgoncharov@avito.ru",
            "vvvakulenko@avito.ru",
            "aailinykh@avito.ru"
        ]
        
        // There is an assuption here that podspecs are pushed.
        // This task should only be executed after the release!
        let podspecs = try listOfPodspecsToPushProvider.listOfPodspecsToPush()
        
        for podspec in podspecs {
            let info: CocoapodsTrunkInfoResult.Info
            
            switch try cocoapodsTrunkInfo.info(podName: podspec.name) {
            case .found(let foundInfo):
                info = foundInfo
            case .notFound:
                continue
            }
            
            let currentOwners = Set(info.owners.map { $0.email })
            
            let ownersToAdd = ownerEmails.filter { !currentOwners.contains($0) }
            let ownersToRemove = currentOwners.filter { !ownerEmails.contains($0) }
            
            for ownerEmail in ownersToRemove {
                try cocoapodsTrunkRemoveOwner.removeOwner(
                    podName: podspec.name,
                    ownerEmail: ownerEmail
                )
            }
            
            for ownerEmail in ownersToAdd {
                try cocoapodsTrunkAddOwner.addOwner(
                    podName: podspec.name,
                    ownerEmail: ownerEmail
                )
            }
        }
    }
}
