enum WeatherCondition: String {
    case clouds = "clouds"
    case mist = "mist"
    case smoke = "smoke"
    case haze = "haze"
    case dust = "dust"
    case fog = "fog"
    case rain = "rain"
    case drizzle = "drizzle"
    case showerRain = "shower rain"
    case thunderstorm = "thunderstorm"
    case clear = "clear"
    
    var lottieAnimationName: String {
        switch self {
        case .clouds, .mist, .smoke, .haze, .dust, .fog:
            return "cloudy"
        case .rain, .drizzle, .showerRain:
            return "rainy"
        case .thunderstorm:
            return "thundery"
        case .clear:
            return "sunny"
        }
    }
}
