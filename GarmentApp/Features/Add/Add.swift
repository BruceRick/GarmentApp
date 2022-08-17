import Foundation
import ComposableArchitecture

struct AddState: Equatable {
    var garmentName = ""
}

enum AddAction: Equatable {
    case nameChanged(String)
    case save
}

struct AddEnvironment {

}

let addReducer = Reducer<AddState, AddAction, AddEnvironment> { state, action, environment in
    switch action {
    case .nameChanged(let name):
        state.garmentName = name
        return .none
    case .save:
        return .none
    }
}
