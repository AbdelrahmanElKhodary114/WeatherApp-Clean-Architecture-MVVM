import Factory

protocol FetchWeatherUseCaseProtocol {
    func execute(latitude: String, longitude: String) async throws -> Weather
}

struct FetchWeatherUseCase: FetchWeatherUseCaseProtocol {
    @Injected(\.weatherRepo) var weatherRepo

    func execute(latitude: String, longitude: String) async throws -> Weather {
        try await weatherRepo.fetchWeatherData(lat: latitude, long: longitude)
    }
}
