struct Weather: Equatable {
    let cityName: String
    let temperature: String
    let mainCondition: WeatherCondition
}

extension Weather {
    init(from model: WeatherResponse?) {
        cityName = model?.name ?? "--"
        temperature =  model?.main?.temp == nil ? "--" : "\(Int(model?.main?.temp ?? 0.0)) °C"
        mainCondition = WeatherCondition(rawValue: (model?.weather?.first?.main ?? "").lowercased()) ?? .clear
    }
}
