import ComposableArchitecture
import XCTest

@testable import GarmentApp

@MainActor
final class GarmentAppTests: XCTestCase {
    let mainQueue = DispatchQueue.test
    
    func testListAdd() async {
        let testGarments = [
            Garment(name: "alpha", creationDate: Date()),
        ]
        Storage.set(testGarments, key: .Garments)
        
        let store = TestStore(
            initialState: ListState(),
            reducer: listReducer,
            environment: .init()
        )
        
        await store.send(.navigate(.Add)) {
            $0.navigation = .Add
        }
        
        await store.send(.add(.save)) {
            $0.navigation = .None
        }
        
        await store.receive(.fetchGarments) {
            $0.garments = testGarments
        }
        
        await store.receive(.sortGarments) {
            $0.garments = testGarments
        }
    }
    
    func testListDetail() async {

    }
    
    func testListSort() async {

    }
}
