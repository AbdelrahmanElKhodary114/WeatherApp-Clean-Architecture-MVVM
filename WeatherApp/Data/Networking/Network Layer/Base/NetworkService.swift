import Foundation
import Alamofire

protocol HTTPClientProtocol {
    func fetch<T: Codable>(request: APIRequest) async throws -> T
    var requestProgress: ((Float) -> Void)? { get set }
}

protocol DataRequestProtocol {
    func customResponseData(completionHandler: @escaping (AFDataResponse<Data>) -> Void)
}

protocol SessionProtocol {
    func customRequest(
        _ url: URL,
        method: HTTPMethod,
        parameters: Parameters?,
        encoding: ParameterEncoding,
        headers: HTTPHeaders?
    ) -> DataRequestProtocol
}

// Make Alamofire types conform to our protocols
extension DataRequest: DataRequestProtocol {
    func customResponseData(completionHandler: @escaping (Alamofire.AFDataResponse<Data>) -> Void) {
        responseData(completionHandler: completionHandler)
    }
}


extension Session: SessionProtocol {
    func customRequest(
        _ url: URL,
        method: HTTPMethod,
        parameters: Parameters?,
        encoding: ParameterEncoding,
        headers: HTTPHeaders?
    ) -> DataRequestProtocol {
        return self.request(
            url,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        )
    }
}

struct NetworkService: HTTPClientProtocol {
    var requestProgress: ((Float) -> Void)?
    
    private let responseAnalyser: ResponseAnalyserProtocol
    private let session: SessionProtocol
    
    init(
        responseAnalyser: ResponseAnalyserProtocol = ResponseAnalyser(),
        session: SessionProtocol = AF
    ) {
        self.responseAnalyser = responseAnalyser
        self.session = session
    }

    func fetch<T: Codable>(request: APIRequest) async throws -> T {
        let dataRequest: DataRequestProtocol
        switch request.requestType {
        case .normal:
            dataRequest = normalRequest(request)
        }
        NetworkLogger.log(request: (dataRequest as? DataRequest)?.convertible.urlRequest)
        return try await performRequest(dataRequest)
    }
    
    private func performRequest<T: Codable>(_ dataRequest: DataRequestProtocol) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            dataRequest.customResponseData { response in
                NetworkLogger.log(data: response.data, response: response.response)
                if let statusError = responseAnalyser.analyse(response: response.response, and: response.data) {
                    continuation.resume(throwing: statusError)
                    return
                }
                
                guard let responseObj = response.data?.convertTo(model: T.self) else {
                    continuation.resume(throwing: NetworkError.decode)
                    return
                }
                
                continuation.resume(returning: responseObj)
            }
        }
    }
    
    private func normalRequest(_ request: APIRequest) -> DataRequestProtocol {
        let url = request.baseURL + (request.path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        let parameters = (((request.body == nil ? request.query : request.body) ?? [:]))
        let encoding: ParameterEncoding = (request.encoding == .url ? URLEncoding.default : JSONEncoding.default)
        let headers = request.headers?.asHTTPHeaders
        let method = HTTPMethod(rawValue: request.method.rawValue)
        
        let newURL = URL(string: url)!
        return session.customRequest(
            newURL,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        )
    }
}
