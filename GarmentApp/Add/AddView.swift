import SwiftUI
import ComposableArchitecture

struct AddView: View {
    let store: Store<AddState, AddAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            List {
                HStack {
                    Text("Garment Name:")
                    TextField("Enter Name", text: viewStore.nameBinding())
                        .multilineTextAlignment(.trailing)
                        .accessibilityIdentifier("garment name")
                        
                }
            }
            .navigationTitle("ADD")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(action: {
                    viewStore.send(.save)
                }, label: {
                    Text("Save")
                }).accessibilityIdentifier("save")
            }
        }
    }
}

private extension ViewStore where State == AddState, Action == AddAction {
    func nameBinding() -> Binding<String> {
        binding(get: \.garmentName, send: AddAction.nameChanged)
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(store: Store(
            initialState: .init(),
            reducer: addReducer,
            environment: .init()
        ))
    }
}
