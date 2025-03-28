import Foundation

protocol APIRequest {
    var path: String { get }
    var baseURL: String { get }
    var method: RequestMethod { get }
    var requestType: RequestType { get }
    var encoding: RequestEncoding { get }
    var headers: [String: String]? { get }
    var query: [String: Any]? { get }
    var body: [String: Any]? { get }
}

extension APIRequest {
    
    var baseURL: String { "https://api.openweathermap.org" }
    var method: RequestMethod { .get }
    var requestType: RequestType { .normal }
    var encoding: RequestEncoding { .url }
    var body: [String: Any]? { nil }

    var headers: [String: String]? {
        return [:]
    }
}
