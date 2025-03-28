struct FetchWeatherRequest: APIRequest {
    
    let path: String = "/data/2.5/weather"
    var query: [String: Any]?

    init(lat: String, long: String) {
        query = [
            "lat" : lat,
            "lon": long,
            "appid": "397a0d4b55126a6aff551016c99a15b9",
            "units": "metric"
        ]
    }
}
