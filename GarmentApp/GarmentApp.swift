import SwiftUI
import ComposableArchitecture

@main
struct GarmentApp: App {
    var body: some Scene {
        WindowGroup {
            ListView(store: Store(
                initialState: .init(),
                reducer: listReducer,
                environment: .init()))
        }
    }
}
