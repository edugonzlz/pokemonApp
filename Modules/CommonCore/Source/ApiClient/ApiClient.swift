import Combine

public protocol ApiClientProtocol {
    func request<T: Decodable>(urlRequest: URLRequest, completion: @escaping (_ result: Result<T, Error>) -> Void)

    @available(iOS 13.0, *)
    func request<T: Decodable>(urlRequest: URLRequest) -> AnyPublisher<T, Error>

    @available(iOS 15.0, *)
    func request<T: Decodable>(urlRequest: URLRequest) async throws -> T
}

public class ApiClient: ApiClientProtocol {

    private let session: URLSession
    private let decoder: JSONDecoder

    public init(session: URLSession = URLSession.default,
                decoder: JSONDecoder = .default) {
        self.session = session
        self.decoder = decoder
    }
}

private extension ApiClient {
    func handleResponse(_ response: URLResponse) -> Error? {
        guard let httpResponse = response as? HTTPURLResponse else {
            return NetworkError.badContent
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            if httpResponse.statusCode == 401 {
                return NetworkError.unauthorized
            } else {
                return NetworkError.badRequest
            }
        }

        return nil
    }
}

//MARK - Result
public extension ApiClient {
    func request<T: Decodable>(urlRequest: URLRequest, completion: @escaping (_ result: Result<T, Error>) -> Void) {
        let task = session.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                if let response = response, let error = self.handleResponse(response) {
                    completion(.failure(error))
                    return
                }

                if let data = data {
                    if let entity = try? self.decoder.decode(T.self, from: data) {
                        completion(.success(entity))
                    } else {
                        completion(.failure(LocalError.wrongJSONFormat("\(T.self)")))
                    }
                } else if let error = error {
                    completion(.failure(error))
                }
            }
        }

        task.resume()
    }
}

//MARK - Combine
public extension ApiClient {
    func request<T: Decodable>(urlRequest: URLRequest) -> AnyPublisher<T, Error> {
        return session
            .dataTaskPublisher(for: urlRequest)
            .tryMap { data, response in
                if let error = self.handleResponse(response) {
                    throw error
                }
                return data
            }
            .decode(type: T.self, decoder: decoder)
            .mapError { error -> Error in
                return error
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

}

//MARK - Async
@available(iOS 15.0.0, *)
public extension ApiClient {
    func request<T: Decodable>(urlRequest: URLRequest) async throws -> T {
        let (data, response) = try await session.data(for: urlRequest)
        if let error = self.handleResponse(response) {
            throw error
        }
        return try self.decoder.decode(T.self, from: data)
    }
}
