struct ActionTestsViewSpecification {
    let id: String
    let name: String
    let addViewClosure: (ActionTestsViewAddingContext) -> ()
    
    func addView(context: ActionTestsViewAddingContext) {
        addViewClosure(context)
    }
}

struct ActionTestsViewAddingContext {
    let scrollView: TestStackScrollView
    let id: String
    let reportResultClosure: (String) -> ()
    
    func reportResult(_ result: String) {
        reportResultClosure(result)
    }
}

final class ActionTestsViewViewRegistrar {
    private(set) var viewSpecifications = [String: ActionTestsViewSpecification]()
    
    func registerViews() {
        register("tap") { context in
            context.scrollView.addLabel(id: context.id) {
                $0.onTap = {
                    context.reportResult("tap")
                }
            }
        }
        
        register("press") { context in
            context.scrollView.addLabel(id: context.id) {
                $0.onLongPress = {
                    context.reportResult("press")
                }
            }
        }
        
        register("text") { context in
            context.scrollView.addTextField(id: context.id) {
                $0.onInput = { [weak self] text in
                    context.reportResult("text: \(text ?? "")")
                }
            }
        }
        
        register("swipeLeft") { context in
            context.scrollView.addLabel(id: context.id) {
                $0.onSwipeLeft = {
                    context.reportResult("swipeLeft")
                }
            }
        }
        
        register("swipeRight") { context in
            context.scrollView.addLabel(id: context.id) {
                $0.onSwipeRight = {
                    context.reportResult("swipeRight")
                }
            }
        }
        
        register("swipeUp") { context in
            context.scrollView.addLabel(id: context.id) {
                $0.onSwipeUp = {
                    context.reportResult("swipeUp")
                }
            }
        }
        
        register("swipeDown") { context in
            context.scrollView.addLabel(id: context.id) {
                $0.onSwipeDown = {
                    context.reportResult(context.id)
                }
            }
        }
    }
    
    private func register(_ name: String, _ addViewClosure: @escaping (ActionTestsViewAddingContext) -> ()) {
        viewSpecifications[name] = ActionTestsViewSpecification(
            id: name,
            name: name,
            addViewClosure: addViewClosure
        )
    }
    
}
