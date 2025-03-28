import Factory
import XCTest
@testable import WeatherApp

class WeatherRepositoryTests: XCTestCase {
    
    var sut: WeatherRepository!
    var mockNetworkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        _ = Container.shared.networkService.register { self.mockNetworkService }
        sut = WeatherRepository()
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        super.tearDown()
    }
    
    // MARK: - Success Cases
    
    func test_fetchWeatherData_callsNetworkServiceWithCorrectRequest() async {
        // Given
        let expectedResponse = WeatherResponse.mock
        mockNetworkService.fetchResult = .success(expectedResponse)
        let testLat = "30.06263"
        let testLong = "31.24967"
        
        // When
        do {
            _ = try await sut.fetchWeatherData(lat: testLat, long: testLong)
            
            // Then
            XCTAssertTrue(mockNetworkService.fetchCalled)
            guard let request = mockNetworkService.lastRequest as? FetchWeatherRequest else {
                XCTFail("Wrong request type")
                return
            }
            XCTAssertNotNil(request.query?["lat"] as? String)
            XCTAssertNotNil(request.query?["lon"] as? String)
            
            let latInRequestQuery =  request.query?["lat"] as! String
            let longInRequestQuery = request.query?["lon"] as! String
            
            XCTAssertEqual(latInRequestQuery, testLat)
            XCTAssertEqual(longInRequestQuery, testLong)
        } catch {
            XCTFail("Should not throw error: \(error)")
        }
    }
    
    func test_fetchWeatherData_returnsCorrectWeatherModel() async {
        // Given
        let expectedResponse = WeatherResponse.mock
        mockNetworkService.fetchResult = .success(expectedResponse)
        let expectedEntity = Weather(from: WeatherResponse.mock)
        
        // When
        do {
            let result = try await sut.fetchWeatherData(lat: "30.06263", long: "31.24967")
            
            // Then
            XCTAssertEqual(result.cityName, expectedEntity.cityName)
            XCTAssertEqual(result.temperature, expectedEntity.temperature)
            XCTAssertEqual(result.mainCondition, expectedEntity.mainCondition)
        } catch {
            XCTFail("Should not throw error: \(error)")
        }
    }
    
    // MARK: - Failure Cases
    
    func test_fetchWeatherData_throwsErrorWhenNetworkFails() async {
        // Given
        let expectedError = NSError(domain: "TestError", code: 500)
        mockNetworkService.fetchResult = .failure(expectedError)
        
        // When
        do {
            _ = try await sut.fetchWeatherData(lat: "30.06263", long: "31.24967")
            XCTFail("Should throw error")
        } catch {
            // Then
            XCTAssertEqual(error as NSError, expectedError)
        }
    }
}

//MARK: Mocks

extension WeatherRepositoryTests {

    class MockNetworkService: HTTPClientProtocol {
        var requestProgress: ((Float) -> Void)?
        
        // Properties to track calls and control behavior
        var fetchCalled = false
        var lastRequest: APIRequest?
        var fetchResult: Result<Any, Error>?
        
        func fetch<T: Codable>(request: APIRequest) async throws -> T {
            fetchCalled = true
            lastRequest = request
            
            if let result = fetchResult {
                switch result {
                case .success(let value):
                    if let typedValue = value as? T {
                        return typedValue
                    } else {
                        throw MockError.typeMismatch
                    }
                case .failure(let error):
                    throw error
                }
            } else {
                throw MockError.resultNotSet
            }
        }
        
        enum MockError: Error {
            case resultNotSet
            case typeMismatch
        }
    }
}
