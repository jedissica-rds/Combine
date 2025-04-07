//
//  EndPoint.swift
//  Combine_Study
//
//  Created by Jessica Rodrigues on 26/09/24.
//

import Foundation
import Combine

//APIEndPoint

enum PokemonEndPoint: APIEndpoint {
    case getAllPokemon
    case getPokemon(name : String)
    
    var baseURL: URL {
        return URL(string: "https://pokeapi.co/api/v2/pokemon/")!
    }
    
    var path: String {
        switch self {
        case .getAllPokemon:
            return "?limit=1025"
        case .getPokemon(let name):
            return name
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAllPokemon:
            return .get
        case .getPokemon:
            return .get
        }
    }

    var headers: [String: String]? {
        switch self {
        case .getAllPokemon:
            return ["Authorization": ""]
        case .getPokemon:
            return ["Authorization": ""]
        }
    }
}


protocol APIClient {
    associatedtype EndpointType: APIEndpoint
    func request<T: Decodable>(_ endpoint: EndpointType) -> AnyPublisher<T, Error>
}


class URLSessionAPIClient<EndpointType: APIEndpoint>: APIClient {
    func request<T: Decodable>(_ endpoint: EndpointType) -> AnyPublisher<T, Error> {
        
        let urlFinal = endpoint.baseURL.absoluteString + endpoint.path
        let url = URL(string: urlFinal)
        
        print("Fetching from: \(String(describing: url))")
        var request = URLRequest(url: url ?? endpoint.baseURL)
        request.httpMethod = endpoint.method.rawValue
        
        endpoint.headers?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    let responseString = String(data: data, encoding: .utf8) ?? "Unknown response"
                    print("Error response: \(responseString)")
                    throw APIError.invalidResponse
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}


protocol PokemonServiceProtocol {
    func getAllPokemon() -> AnyPublisher<PokemonResponse, Error>
}

class PokemonService: PokemonServiceProtocol {
    let apiClient = URLSessionAPIClient<PokemonEndPoint>()
    
    func getAllPokemon() -> AnyPublisher<PokemonResponse, Error> {
        return apiClient.request(.getAllPokemon)
    }
    
    func getPokemon(name : String) -> AnyPublisher<Pokemon, Error> {
        return apiClient.request(.getPokemon(name: name))
    }
}
