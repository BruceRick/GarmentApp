import SwiftUI

struct ListView: View {
    enum Sort: CaseIterable {
        case alphabetical, creation
        
        var name: String {
            switch self {
            case .alphabetical:
                return "Alphabetical"
            case .creation:
                return "Creation Time"
            }
        }
    }
    
    var garments = ["Dress", "Pants", "Shirt", "Jacket"]
    @State var sort: Sort = .alphabetical
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Sort", selection: $sort) {
                    ForEach(Sort.allCases, id: \.self) {
                        Text($0.name)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 20)
                List(garments, id: \.hash) { garment in
                    NavigationLink(destination: DetailView(garment: garment)) {
                        Text(garment)
                    }
                }
            }
            .navigationTitle("List")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                NavigationLink(destination: AddView()) {
                    Image(systemName: "plus.circle")
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
