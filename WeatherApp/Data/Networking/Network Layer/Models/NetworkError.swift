import Foundation

enum NetworkError: Error, Equatable {

    case decode
    case other(msg: String)
    
    var errorMessage: String {
        switch self {
        case .decode:
            return "Error in decoding"
        case .other(msg: let msg):
            return msg
        }
    }
}
extension Error {
    var errorMessage: String {
        if let err = self as? NetworkError {
            return err.errorMessage
        } else {
            return self.localizedDescription
        }
    }
}
