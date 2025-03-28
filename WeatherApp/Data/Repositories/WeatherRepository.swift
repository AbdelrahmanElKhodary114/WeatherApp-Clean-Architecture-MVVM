import Factory

struct WeatherRepository: WeatherRepositoryProtocol {
    
    @Injected(\.networkService) var networkService
    
    func fetchWeatherData(lat: String, long: String) async throws -> Weather {
        let request = FetchWeatherRequest(lat: lat, long: long)
        let response: WeatherResponse?  = try await networkService.fetch(request: request)
        return Weather(from: response)
    }
}
