import SwiftUI
import ComposableArchitecture

struct WeatherView: View {
    private let store: StoreOf<WeatherFeature>
    
    init(store: StoreOf<WeatherFeature>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                switch viewStore.state {
                case let .data(item):
                    listView(item: item, viewStore: viewStore)
                case let .error(message):
                    errorView(message: message, viewStore: viewStore)
                case .loading:
                    ProgressView()
                }
            }
        }
    }
    
    private func listView(item: WeatherDisplayableItem, viewStore: WeatherFeatureViewStore) -> some View {
        VStack {
            Text("\(item.locationTitle): \(item.location)")
            Text("\(item.temperatureTitle): \(item.temperature)")
            Text("\(item.realFeelTitle): \(item.realFeel)")
            Text("\(item.precipitationTitle): \(item.precipitation)")
            Text("\(item.updatedAtTitle): \(item.updatedAt)")
            RefreshButton {
                viewStore.send(.refreshAction)
            }
        }
    }
    
    private func errorView(message: String, viewStore: WeatherFeatureViewStore) -> some View {
        VStack {
            Text("[Error] \(message)")
            RefreshButton {
                viewStore.send(.refreshAction)
            }
        }
    }
}

struct RefreshButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "arrow.clockwise.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(.blue)
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(
            store: Store(
                initialState: WeatherFeature.State.loading,
                reducer: {
                    WeatherFeature()
                }))
        .previewDisplayName("Loading")

        WeatherView(
            store: Store(
                initialState: WeatherFeature.State.error("Some error"),
                reducer: {
                    WeatherFeature()
                }))
        .previewDisplayName("Error")
        
        WeatherView(
            store: Store(
                initialState: WeatherFeature.State.data(WeatherDisplayableItem.sampleItem()),
                reducer: {
                    WeatherFeature()
                }))
        .previewDisplayName("Weather")
    }
}
