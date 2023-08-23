import Foundation

struct WeatherDisplayableItem: Equatable {
    var locationTitle = "Location"
    var location = ""
    var temperatureTitle = "Temperature"
    var temperature = ""
    var realFeelTitle = "Real Feel"
    var realFeel = ""
    var precipitationTitle = "Percipitation"
    var precipitation = ""
    var updatedAtTitle = "Last update"
    var updatedAt = ""
}

extension WeatherDisplayableItem {
#if DEBUG
    static func sampleItem() -> Self {
        Self(
            location: "Osijek",
            temperature: "26",
            realFeel: "28",
            precipitation: "12%",
            updatedAt: "Just now"
        )
    }
#endif
    
    init(weatherData: WeatherData) {
        location = weatherData.locationName
        temperature = String(format: "%.1f", weatherData.temperature)
        realFeel = String(format: "%.1f", weatherData.realFeel)
        precipitation = String(format: "%.1f", weatherData.precipitation)
        updatedAt = weatherData.updatedAt.formatted()
    }
}
