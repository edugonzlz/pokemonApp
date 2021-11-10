import Foundation

public enum RequestMethod: String {
    case get    = "GET"
    case post   = "POST"
    case delete = "DELETE"
    case put    = "PUT"
    case patch  = "PATCH"
}

public protocol Endpoint {
    var host: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
    var body: Encodable? { get }
    var method: RequestMethod { get }
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy { get }
    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy { get }

    func makeRequest() throws -> URLRequest
}

public extension Endpoint {
    public var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        return .iso8601
    }

    public var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy {
        return .convertFromSnakeCase
    }

    public func makeRequest() throws -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = path

        if !queryItems.isEmpty {
            urlComponents.queryItems = queryItems
        }

        guard let url = urlComponents.url else {
            throw LocalError.badURLRequest
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = body?.data

        return urlRequest
    }
}
