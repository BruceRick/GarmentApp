import SwiftUI

struct DetailView: View {
    var garment: String
    @State private var garmentName: String = ""
    
    var body: some View {
        List {
            HStack {
                Text("Garment Name:")
                TextField("", text: .constant(garment))
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

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(garment: "JACKET")
    }
}
