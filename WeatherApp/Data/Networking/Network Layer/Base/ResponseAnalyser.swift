import Foundation

protocol ResponseAnalyserProtocol {
    func analyse(response: HTTPURLResponse?, and data: Data?) -> Error?
}

struct ResponseAnalyser: ResponseAnalyserProtocol {
    
    func analyse(response: HTTPURLResponse?, and data: Data?) -> Error? {
        
        guard let data = data else {
            return NetworkError.other(msg: "No Data Found")
        }
        
        guard let httpResponse = response else {
            return NetworkError.other(msg: "Invalid HTTPURLResponse")
        }
        
        if let statusError = analyse(statusCode: httpResponse.statusCode, from: data) {
            return statusError
        }

        return nil
    }
    
    private func analyse(statusCode: Int, from data: Data) -> Error? {
        
        if !((200...299).contains(statusCode)) {
            return NetworkError.other(msg: "Seems like something went wrong")
        }
        
        return nil
    }
}
