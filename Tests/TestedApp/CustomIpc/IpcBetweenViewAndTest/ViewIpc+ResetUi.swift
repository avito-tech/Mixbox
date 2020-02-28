import MixboxIpc
import MixboxIpcCommon
import TestsIpc
import MixboxFoundation

extension ViewIpc {
    func registerResetUiMethod<ViewType: UIView, ArgumentType: Codable>(
        view: ViewType,
        argumentType: ArgumentType.Type,
        handler: @escaping (ViewType, ArgumentType) -> ())
    {
        register(method: ResetUiIpcMethod<ArgumentType>()) { [weak view] argument, completion in
            guard let strongView = view else {
                completion(IpcThrowingFunctionResult.threw(ErrorString("View, for which ResetUiIpcMethod has been registered, became nil")))
                return
            }
            
            DispatchQueue.main.async {
                handler(strongView, argument)
                
                completion(IpcThrowingFunctionResult.returned(IpcVoid()))
            }
        }
    }
    
    func registerResetUiMethod<ViewType: UIView>(
        view: ViewType,
        handler: @escaping (ViewType) -> ())
    {
        registerResetUiMethod(view: view, argumentType: IpcVoid.self) { view, _ in
            handler(view)
        }
    }
}
