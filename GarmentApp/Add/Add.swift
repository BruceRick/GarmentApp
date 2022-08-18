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
        let garment = Garment(name: state.garmentName, creationDate: Date(), lastUpdated: nil)
        var storedGarments: [Garment] = Storage.get(.Garments) ?? []
        storedGarments.append(garment)
        Storage.set(storedGarments, key: .Garments)
        state.garmentName = ""
        return .none
    }
}
