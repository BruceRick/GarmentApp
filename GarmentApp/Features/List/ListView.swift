import SwiftUI
import ComposableArchitecture

struct ListView: View {
    let store: Store<ListState, ListAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                VStack {
                    Picker("Sort", selection: viewStore.sortModeBinding()) {
                        ForEach(ListSort.allCases, id: \.self) {
                            Text($0.name)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 20)
                    List(viewStore.garments, id: \.hash) { garment in
                        NavigationLink(garment, destination:
                            DetailView(store: self.store.scope(
                                state: \.detail,
                                action: ListAction.detail
                            ))
                        )
                    }
                }
                .navigationTitle("List")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    NavigationLink(destination:
                        AddView(store: self.store.scope(
                            state: \.add,
                            action: ListAction.add
                        ))
                    ) {
                        Image(systemName: "plus.circle")
                    }
                }
            }.navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

private extension ViewStore where State == ListState, Action == ListAction {
    func sortModeBinding() -> Binding<ListSort> {
        binding(get: \.sortMode, send: ListAction.sort)
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(store: Store(
            initialState: .init(),
            reducer: listReducer,
            environment: .init()
        ))
    }
}
