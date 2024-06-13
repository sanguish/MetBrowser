import SwiftUI

struct MetDataView: View {
    private var viewModel: MainViewModel

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        GeometryReader { geometryProxy in
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading) {
                    ForEach(viewModel.metArtifacts) { metObject in
                        MetArtifactView(metArtifact: metObject)
                    }
                    Text("\(viewModel.metArtifacts.count)")
                }
                .scrollIndicators(.hidden)
            } 
            .frame(width: geometryProxy.size.width)
            .navigationTitle("Met Browser")
        }
    }
}

/// This is the main view of the window. It shows the various unloaded states, setsup the toolbars, and shows the loaded state.
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
