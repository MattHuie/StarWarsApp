import Foundation

// Made a list of all network errors users may encounter
enum NewtworkError: Error {
    case badURL
    case badStatusCode
    case apiError(Error)
    case jsonDecodingError(Error)
}
