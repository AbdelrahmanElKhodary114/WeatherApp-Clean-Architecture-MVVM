import XCTest
import Factory
@testable import WeatherApp


class WeatherViewModelTests: XCTestCase {
    
    var sut: WeatherViewModel!
    var useCase: MockFetchWeatherUseCase!
    
    override func setUp() {
        useCase = MockFetchWeatherUseCase()
        _ = Container.shared.fetchWeatherUseCase.register { self.useCase }
        sut = WeatherViewModel()
    }
    // MARK: - Success Cases
    
    func test_fetchWeather_whenSuccessful_shouldUpdateWeatherData() async throws {
        // Given
        let expectedWeather = Weather.sample
        useCase.result = .success(expectedWeather)

        // When
        sut.fetchWeather()
        await Task.sleep()

        // Then
        XCTAssertEqual(sut.weather, expectedWeather)
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.errorMessage.isEmpty)
    }
    
    // MARK: - Failure Cases
    
    func test_fetchWeather_whenFails_shouldShowErrorMessage() async throws {
        // Given
        let error = NSError(domain: "", code: 0)
        useCase.result = .failure(error)
        // When
        sut.fetchWeather()
        await Task.sleep()

        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.errorMessage.isEmpty)
        XCTAssertEqual(sut.errorMessage, "Failed to fetch weather data. Please try again.")
    }
    
    // MARK: - Retry Cases
    
    func test_fetchWeather_whenFailsThenRetrySucceeds_shouldUpdateWeatherData() async throws {
        // Given
        let error = NSError(domain: "", code: 0)
        useCase.result = .failure(error)
        // When (first attempt - failure)
        sut.fetchWeather()
        await Task.sleep()

        // Then (verify failure state)
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.errorMessage.isEmpty)
        
        // Given (retry setup)
        let expectedWeather = Weather.sample2
        useCase.result = .success(expectedWeather)
        
        // When (retry)
        sut.fetchWeather()
        await Task.sleep()

        // Then (verify success)
        XCTAssertEqual(sut.weather, expectedWeather)
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.errorMessage.isEmpty)
    }
    
    // MARK: - Loading State Cases
    
    func test_fetchWeather_whenCalled_shouldSetLoadingState() async throws {
        // Given
        let error = NSError(domain: "", code: 0)
        useCase.result = .failure(error)
        
        // When
        sut.fetchWeather()
        
        // Then (immediately should be loading)
        XCTAssertTrue(sut.isLoading)
        
        await Task.sleep()

        // Then (after completion)
        XCTAssertFalse(sut.isLoading)
    }
    
    // MARK: - Edge Cases
    
    func test_fetchWeather_whenReceivesEmptyCityName_shouldStillSucceed() async throws {
        // Given
        let weatherWithEmptyCity = Weather(cityName: "", temperature: "28", mainCondition: .clouds)
        useCase.result = .success(weatherWithEmptyCity)
        // When
        sut.fetchWeather()
        await Task.sleep()
        
        // Then
        XCTAssertEqual(sut.weather.cityName, "")
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.errorMessage.isEmpty)
    }
    
    func test_fetchWeather_whenReceivesInvalidTemperature_shouldStillSucceed() async throws {
        // Given
        let weatherWithInvalidTemp = Weather(cityName: "Cairo", temperature: "--", mainCondition: .rain)
        useCase.result = .success(weatherWithInvalidTemp)

        // When
        sut.fetchWeather()
        await Task.sleep()

        // Then
        XCTAssertEqual(sut.weather.temperature, "--")
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.errorMessage.isEmpty)
    }
}

// MARK: - Mocks
extension WeatherViewModelTests {
    
    class MockFetchWeatherUseCase: FetchWeatherUseCaseProtocol {
        
        var result: Result<Weather, Error>?
        var receivedLat: String?
        var receivedLong: String?
    
        func execute(latitude: String, longitude: String) async throws -> Weather {
            receivedLat = latitude
            receivedLong = longitude
            
            if let result = result {
                switch result {
                case .success(let data):
                    return data
                case .failure(let error):
                    throw error
                }
            } else {
                fatalError("Should not throw error when no result is provided")
            }
        }
    }
}

extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Double = 0.1) async {
        let nanoseconds = UInt64(seconds * 1_000_000_000)
        try? await Task.sleep(nanoseconds: nanoseconds)
    }
}

