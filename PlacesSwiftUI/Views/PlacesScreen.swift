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
        NavigationView {
            VStack {
                switch viewModel.state {
                case .loading:
                    ProgressView {
                        Text("Loading")
                    }
                case .error(let error):
                    Text(error)
                case .loaded(let places):
                    createPlacesListView(places)
                }
            }.onAppear {
                viewModel.loadData()
            }
            .navigationTitle("Places")
        }
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
    
}


struct PlacesScreen_Previews: PreviewProvider {
    static var previews: some View {
        PlacesScreen()
    }
}
