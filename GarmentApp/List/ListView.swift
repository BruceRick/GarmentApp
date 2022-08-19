import SwiftUI
import ComposableArchitecture

struct ListView: View {
    let store: Store<ListState, ListAction>
    typealias ListViewStore = ViewStore<ListState, ListAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                VStack {
                    picker(viewStore)
                    garmentsList(viewStore)
                    detailsBackNavigation(viewStore)
                }
                .navigationTitle("List")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    HStack {
                        clearButton(viewStore)
                        addButton(viewStore)
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear {
                viewStore.send(.fetchGarments)
            }
        }
    }
    
    var detailDestination: some View {
        IfLetStore(
            self.store.scope(
                state: \.detail,
                action: ListAction.detail
            ),
            then: { store in
                DetailView(store: store)
            },
            else: {
                EmptyView()
            }
        )
    }
    
    var addDestination: some View {
        AddView(store: self.store.scope(
            state: \.add,
            action: ListAction.add
        ))
    }
    
    func picker(_ viewStore: ListViewStore) -> some View {
        Picker("Sort", selection: viewStore.sortModeBinding()) {
            ForEach(ListSort.allCases, id: \.self) {
                Text($0.name)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    func garmentsList(_ viewStore: ListViewStore) -> some View {
        if viewStore.garments.count > 0 {
            garments(viewStore)
        } else {
            noGarments
        }
    }
    
    func detailsBackNavigation(_ viewStore: ListViewStore) -> some View {
        // bit of hack to get the Composable Architecture not to mess up cell selection
        // and throw errors. This is required for the back functionality when a user taps
        // 'update' on the details page. Bug is rooted in isActive being enforced in a
        // List loop.
        NavigationLink(destination: detailDestination,
                       isActive: viewStore.detailsNavigationBinding(),
                       label: { EmptyView() } )
    }
    
    @ViewBuilder
    func garments(_ viewStore: ListViewStore) -> some View {
        List(viewStore.garments, id: \.id) { garment in
            Button {
                viewStore.send(.selected(garment))
            } label: {
                NavigationLink(destination: detailDestination,
                               label: {
                    Text(garment.name)
                } )
            }.foregroundColor(.black)
        }
    }
    
    @ViewBuilder
    var noGarments: some View {
        Spacer()
        Text("NO GARMENTS")
            .padding(20)
            .accessibilityIdentifier("no garments")
        Spacer()
    }
    
    func clearButton(_ viewStore: ListViewStore) -> some View {
        Button {
            viewStore.send(.clear)
        } label: {
            Text("Clear")
        }
        .foregroundColor(.red)
        .accessibilityIdentifier("clear")
    }
    
    func addButton(_ viewStore: ListViewStore) -> some View {
        NavigationLink(destination: addDestination,
                       isActive: viewStore.addNavigationBinding(),
                       label: { Image(systemName: "plus.circle").accessibilityIdentifier("add") })
    }
}

private extension ListView {
    
}

private extension ViewStore where State == ListState, Action == ListAction {
    func sortModeBinding() -> Binding<ListSort> {
        binding(get: \.sortMode, send: ListAction.sortChanged)
    }
    
    func addNavigationBinding() -> Binding<Bool> {
        binding { $0.navigation == .Add } send: { .navigate($0 ? .Add : .None) }
    }
    
    func detailsNavigationBinding() -> Binding<Bool> {
        binding { $0.navigation == .Detail } send: { .navigate($0 ? .Detail : .None) }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(store: Store(
            initialState: .init(add: AddState(), detail: DetailState(garment: Garment(name: "Pants", creationDate: Date()))),
            reducer: listReducer,
            environment: ListEnvironment()
        ))
    }
}
