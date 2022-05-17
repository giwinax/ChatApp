//
//  errorEmun.swift
//  ChatApp
//
//  Created by s b on 17.05.2022.
//
import Foundation

enum errorEmun: Error {
    case endOfDataError
    case serverError
    case networkError
}

extension errorEmun: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .endOfDataError:
            return NSLocalizedString("All data loaded", comment: "End of data")
        case .serverError:
            return NSLocalizedString("Server side error", comment: "Server rrror")
        case .networkError:
            return NSLocalizedString("Something wrong with network. Check our connection", comment: "Network error")
        }
    }
}
