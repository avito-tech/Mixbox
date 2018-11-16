// UPD/TODO: Изначально класс разрабатывался под XCUI, но потом переюзался для реальной иерархии.
// Вообще он не нужен для реальной иерархии.
//
// Класс нужен для сбора всех найденных ElementSnapshot, а также для
// сбора всех результатов матчинга (может использоваться для объяснения причины того,
// что ничего не найдено).
//
// Как юзается: внутри кложура в NSPredicate, которым ищется элемент(ы).
// Также юзается finalize() для отметки, что поиск завершен.
//
// Мы не вызываем поиск сами напрямую. Поэтому мы должны трекать начало и конец поиска,
// чтобы не наполнять результаты лишними результатами при повторном поиске. XCUI менеджит
// поиск в своих кишках, мы лишь можем догадываться о том как он это делает.
//
public final class ElementQueryResolvingState {
    private(set) var matchingResults = [MatchingResult]()
    private(set) var matchingSnapshots = [ElementSnapshot]()
    private(set) var elementSnapshots = [ElementSnapshot]()
    
    // TODO: Возвращать ошибку при чтении данный в статусах undefined и resolving.
    private enum State {
        case undefined
        case resolving
        case resolved
    }
    
    private var state: State = .undefined
    
    public init() {
    }
    
    public func start() {
        assert(state == .undefined, "ElementQueryResolvingState (\(self)) was used twice, it should not be reused")
        
        state = .resolving
    }
    
    public func stop() {
        state = .resolved
    }
    
    public func append(matchingResult: MatchingResult, elementSnapshot: ElementSnapshot) {
        switch state {
        case .resolving:
            matchingResults.append(matchingResult)
            elementSnapshots.append(elementSnapshot)
            
            switch matchingResult {
            case .match:
                matchingSnapshots.append(elementSnapshot)
            case .mismatch:
                break
            }
        case .resolved:
            break
        case .undefined:
            break
        }
    }
}
