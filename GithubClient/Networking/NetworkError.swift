//
//  NetworkError.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 18/05/2025.
//

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidStatus(Int)
    case commonError(ErrorResponse)
    case invalidDecode(Error)
}

extension NetworkError {
    var message: String {
        switch self {
        case .invalidURL:
            return "Invalid URL. Please check your network connection."
        case .invalidResponse:
            return "Unable to connect to the server. Please try again."
        case .invalidStatus(let code):
            return "Server error (HTTP \(code)). Please try again later."
        case .commonError(let errorResponse):
            if let errors = errorResponse.errors, let firstError = errors.first {
                return "\(firstError.resource ?? "Error"): \(firstError.message ?? "Unknown error")"
            }
            if let message = errorResponse.message {
                return message
            }
            return "An error occurred. Please try again."
        case .invalidDecode:
            return "Unable to process server response. Please try again."
        }
    }
}

extension NetworkError: Equatable {
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL):
            return true
        case (.invalidResponse, .invalidResponse):
            return true
        case (.invalidStatus(let lhsCode), .invalidStatus(let rhsCode)):
            return lhsCode == rhsCode
        case (.commonError(let lhsError), .commonError(let rhsError)):
            return lhsError.status == rhsError.status
        case (.invalidDecode( _), .invalidDecode( _)):
            return true
        default:
            return false
        }
    }
}
