@testable import WeatherApp
extension WeatherResponse {
    static var mock: WeatherResponse {
        WeatherResponse(weather: [WeatherDataResponse(main: "fog")], main: MainWeatherResponse(temp: 28.5), name: "Cairo")
    }
}
