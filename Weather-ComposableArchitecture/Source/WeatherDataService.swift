import Foundation
import ComposableArchitecture

struct WeatherDataService {
    var fetchWeatherData: @Sendable () async throws -> WeatherData
}

extension WeatherDataService: DependencyKey {
    static var liveValue: WeatherDataService = {
        let client = WeatherAPIClient()
        let dataService = WeatherDataService(fetchWeatherData: client.fetchWeather)
        return dataService
    }()
}

struct WeatherAPIClient {
    enum WeatherAPIClientError: Error {
        case someError(_ message: String)
    }
    
    @Sendable
    func fetchWeather() async throws -> WeatherData {
        let time = 0.5 + TimeInterval(arc4random_uniform(10)) / 10.0
        try await Task.sleep(for: .seconds(time))
        let shouldFail = arc4random_uniform(2) == 0
        if shouldFail {
            throw WeatherAPIClientError.someError("Some WeatherAPIClientError")
        } else {
            return createRandomWeatherData()
        }
    }
    
    private func createRandomWeatherData() -> WeatherData {
        let subtractTime = -1 * TimeInterval(arc4random_uniform(3600))
        let date = Date().addingTimeInterval(subtractTime)
        
        let temperature = -20 + Float(arc4random_uniform(400)) / 10.0
        
        let tempDiff = -8 + Float(arc4random_uniform(160)) / 10.0
        let realFeel = temperature + tempDiff
        
        let precipitation = Float(arc4random_uniform(101))
        
        let weatherData = WeatherData(locationName: "Osijek", temperature: temperature, realFeel: realFeel, precipitation: precipitation, updatedAt: date)

        return weatherData
    }
}

extension DependencyValues {
  var weatherDataService: WeatherDataService {
    get { self[WeatherDataService.self] }
    set { self[WeatherDataService.self] = newValue }
  }
}
