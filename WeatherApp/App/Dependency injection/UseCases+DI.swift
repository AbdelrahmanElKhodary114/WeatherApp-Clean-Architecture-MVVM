import Factory

extension Container {
   
    var fetchWeatherUseCase: Factory<FetchWeatherUseCaseProtocol> {
        self { FetchWeatherUseCase() }
    }
}


