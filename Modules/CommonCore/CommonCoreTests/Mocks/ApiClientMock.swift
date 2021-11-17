import Combine

public class ApiClientMock: ApiClientProtocol {

    public var resultValue: Decodable?

    public func request<T>(urlRequest: URLRequest, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        if let resultValue = resultValue as? T {
            completion(.success(resultValue))
        } else {
            completion(.failure(TestError.Error1))
        }
    }

    public func request<T>(urlRequest: URLRequest) -> AnyPublisher<T, Error> where T : Decodable {
        if let resultValue = resultValue as? T {
            return Just(resultValue)
                .mapError { error -> Error in
                    return error
                }
                .eraseToAnyPublisher()
        } else {
            return Fail<T, Error>(error: TestError.Error1 as! Error).eraseToAnyPublisher()
        }
    }

    @available(iOS 15.0.0, *)
    public func request<T>(urlRequest: URLRequest) async throws -> T where T : Decodable {
        if let resultValue = resultValue as? T {
            return resultValue
        } else {
            throw TestError.Error1
        }
    }
}
