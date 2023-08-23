import Foundation
import ComposableArchitecture

typealias WeatherFeatureViewStore = ViewStore<WeatherFeature.State, WeatherFeature.Action>

struct WeatherFeature: Reducer {
    enum State: Equatable {
        case loading
        case error(String)
        case data(WeatherDisplayableItem)
    }
    
    enum Action {
        case refreshAction
        case weatherDataFetchResult(Result<WeatherData, Error>)
    }
    
    @Dependency(\.weatherDataService) var weatherDataService
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .refreshAction:
            state = .loading
            return .run { send in
                do {
                    let weatherData = try await weatherDataService.fetchWeatherData()
                    await send(.weatherDataFetchResult(.success(weatherData)))
                } catch {
                    await send(.weatherDataFetchResult(.failure(error)))
                }
            }
        case let .weatherDataFetchResult(weatherDataFetchResult):
            switch weatherDataFetchResult {
            case let .success(weatherData):
                let weatherDisplayableItem = WeatherDisplayableItem(weatherData: weatherData)
                state = .data(weatherDisplayableItem)
            case let .failure(error):
                var errorMessage = "Unknown error occurred"
                if case let WeatherAPIClient.WeatherAPIClientError.someError(message) = error {
                    errorMessage = "WeatherAPIClientError Message: \(message)"
                }
                state = .error(errorMessage)
            }
            return .none
        }
    }
}
