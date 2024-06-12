import SwiftUI

struct MainView: View {
    var viewModel = MainViewModel()
    @State var searchString = ""

    var numberOfRows: Int {
        viewModel.metObjects.count
    }

    var body: some View {
        GeometryReader { geometryProxy in
            VStack {
                Text("\(numberOfRows)")
                ScrollView(.vertical) {
                    Spacer()
                        .frame(width: geometryProxy.size.width - 16, height: 20)
                        .offset(y: -20)

                    VStack {
                        ForEach(viewModel.metObjects) { metObject in
                            VStack {
                                showImage(metObject: metObject)
                                HStack {
                                    Text("Title :")
                                        .font(.title)
                                    Text(metObject.title)
                                        .font(.title)
                                }
                                Text(metObject.classification)
                            }
                        }
                        .scrollIndicators(.hidden)
                    }
                }
                .frame(width: geometryProxy.size.width)
            }

            .searchable(text: $searchString, prompt: "Search for Artifact") {
            }
            .onSubmit(of: .search) {
                print(searchString)
                viewModel.updateViews(queryString: searchString)
            }
            .navigationTitle("Met Browser")
        }
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
                        .aspectRatio(1, contentMode: .fit)
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .clipped()
                        .shadow(radius: 8)
                        .padding(16)

                } else if phase.error != nil {
                    Image(.missing)
                        .resizable()
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

        } else {
            Image(.missing)
                .resizable()
                .frame(width: 200, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .clipped()
                .shadow(radius: 8)
                .padding(16)

        }
    }
}
