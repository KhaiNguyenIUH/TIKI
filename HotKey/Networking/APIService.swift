import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingError(Error)
}

enum APIEndpoint: String {
    case hotKeywords = "/v3/146a98f0-76ad-42bb-b093-65f2bd4fd767"
    // ...
}

enum BaseURL {
    case uat
    case prod
    case custom(String)
    
    func rawValue() -> String {
        switch self {
        case .uat: return "https://run.mocky.io"
        case .prod: return ""
        case .custom(let value): return value
        }
    }
    
    static func from(_ string: String) -> BaseURL {
        switch string.lowercased() {
        case "uat": return .uat
        case "prod": return .prod
        default: return .custom(string)
        }
    }
}

class APIService {
    static let shared: APIService = {
        return APIService(baseURL: BaseURL.uat.rawValue())
    }()
    
    private(set) var baseURL: String
    private let session: URLSession
    
    public init(baseURL: String, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }
    
    private func request<T: Decodable>(
        endpoint: String,
        responseType: T.Type,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch let decodingError {
                completion(.failure(.decodingError(decodingError)))
            }
        }
        task.resume()
    }
    
    func updateBaseEndpoint (to baseURL: BaseURL) {
        self.baseURL = baseURL.rawValue()
        APIService.shared.baseURL = baseURL.rawValue()
    }
    
    func getBaseEndpoint() -> BaseURL {
        return BaseURL.from(self.baseURL)
    }
    
    func fetchHotKeywords(completion: @escaping ([HotKeyword]?) -> Void) {
        request(endpoint: APIEndpoint.hotKeywords.rawValue, responseType: HotKeywordResponse.self) { result in
            switch result {
            case .success(let response):
                completion(response.data.items)
            case .failure(let error):
                Logger().log("API Error: \(error)")
                completion(nil)
            }
        }
    }
}
