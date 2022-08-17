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
                    TextField("", text: .constant("2010-JAN-01"))
                        .disabled(true)
                        .multilineTextAlignment(.trailing)
                }
            }
            .navigationTitle("Details")
            .toolbar {
                Button(action: {
                    print("SAVE DETAILS")
                }, label: {
                    Text("Save")
                })
            }
        }
    }
}

private extension ViewStore where State == DetailState, Action == DetailAction {
    func nameBinding() -> Binding<String> {
        binding(get: \.garmentName, send: DetailAction.nameChanged)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(store: Store(
            initialState: .init(garmentName: "Pants"),
            reducer: detailReducer,
            environment: .init()))
    }
}
