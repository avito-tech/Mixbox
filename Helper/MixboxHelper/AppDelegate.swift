import Cocoa
import MixboxBuiltinIpc
import MixboxIpc

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusBarItem: NSStatusItem = NSStatusItem()
    private let bonjourIpcServiceDiscoverer: BonjourIpcServiceDiscoverer
    private var services = [BonjourIpcService]()
    
    override init() {
        bonjourIpcServiceDiscoverer = BonjourIpcServiceDiscoverer(
            bonjourServiceSettings: BonjourServiceSettings(
                name: "MixboxTestRunner"
            )
        )
        
        super.init()
        
        let onChange = { [weak self] (services: [BonjourIpcService]) -> () in
            DispatchQueue.main.async {
                self?.services = services
                self?.updateMenu()
            }
        }
        
        bonjourIpcServiceDiscoverer.onServiceFound = { onChange($1) }
        bonjourIpcServiceDiscoverer.onServiceLost = { onChange($1) }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        try? bonjourIpcServiceDiscoverer.startDiscovery()
        
        updateMenu()
    }
    
    func updateMenu() {
        let menu = NSMenu()
        
        let quitItem = NSMenuItem(
            title: "Quit",
            action: #selector(NSApp.terminate),
            keyEquivalent: ""
        )
        
        menu.addItem(quitItem)
        
        statusBarItem.menu = menu
        statusBarItem.image = NSImage(
            named: NSImage.Name(
                rawValue: services.isEmpty ? "menu-icon-grayscale" : "menu-icon-colored"
            )
        )
    }
}
