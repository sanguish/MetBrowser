import SwiftUI

struct MainView: View {
    var viewModel = MainViewModel()
    @State var searchString = ""
    @State var sortOrder: Int = 1

    init() {
        viewModel.sortOrder = sortOrder
        
    }
    var body: some View {
        GeometryReader { geometryProxy in
            VStack {
                ScrollView(.vertical) {
                    Spacer()
                        .frame(width: geometryProxy.size.width - 16, height: 20)
                        .offset(y: -20)

                    VStack {
                        ForEach(viewModel.metObjects) { metObject in
                            displayObject(metObject: metObject)
                        }
                        .scrollIndicators(.hidden)
                    }
                }
                .frame(width: geometryProxy.size.width)
            }

            .toolbar {
                ToolbarItemGroup(placement: .secondaryAction) {
                    HStack {
                        Text("Sort: ")
                        Picker("Sort Order", selection: self.$sortOrder) {
                            Text("Decending").tag(1)
                            Text("Ascending").tag(2)
                        }
                    }
                    .searchable(text: $searchString,
                                placement: .toolbar,
                                prompt: "Search for Artifact") {
                    }

                }

            }
            .onSubmit(of: .search) {
                print("new searchstring = \(searchString)")
                viewModel.updateViews(queryString: searchString)
            }
            .navigationTitle("Met Browser")
        }
    }

    func placeOrder() {}
    func adjustOrder() {}

    @ViewBuilder
    func displayObject(metObject: MetObject) -> some View {
        VStack {
            showImage(metObject: metObject)
            Text(metObject.title)
                .font(.headline)
            Text("Classification: \(metObject.classification)")
        }

    }

    @ViewBuilder
    func showImage(metObject: MetObject) -> some View {
            AsyncImage(url: metObject.primaryImageSmall) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .clipped()
                        .shadow(radius: 8)
                        .padding(16)

                } else if phase.error != nil {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .resizable()
                        .tint(Color.gray)
                        .frame(width: 200, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .clipped()
                        .shadow(radius: 8)
                        .padding(16)

                } else {
                    ProgressView()
                        .frame(width: 200, height: 200)
                        .padding(16)
                }
            }
    }
}
