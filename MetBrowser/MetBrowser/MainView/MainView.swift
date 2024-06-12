import SwiftUI

struct MainView: View {
    var viewModel = MainViewModel()
    @State var searchString = ""


    var body: some View {
        List {
            ForEach(viewModel.metObjects) { metObject in
                Text(metObject.title)
            }
        }
        .searchable(text: $searchString, prompt: "search pattern") {
        }
        .onSubmit(of: .search) {
            viewModel.updateViews(queryString: searchString)
        }
        .navigationTitle("Met Browser")
    }
}
