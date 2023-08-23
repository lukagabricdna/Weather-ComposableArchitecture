import SwiftUI
import ComposableArchitecture

@main
struct Weather_ComposableArchitectureApp: App {
    var body: some Scene {
        WindowGroup {
            let store = Store(initialState: .loading, reducer: { WeatherFeature() })
            WeatherView(store: store)
                .onAppear {
                    store.send(.refreshAction)
                }
        }
    }
}
