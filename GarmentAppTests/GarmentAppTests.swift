import ComposableArchitecture
import XCTest

@testable import GarmentApp

@MainActor
final class GarmentAppTests: XCTestCase {
    override func setUpWithError() throws {
        let emptyGarments: [Garment] = []
        Storage.set(emptyGarments, key: .Garments)
    }
    
    override func tearDownWithError() throws {
        let emptyGarments: [Garment] = []
        Storage.set(emptyGarments, key: .Garments)
    }
    
    func testListAdd() async {
        let store = TestStore(
            initialState: ListState(),
            reducer: listReducer,
            environment: .init()
        )
        
        await store.send(.navigate(.Add)) {
            $0.navigation = .Add
        }
        
        await store.send(.add(.nameChanged("Test"))) {
            $0.add.garmentName = "Test"
        }
        
        await store.send(.add(.save)) {
            $0.navigation = .None
            $0.add.garmentName = ""
        }
        
        let garments: [Garment]? = Storage.get(.Garments)
        XCTAssertTrue(garments?.count == 1, "stored garments doesn't match")
        await store.receive(.fetchGarments) {
            $0.garments = garments!
        }
        
        await store.receive(.sortGarments)
    }
    
    func testListDetailUpdate() async {
        let store = TestStore(
            initialState: ListState(),
            reducer: listReducer,
            environment: .init()
        )
        
        let garment = Garment(name: "Test", creationDate: Date())
        await store.send(.selected(garment)) {
            $0.detail = .init(garment: garment)
            $0.navigation = .Detail
        }
        
        await store.send(.detail(.nameChanged("TestUpdated"))) {
            $0.detail?.garment.name = "TestUpdated"
        }
        
        await store.send(.detail(.save)) {
            let garments: [Garment]? = Storage.get(.Garments)
            $0.navigation = .None
            $0.detail?.garment.lastUpdated = garments?[0].lastUpdated
        }
        
        let garments: [Garment]? = Storage.get(.Garments)
        XCTAssertTrue(garments?.count == 1, "stored garments doesn't match")
        await store.receive(.fetchGarments) {
            $0.garments = garments!
        }
        
        await store.receive(.sortGarments)
    }
    
    func testListDetailDelete() async {
        let garment = Garment(name: "Test", creationDate: Date())
        let garments: [Garment] = [garment]
        Storage.set(garments, key: .Garments)
        
        let store = TestStore(
            initialState: ListState(),
            reducer: listReducer,
            environment: .init()
        )
        
        await store.send(.selected(garment)) {
            $0.detail = .init(garment: garment)
            $0.navigation = .Detail
        }
        
        var storedGarments: [Garment]? = Storage.get(.Garments)
        XCTAssertTrue(storedGarments?.count == 1, "stored garments doesn't match")
        
        await store.send(.detail(.delete)) {
            $0.navigation = .None
        }
        
        storedGarments = Storage.get(.Garments)
        XCTAssertTrue(storedGarments?.count == 0, "stored garments doesn't match")
        
        await store.receive(.fetchGarments)
        await store.receive(.sortGarments)
    }
    
    func testListSort() async {
        let mike = Garment(name: "mike", creationDate: Date(timeIntervalSinceNow: -180))
        let alpha = Garment(name: "alpha", creationDate: Date(timeIntervalSinceNow: -60))
        let zebra = Garment(name: "zebra", creationDate: Date(timeIntervalSinceNow: -120))
        
        let garments: [Garment] = [
            mike,
            alpha,
            zebra
        ]
        Storage.set(garments, key: .Garments)
        
        let store = TestStore(
            initialState: ListState(),
            reducer: listReducer,
            environment: .init()
        )
        
        await store.send(.fetchGarments) {
            $0.garments = [
                mike,
                alpha,
                zebra
            ]
        }
        
        await store.receive(.sortGarments) {
            $0.garments = [
                alpha,
                mike,
                zebra
            ]
        }
        
        await store.send(.sortChanged(.creation)) {
            $0.sortMode = .creation
        }
        
        await store.receive(.sortGarments) {
            $0.garments = [
                mike,
                zebra,
                alpha
            ]
        }
    }
}
