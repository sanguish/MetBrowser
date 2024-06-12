import SwiftUI


struct MainView: View {
    var viewModel = MainViewModel()
    @State var searchString = ""

    var body: some View {
        List {
            ForEach(viewModel.metObjects) { metObject in
                HStack {
                    Text(metObject.title)
                    Spacer()
                    showImage(metObject: metObject)
                }
            }
        }
        .searchable(text: $searchString, prompt: "search pattern") {
        }
        .onSubmit(of: .search) {
            viewModel.updateViews(queryString: searchString)
        }
        .navigationTitle("Met Browser")
    }

    func primaryImageSmallURLIsNotNil(_ URL: URL?) -> Bool {
        return URL != nil
    }

    @ViewBuilder
    func showImage(metObject: MetObject) -> some View {
        if primaryImageSmallURLIsNotNil(metObject.primaryImageSmallURL) {
            AsyncImage(url: metObject.primaryImageSmallURL) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(1, contentMode: .fill)
                        .frame(width: 200, height: 200)

                } else if (phase.error != nil) {
                    Image(systemName: "exclamationmark.octagon.fill")
                        .foregroundStyle(Color.red)
                } else {
                    ProgressView()
                }
            }
            .frame(width: 200, height: 200)

        } else {
            Image(systemName: "exclamationmark.triangle.fill")
        }
    }

}
