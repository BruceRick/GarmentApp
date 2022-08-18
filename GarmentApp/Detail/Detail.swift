import Foundation
import ComposableArchitecture

struct DetailState: Equatable {
    var garment: Garment
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, YYYY h:mm a"
        formatter.locale = .current
        return formatter
    }()
    
    var created: String {
        return dateFormatter.string(from: garment.creationDate)
    }
    
    var lastUpdated: String {
        if let lastUpdated = garment.lastUpdated {
            return dateFormatter.string(from: lastUpdated)
        }
        
        return "--"
    }
}

enum DetailAction: Equatable {
    case nameChanged(String)
    case save
    case delete
}

struct DetailEnvironment {
  
}

let detailReducer = Reducer<DetailState, DetailAction, DetailEnvironment> { state, action, environment in
    switch action {
    case .nameChanged(let name):
        state.garment.name = name
        return .none
    case .save:
        state.garment.lastUpdated = Date()
        var storedGarments: [Garment] = Storage.get(.Garments) ?? []
        storedGarments.removeAll { $0.id == state.garment.id }
        storedGarments.append(state.garment)
        Storage.set(storedGarments, key: .Garments)
        return .none
    case .delete:
        var storedGarments: [Garment] = Storage.get(.Garments) ?? []
        storedGarments.removeAll { $0.id == state.garment.id }
        Storage.set(storedGarments, key: .Garments)
        return .none
    }
}
