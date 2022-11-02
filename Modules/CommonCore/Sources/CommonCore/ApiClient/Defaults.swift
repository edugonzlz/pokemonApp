import Foundation

extension URLSession {
    public static var `default`: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [:]
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        return URLSession(configuration: configuration)
    }
}

extension JSONDecoder {
    public static var `default`: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
