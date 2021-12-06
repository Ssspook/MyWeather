import Foundation
import CoreLocation
import Alamofire

public final class WeatherService: NSObject {
    
    private let locationManager = CLLocationManager()
    private let API_KEY = "dcb9db2a884d1b9f55868916b8375536"
    private var completionHandler: ((Weather) -> Void)?
    
    public override init() {
        super.init()
        
        locationManager.delegate = self
    }
    
    public func loadWeatherData(_ completionHandler: @escaping((Weather) -> Void)) {
        self.completionHandler = completionHandler
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    

    private func makeDataRequest(forCoordinates coordinates: CLLocationCoordinate2D) {
        let requestString = "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=\(API_KEY)&units=metric"
        
        AF.request(requestString, method: .get).validate().responseData { response in
            guard let data = response.data else { return }
            
            if let weather = self.JSONparser(withData: data) {
                self.completionHandler?(weather)
            } else {
                return
            }
        }
    }
    
    private func JSONparser(withData data: Data) -> Weather? {
        let decoder = JSONDecoder()
        do {
            let weatherInfo = try decoder.decode(APIResponse.self, from: data)
             guard let weather = Weather(response: weatherInfo) else { return nil }

            return weather
        } catch _ as NSError { }

        return nil
    }
}

extension WeatherService: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        makeDataRequest(forCoordinates: location.coordinate)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Smt went wrong: \(error.localizedDescription)")
    }
}
struct APIWeather: Decodable {
    let description: String
    let iconName: String
    
    enum CodingKeys: String, CodingKey {
        case description
        case iconName = "main"
    }
}

struct APIMain: Decodable {
    let temp: Double
    
}

struct APIResponse: Decodable {
    let name: String
    let main: APIMain
    let weather: [APIWeather]
}
