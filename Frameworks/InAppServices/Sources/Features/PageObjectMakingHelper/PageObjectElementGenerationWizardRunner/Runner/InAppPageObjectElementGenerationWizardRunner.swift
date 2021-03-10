#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpcCommon
import MixboxFoundation

public final class InAppPageObjectElementGenerationWizardRunner: PageObjectElementGenerationWizardRunner {
    private let applicationWindowsProvider: ApplicationWindowsProvider
    private let uiEventObservableProvider: UiEventObservableProvider
    private let viewHierarchyProvider: ViewHierarchyProvider
    
    public init(
        applicationWindowsProvider: ApplicationWindowsProvider,
        uiEventObservableProvider: UiEventObservableProvider,
        viewHierarchyProvider: ViewHierarchyProvider)
    {
        self.applicationWindowsProvider = applicationWindowsProvider
        self.uiEventObservableProvider = uiEventObservableProvider
        self.viewHierarchyProvider = viewHierarchyProvider
    }
    
    public func run(completion: (Result<Void, ErrorString>) -> ()) {
        do {
            guard let window = applicationWindowsProvider.keyWindow else {
                throw ErrorString("Can't find application's key window")
            }
            
            let uiEventObservable = try uiEventObservableProvider.uiEventObservable()
            
            let view = PageObjectElementGenerationWizardView()
            
            let wizard = PageObjectElementGenerationWizardImpl(
                view: view,
                viewHierarchyProvider: viewHierarchyProvider
            )
            
            uiEventObservable.add(observer: wizard)
            
            window.addSubview(view)
            
            wizard.set(
                onFinish: {
                    uiEventObservable.remove(observer: wizard)
                    view.removeFromSuperview()
                }
            )
            
            wizard.start()
        } catch let error as ErrorString {
            completion(.failure(error))
        } catch {
            completion(.failure(ErrorString("\(error)")))
        }
    }
}

#endif
