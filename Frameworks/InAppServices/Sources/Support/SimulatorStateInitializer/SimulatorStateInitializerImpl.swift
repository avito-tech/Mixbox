#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation
import MixboxUiKit

public final class SimulatorStateInitializerImpl: SimulatorStateInitializer {
    private let textInputFrameworkProvider: TextInputFrameworkProvider
    
    public init(textInputFrameworkProvider: TextInputFrameworkProvider) {
        self.textInputFrameworkProvider = textInputFrameworkProvider
    }
    
    public func initializeSimulatorState() throws {
        try KeyboardPrivateApi.sharedInstance().set(automaticMinimizationEnabled: false)
        try setUpTextInputPreferencesController()
    }
    
    private func setUpTextInputPreferencesController() throws {
        try textInputFrameworkProvider.withLoadedFramework { textInputFramework in
            let controller = try textInputFramework.sharedTextInputPreferencesController()
            
            try setUpTextInputPreferencesController(
                textInputPreferencesController: controller
            )
        }
    }
    
    private func setUpTextInputPreferencesController(
        textInputPreferencesController: TextInputPreferencesController
    ) throws {
        textInputPreferencesController.setAutocorrectionEnabled(false)
        textInputPreferencesController.setPredictionEnabled(false)
        textInputPreferencesController.setDidShowGestureKeyboardIntroduction(true)
        textInputPreferencesController.setDidShowContinuousPathIntroduction(true)
        
        textInputPreferencesController.synchronizePreferences()
    }
}

#endif
