import SwiftUI
import ComposableArchitecture

struct DetailView: View {
    let store: Store<DetailState, DetailAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            List {
                HStack {
                    Text("Garment Name:")
                    TextField("", text: viewStore.nameBinding())
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Created On:")
                    TextField("", text: .constant(viewStore.created))
                        .disabled(true)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Last Updated:")
                    TextField("", text: .constant(viewStore.lastUpdated))
                        .disabled(true)
                        .multilineTextAlignment(.trailing)
                }
            }
            .navigationTitle("Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                HStack {
                    Button {
                        viewStore.send(.delete)
                    } label: {
                        Image(systemName: "trash.fill")
                    }
                        .foregroundColor(.red)
                    Button(action: {
                        viewStore.send(.save)
                    }, label: {
                        Text("Update")
                    })
                }
            }
        }
    }
}

private extension ViewStore where State == DetailState, Action == DetailAction {
    func nameBinding() -> Binding<String> {
        binding(get: \.garment.name, send: DetailAction.nameChanged)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(store: Store(
            initialState: .init(garment: Garment(name: "Pants", creationDate: Date())),
            reducer: detailReducer,
            environment: .init()))
    }
}
