import MixboxFoundation

public protocol ElementInteractionWithDependenciesPerformer: class {
    // TODO: FileLine is so lonely here on its level of abstraction, I think it needs some friends to play with.
    // Friends are important. They give us emotional support, general happiness and they prevent us from going
    // into a deep abyss of madness. They are fun. Everyone should have a friend. For example, back in school when
    // I was young, happy, and careless I had a class in C++ and it had friends. I feel uncomfortable when
    // I keep FileLine alone here (I mean alone, because `dependencies` is on the other level of abstraction).
    // I'm worrying that I make its lifecycle unbearable.
    // However, a better option would be to remove it from here. FileLine shouldn't stay together with
    // ElementInteractionWithDependencies. Because it is a lovely but primitive creature. They aren't ment to be with
    // each other. I am very pro-diversity, but it just doesn't feel right.
    // OMG: It is not even used for performing interaction. Only for logging.
    func perform(
        interaction: ElementInteractionWithDependencies,
        fileLine: FileLine)
        -> InteractionResult
}
