import Foundation

public class WeatherViewModel: ObservableObject {
    @Published var cityName = "City name"
    @Published var temperature = "---"
    @Published var weatherDescription = "---"
    @Published var weatherIcon = defaultIcon
    
    public let weatherService: WeatherService
    public init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }
    
    public func refresh() {
        weatherService.loadWeatherData { weather in
            DispatchQueue.main.async {
                self.cityName = weather.city
                self.temperature = "\(weather.temperature)°C"
                self.weatherDescription = weather.description.capitalized
                self.weatherIcon = iconMap[weather.iconName] ?? defaultIcon
            }
        }
    }
    
}

private let defaultIcon = "❓"
private let iconMap = [
    "Drizzle" : "🌧",
    "Thunderstorm" : "⛈",
    "Rain" : "🌧",
    "Snow" : "🌨",
    "Clear" : "☀️",
    "Cloud" : "☁️"
]
