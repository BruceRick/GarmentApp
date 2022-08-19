import Foundation
import ComposableArchitecture

enum ListSort: CaseIterable, Hashable {
    case alphabetical, creation
    
    var name: String {
        switch self {
        case .alphabetical:
            return "Alphabetical"
        case .creation:
            return "Creation Time"
        }
    }
}

enum NavigationState {
    case None, Add, Detail
}

struct ListState: Equatable {
    var sortMode: ListSort = .alphabetical
    var garments: [Garment] = []
    var navigation: NavigationState = .None
    var add = AddState()
    var detail: DetailState?
}

enum ListAction: Equatable {
    case fetchGarments
    case sortChanged(ListSort)
    case sortGarments
    case navigate(NavigationState)
    case selected(Garment?)
    case clear
    case add(AddAction)
    case detail(DetailAction)
}

struct ListEnvironment {
    
}

let listReducer = Reducer<ListState, ListAction, ListEnvironment>.combine(
  .init { state, action, _ in
      switch action {
      case .fetchGarments:
          state.garments = Storage.get(.Garments) ?? []
          return .init(value: .sortGarments)
      case .sortChanged(let sort):
          state.sortMode = sort
          return .init(value: .sortGarments)
      case .sortGarments:
          state.garments.sort { garment1, garment2 in
              switch state.sortMode {
              case .alphabetical:
                  return garment1.name.compare(garment2.name) == .orderedAscending
              case .creation:
                  return garment1.creationDate.compare(garment2.creationDate) == .orderedAscending
              }
          }
          return .none
      case .selected(let garment):
          state.navigation = garment != nil ? .Detail : .None
          if let garment = garment, state.navigation == .Detail, state.detail?.garment.id != garment.id {
              state.detail = .init(garment: garment)
          } else if state.navigation == .None {
             state.detail = nil
          }
          return .none
      case .navigate(let navigationState):
          state.navigation = navigationState
          state.detail = nil
          return .none
      case .clear:
          Storage.removeAll()
          return .init(value: .fetchGarments)
      case .add(.save), .detail(.save), .detail(.delete):
          state.navigation = .None
          return .init(value: .fetchGarments)
      case .add:
          return .none
      case .detail:
          return .none
      }
  },
  addReducer
    .pullback(
        state: \.add,
        action: /ListAction.add,
        environment: { _ in .init() }
    ),
  detailReducer
    .optional()
    .pullback(
        state: \.detail,
        action: /ListAction.detail,
        environment: { _ in .init() }
    )
)
