import SwiftUI

private struct MetObjectView: View {
    private var metObject: MetObject

    init(metObject: MetObject) {
        self.metObject = metObject
    }

    var body: some View {
        VStack {
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
            Text(metObject.title)
                .font(.headline)
            Text("\(metObject.classification)")
            Text("Circa: \(metObject.objectBeginDate)")
        }
    }
}

struct MetDataView: View {
    private var viewModel: MainViewModel

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
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
                            MetObjectView(metObject: metObject)
                        }
                        .scrollIndicators(.hidden)
                    }
                }
                .frame(width: geometryProxy.size.width)
            }

            .navigationTitle("Met Browser")
        }
    }
}
struct MainView: View {
    var viewModel = MainViewModel()
    @State var searchString = ""
    @State var sortOrder: Sorting = .forward

    var body: some View {
        GeometryReader { geometryProxy in
            VStack {
                HStack {
                    switch viewModel.status {
                    case .empty:
                        Text("No results")
                    case .loaded:
                        MetDataView(viewModel: viewModel)
                    case .noSearch:
                        Text("You've not done a search yet")
                    case .loading(let percentage):
                        Text("\(percentage * 100)%")
                    }
                }
            }.frame(width: geometryProxy.size.width, height: geometryProxy.size.height)

            .toolbar {
                ToolbarItemGroup(placement: .secondaryAction) {
                    HStack {
                        Text("Sort: ")
                        Picker("Sort Order", selection: $sortOrder) {
                            ForEach(Sorting.allCases) { sort in
                                Text(sort.string)
                            }
                        }
                    }
                    .searchable(text: $searchString,
                                placement: .toolbar,
                                prompt: "Search for Artifact") {
                    }

                }

            }
            .onChange(of: sortOrder) {
                viewModel.sort(order: sortOrder)
            }
            .onSubmit(of: .search) {
                print("new searchstring = \(searchString)")
                viewModel.updateViews(queryString: searchString)
            }
            .navigationTitle("Met Browser")
        }
    }

}
