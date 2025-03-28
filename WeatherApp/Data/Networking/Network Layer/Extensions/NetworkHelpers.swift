import Foundation
import Alamofire

// MARK: - HTTPHeaders Extension
extension Dictionary where Self == [String: String] {
    var asHTTPHeaders: HTTPHeaders {
        var headers: HTTPHeaders = [:]
        for (key, value) in self {
            headers.add(name: key, value: value)
        }
        return headers
    }
}

extension Data {
    
    func convertTo<T: Decodable>(model: T.Type) -> T? {
        
        var decodedModel: T?
        
        do {
            let decoder = JSONDecoder()
            decodedModel = try decoder.decode(model.self, from: self)
        } catch {
            print(error)
        }
        return decodedModel
    }
}
