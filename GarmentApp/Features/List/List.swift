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

struct ListState: Equatable {
    var sortMode: ListSort = .alphabetical
    var garments: [String] = ["Dress", "Pants", "Shirt", "Jacket"]
    var add = AddState()
    var detail = DetailState(garmentName: "")
}

enum ListAction: Equatable {
    case sort(ListSort)
    case add(AddAction)
    case detail(DetailAction)
}

struct ListEnvironment {
    
}

let listReducer = Reducer<ListState, ListAction, ListEnvironment>.combine(
  .init { state, action, _ in
      switch action {
      case .sort(let sort):
          state.sortMode = sort
          return .none
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
    .pullback(
        state: \.detail,
        action: /ListAction.detail,
        environment: { _ in .init() }
    )
)
        
