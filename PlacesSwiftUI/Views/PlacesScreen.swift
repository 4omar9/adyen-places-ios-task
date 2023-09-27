//
//  PlacesScreen.swift
//  Places
//
//

import SwiftUI
import AdyenNetworking

struct PlacesScreen: View {

    @StateObject var viewModel: ViewModel = .init()
    var body: some View {
        NavigationStack {
            VStack {
                createLocationAuthorizationView()
                if viewModel.preciseLocationEnabled {
                    createRadiusOfInterestView()
                }
                switch viewModel.state {
                case .loading:
                    ProgressView {
                        Text("Loading")
                    }
                case .error(let error):
                    createErrorView(with: error.description)
                case .loaded(let places):
                    createPlacesListView(places)
                }
                Spacer()
            }
            .refreshable {
               await viewModel.loadData()
            }
            .task {
                await viewModel.loadData()
            }
            .navigationTitle("Places")
        }
    }

    @ViewBuilder
    func createLocationAuthorizationView() -> some View {
        VStack {
            Toggle(isOn: $viewModel.preciseLocationEnabled) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Use my precise location")
                    Text("Allow location services to make this work")
                        .font(.system(.footnote))
                }
            }
            .padding()
            .onChange(of: viewModel.preciseLocationEnabled, perform: { newValue in
                if newValue {
                    viewModel.enableUpdatingLocation()
                } else {
                    viewModel.disableUpdatingLocation()
                }
            })
        }
    }

    @ViewBuilder
    private func createRadiusOfInterestView() -> some View {
        VStack(alignment: .leading) {
            Text("Radius of interest")
            Slider(
                value: $viewModel.radiusOfInterest,
                in: 1000...100000,
                step: 100
            ) {
                EmptyView()
            } minimumValueLabel: {
                Text("1000")
            } maximumValueLabel: {
                Text("100000")
            } onEditingChanged: { _ in
                Task {
                    await viewModel.loadData()
                }
            }
            Text("Your current Radius: \(Int(viewModel.radiusOfInterest))")
                .font(.system(.footnote))
        }
        .padding()
    }

    @ViewBuilder
    private func createPlacesListView(_ places: [Place]) -> some View {

        List {
            ForEach(places, id: \.id) { place in
                VStack(alignment: .leading, spacing: 8) {
                    Text(place.name)
                        .font(.system(.title2))
                    createCategoryTileView(place.categories)
                    Text(place.address)
                        .font(.system(.body))
                }
            }
        }
    }

    @ViewBuilder
    private func createCategoryTileView(_ categories: [Place.Category]) -> some View {
        HStack {
            ForEach(categories.map { $0.name }, id: \.self) { item in
                Text(item)
                    .multilineTextAlignment(.center)
                    .font(.system(.caption))
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
        }
    }
    @ViewBuilder
    private func createErrorView(with error: String) -> some View {
        VStack(alignment: .center, spacing: 40) {
            Text(error)
            Button("Reload") {
                Task {
                    await viewModel.loadData()
                }
            }
        }
    }
}


struct PlacesScreen_Previews: PreviewProvider {
    static var previews: some View {
        PlacesScreen()
    }
}
