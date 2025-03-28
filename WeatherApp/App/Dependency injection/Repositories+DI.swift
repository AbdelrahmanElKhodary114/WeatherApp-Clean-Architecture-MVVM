import Factory

extension Container {
   
    var weatherRepo: Factory<WeatherRepositoryProtocol> {
        self { WeatherRepository() }
    }
}


