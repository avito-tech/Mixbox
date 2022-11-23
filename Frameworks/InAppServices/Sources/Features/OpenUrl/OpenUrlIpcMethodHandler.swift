#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import Foundation
import MixboxIpc
import MixboxIpcCommon
import MixboxFoundation

final class OpenUrlIpcMethodHandler: IpcMethodHandler {
    let method = OpenUrlIpcMethod()
    
    func handle(
        arguments: OpenUrlIpcMethod.Arguments,
        completion: @escaping (OpenUrlIpcMethod.ReturnValue) -> ())
    {
        DispatchQueue.main.async {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(
                    arguments.url,
                    options: [:],
                    completionHandler: { result in
                        OpenUrlIpcMethodHandler.handleOpenUrl(
                            result: result,
                            url: arguments.url,
                            completion: completion
                        )
                    }
                )
            } else {
                let result = UIApplication.shared.openURL(arguments.url)
                
                OpenUrlIpcMethodHandler.handleOpenUrl(
                    result: result,
                    url: arguments.url,
                    completion: completion
                )
            }
        }
    }
    
    private static func handleOpenUrl(
        result: Bool,
        url: URL,
        completion: @escaping (OpenUrlIpcMethod.ReturnValue) -> ())
    {
        completion(
            IpcThrowingFunctionResult.void {
                if !result {
                    throw ErrorString("Не удалось открыть диплинк '\(url)', убедитесь в его валидности")
                }
            }
        )
    }
}

#endif
