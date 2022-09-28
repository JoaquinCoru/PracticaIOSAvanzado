//
//  NetworkModel.swift
//  IOSAvanzado
//
//  Created by Joaquín Corugedo Rodríguez on 1/9/22.
//

import Foundation

enum NetworkError: Error, Equatable {
      case malformedURL
      case dataFormatting
      case other
      case noData
      case errorCode(Int?)
      case tokenFormatError
      case decoding
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

class NetworkModel {

    let session: URLSession
    var token: String?

    init(urlSession: URLSession = .shared,token: String? = nil) {
        self.session = urlSession
        self.token = token
    }

    func login(user: String, password: String, completion: @escaping (String?, NetworkError?) -> Void) {
        guard let url = URL(string: "https://dragonball.keepcoding.education/api/auth/login") else {
            completion(nil, .malformedURL)
            return
        }
        
        let loginString = String(format: "%@:%@", user, password)
        guard let loginData = loginString.data(using: .utf8) else {
            completion(nil, .dataFormatting)
            return
        }
        let base64LoginString = loginData.base64EncodedString()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        //URLSession.shared
        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(nil, .other)
                return
            }
            
            guard let data = data else {
                completion(nil, .noData)
                return
            }
            
            guard let httpResponse = (response as? HTTPURLResponse),
                  httpResponse.statusCode == 200 else {
                completion(nil, .errorCode((response as? HTTPURLResponse)?.statusCode))
                return
            }
            
            guard let token = String(data: data, encoding: .utf8) else {
                completion(nil, .tokenFormatError)
                return
            }
            
            completion(token, nil)
        }
        
        task.resume()
    }

    func getHeroes(completion: @escaping ([Hero], NetworkError?) -> Void) {
        
        struct Body: Encodable {
            let name: String
        }
        
        performAuthenticatedNetworkRequest("https://dragonball.keepcoding.education/api/heros/all",
                                           httpMethod: .post,
                                           httpBody: Body(name: "")) { (result: Result<[Hero], NetworkError>) in
            switch result {
            case .success(let success):
                completion(success, nil)
            case .failure(let failure):
                completion([], failure)
            }
        }

    }

    func getLocations(heroId: String, completion: @escaping ([HeroCoordenates], NetworkError?) -> Void) {
        
        struct Body: Encodable {
            let id: String
        }
        
        performAuthenticatedNetworkRequest(
            "https://dragonball.keepcoding.education/api/heros/locations",
            httpMethod: .post,
            httpBody: Body(id: heroId)) { (result:Result<[HeroCoordenates],NetworkError>) in
                switch result{
                case .success(let success):
                    completion(success, nil)
                case .failure(let failure):
                    completion([], failure)
                }
            }
    
    }
}

private extension NetworkModel {
    func performAuthenticatedNetworkRequest<R: Decodable, B: Encodable>(_ urlString: String, httpMethod: HTTPMethod, httpBody: B?, completion: @escaping (Result<R, NetworkError>) -> Void) {
        
        guard let url = URL(string: urlString), let token = self.token else {
            completion(.failure(.malformedURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        if let httpBody {
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try? JSONEncoder().encode(httpBody)
        }
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.other))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            guard let response = try? JSONDecoder().decode(R.self, from: data) else {
                completion(.failure(.decoding))
                return
            }
            completion(.success(response))
        }
        
        task.resume()
    }
}
