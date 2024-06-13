import SwiftUI

/// The `MetArtifactView` provides the view that displays an individiual artifact.
private struct MetArtifactView: View {
    private var metArtifact: MetArtifact

    init(metObject: MetArtifact) {
        self.metArtifact = metObject
    }

    var body: some View {
        VStack {
            AsyncImage(url: metArtifact.primaryImageSmall) { phase in
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
            Text(metArtifact.title)
                .font(.headline)
            Text("\(metArtifact.classification)")
            Text("Circa: \(metArtifact.objectBeginDate)")
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
                        ForEach(viewModel.metArtifacts) { metObject in
                            MetArtifactView(metObject: metObject)
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

    var disabled: Bool {
        switch viewModel.status {
        case .loading:
            return false
        default:
            return true
        }
    }
    @ViewBuilder
    func ProgressCircle(percentage: Double) -> some View {
        ZStack {
            Circle()
                .stroke(Color.blue.opacity(0.25), style: StrokeStyle(lineWidth: 16))
            Circle()
                .trim(from: 0, to: percentage)
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 16, lineCap: .round))
                .foregroundColor(.green)
                .rotationEffect(.degrees(-90))
            VStack {
                Text("\(Int(percentage * 100))%")
                    .font(.title3)
                    .animation(.none)
            }
        }
        .frame(width: 200, height: 200)

    }
    var body: some View {
        GeometryReader { geometryProxy in
            VStack {
                HStack {
                    switch viewModel.status {
                    case .empty:
                        Text("Your search turned up no results")
                            .font(.largeTitle)
                    case .loaded:
                        MetDataView(viewModel: viewModel)
                    case .noSearch:
                        Text("To start a search type a term in the search field and hit return.")
                            .font(.largeTitle)
                    case .loading(let percentage):
                        ProgressCircle(percentage: percentage)
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
                    }.disabled(!disabled)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        viewModel.killFetch()
                    } label: {
                        Label("Stop", systemImage: "stop.fill")
                            .foregroundStyle(disabled ? Color.gray : Color.red)
                            .labelStyle(.titleAndIcon)
                    }
                    .disabled(disabled)
                }
            }
            .onChange(of: sortOrder) {
                viewModel.sort(order: sortOrder)
            }
            .onSubmit(of: .search) {
                viewModel.updateViews(queryString: searchString)
            }
            .navigationTitle("Met Browser")
        }
    }

}
