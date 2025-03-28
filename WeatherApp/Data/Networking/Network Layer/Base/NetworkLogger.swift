import Foundation

enum NetworkLogger {
    
    static func log(request: URLRequest?) {
        guard let request else { return }
        
        var logOutput = "\n---------- OUTGOING REQUEST ----------\n"
        defer {
            logOutput += "\n---------- END OF OUTGOING REQUEST ----------\n"
            print(logOutput)
        }
        
        let urlString = request.url?.absoluteString ?? ""
        let urlComponents = URLComponents(string: urlString)
        
        let scheme = urlComponents?.scheme ?? ""
        let host = urlComponents?.host ?? ""
        let method = request.httpMethod ?? ""
        let headers = request.allHTTPHeaderFields?.jsonString ?? "N/A"
        let path = urlComponents?.path ?? ""
        let query = urlComponents?.query ?? ""
        
        logOutput += """
      \(scheme)://\(host) \n
      \(method) \(path)\(query.isEmpty ? "" : "?")\(query)\n
      Headers: \n\(headers)
      """
        
        guard let httpBody = request.httpBody else { return }
        
        if let json = httpBody.jsonDictionary?.jsonString {
            logOutput += "\n\nBody: \(json)"
        } else if let parameters = String(bytes: httpBody, encoding: .utf8) {
            logOutput += "\nBody: \n\(parameters)"
        }
    }
    
    static func log(data: Data?, response: HTTPURLResponse?) {
        var logOutput = "\n---------- INGOING RESPONSE ----------\n"
        defer {
            logOutput += "\n---------- END OF OUTGOING REQUEST ----------\n"
            print(logOutput)
        }
        
        let urlString = response?.url?.absoluteString ?? ""
        let urlComponents = URLComponents(string: urlString)
        let path = urlComponents?.path ?? "N/A"
        let body = data?.jsonDictionary?.jsonString ?? "N/A"
        
        logOutput += """
      Path: \(path)\n
      Status Code: \(response?.statusCode ?? 0)\n
      Body:\n\(body)
      """
    }
}

extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any {
    var jsonString: String? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: data, encoding: .utf8)
        } catch {
            return nil
        }
    }
}

extension Data {
    
    var jsonDictionary: [String: Any]? {
        let jsonObject = try? JSONSerialization.jsonObject(with: self, options: [])
        return jsonObject as?  [String: Any]
    }
}
