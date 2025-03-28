struct WeatherResponse: Codable {
    let weather: [WeatherDataResponse]?
    let main: MainWeatherResponse?
    let name: String?
}

struct MainWeatherResponse: Codable {
    let temp: Double?

}

struct WeatherDataResponse: Codable {
    let main: String?
}
