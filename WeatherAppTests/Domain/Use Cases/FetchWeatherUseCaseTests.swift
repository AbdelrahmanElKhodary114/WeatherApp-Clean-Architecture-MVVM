import XCTest
import Factory
@testable import WeatherApp

class FetchWeatherUseCaseTests: XCTestCase {
    var sut: FetchWeatherUseCase!
    var mockRepository: MockWeatherRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockWeatherRepository()
        let _ = Container.shared.weatherRepo.register { self.mockRepository }
        sut = FetchWeatherUseCase()
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    // MARK: - Success Cases
    
    func test_execute_callsRepositoryWithCorrectParameters() async {
        // Given
        let expectedWeather = Weather(cityName: "Cairo", temperature: "28", mainCondition: .clear)
        mockRepository.result = .success(expectedWeather)
        let testLat = "30.06263"
        let testLong = "31.24967"
        
        // When
        do {
            _ = try await sut.execute(latitude: testLat, longitude: testLong)
            XCTAssertEqual(mockRepository.receivedLat, testLat)
            XCTAssertEqual(mockRepository.receivedLong, testLong)
        } catch {
            XCTFail("Should not throw error")
        }
    }
    
    func test_execute_returnsCorrectWeatherData() async {
        // Given
        let expectedWeather = Weather(cityName: "Cairo", temperature: "28", mainCondition: .clear)
        mockRepository.result = .success(expectedWeather)

        // When
        do {
            let result = try await sut.execute(latitude: "30.06263", longitude: "31.24967")
            
            // Then
            XCTAssertEqual(result, expectedWeather)
        } catch {
            XCTFail("Should not throw error")
        }
    }
    
    // MARK: - Failure Cases
    
    func test_execute_throwsErrorWhenRepositoryFails() async {
        // Given
        let expectedError = NSError(domain: "TestError", code: 500)
        mockRepository.result = .failure(expectedError)
        
        // When
        do {
            _ = try await sut.execute(latitude: "30.06263", longitude: "31.24967")
            XCTFail("Should throw error")
        } catch {
            // Then
            XCTAssertEqual(error as NSError, expectedError)
        }
    }
}


extension FetchWeatherUseCaseTests {
    
    class MockWeatherRepository: WeatherRepositoryProtocol {
        
        var result: Result<Weather, Error>?
        var receivedLat: String?
        var receivedLong: String?
        
        func fetchWeatherData(lat: String, long: String) async throws -> Weather {
            receivedLat = lat
            receivedLong = long
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
