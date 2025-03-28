protocol WeatherRepositoryProtocol {
    func fetchWeatherData(lat: String, long: String) async throws -> Weather
}
