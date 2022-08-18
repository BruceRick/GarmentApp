import Foundation

struct Garment: Equatable, Codable, Identifiable {
    var id = UUID()
    var name: String
    let creationDate: Date
    var lastUpdated: Date?
}
