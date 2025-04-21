import Foundation
import Factory

class WeatherViewModel: ObservableObject {
    
    @Injected(\.fetchWeatherUseCase) var fetchWeatherUseCase
    
    @Published var weather: Weather = .init(from: nil)
    @Published var isLoading = true
    @Published var errorMessage = ""
    @Published var viewState: ViewState = .loading

    func fetchWeather() {
        Task { @MainActor in
            isLoading = true
            viewState = .loading
            defer { isLoading = false }
            do {
                weather = try await fetchWeatherUseCase.execute(latitude: "30.06263", longitude: "31.24967")
                errorMessage = ""
                viewState = .loaded
            } catch {
                errorMessage = "Failed to fetch weather data. Please try again."
                viewState = .error
            }
        }
    }
}

extension WeatherViewModel {
    enum ViewState {
        case loading
        case loaded
        case error
    }
}
