import Foundation
import ComposableArchitecture

struct DetailState: Equatable {
    var garmentName: String
}

enum DetailAction: Equatable {
    case nameChanged(String)
    case save
}

struct DetailEnvironment {
  
}

let detailReducer = Reducer<DetailState, DetailAction, DetailEnvironment> { state, action, environment in
    switch action {
    case .nameChanged(let name):
        state.garmentName = name
        return .none
    case .save:
        return .none
    }
}
