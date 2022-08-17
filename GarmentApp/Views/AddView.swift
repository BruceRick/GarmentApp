import SwiftUI

struct AddView: View {
    @State private var garmentName: String = ""
    
    var body: some View {
        List {
            HStack {
                Text("Garment Name:")
                TextField("", text: $garmentName)
                    .multilineTextAlignment(.trailing)
                    
            }
        }
        .navigationTitle("ADD")
        .toolbar {
            Button(action: {
                print("SAVE DETAILS")
            }, label: {
                Text("Save")
            })
        }

    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
