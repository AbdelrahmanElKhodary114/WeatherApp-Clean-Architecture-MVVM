import Foundation
import Factory

class WeatherViewModel: ObservableObject {
    
    @Injected(\.fetchWeatherUseCase) var fetchWeatherUseCase
    
    @Published var weather: Weather = .init(from: nil)
    @Published var isLoading = true
    @Published var errorMessage = ""
    
    func fetchWeather() {
        Task { @MainActor in
            isLoading = true
            defer { isLoading = false }
            do {
                weather = try await fetchWeatherUseCase.execute(latitude: "30.06263", longitude: "31.24967")
                errorMessage = ""
            } catch {
                errorMessage = "Failed to fetch weather data. Please try again."
            }
        }
    }
}
