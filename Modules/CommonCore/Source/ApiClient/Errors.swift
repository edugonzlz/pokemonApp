public enum NetworkError: Error {
    case badContent
    case badRequest
    case invalidURL
    case unauthorized
}

enum LocalError: Error {
    case wrongJSONFormat(String)
    case badURLRequest
}


