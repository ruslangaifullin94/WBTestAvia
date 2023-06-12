//
//  CoreNetworkService.swift
//  WBTestAvia
//
//  Created by Руслан Гайфуллин on 09.06.2023.
//

import Foundation

protocol CoreNetworkServiceProtocol {
    func getRequest<T: Codable>(urlRequest: URLRequest, json: T.Type, completion: @escaping (Result<T, CoreNetworkSeviceErrors>) -> Void)
}

final class CoreNetworkService {
    
    //MARK: - Private Properties
    
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    
}



//MARK: - CoreNetworServiceProtocol

extension CoreNetworkService: CoreNetworkServiceProtocol {
    func getRequest<T>(urlRequest: URLRequest, json: T.Type, completion: @escaping (Result<T, CoreNetworkSeviceErrors>) -> Void) where T : Codable {
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                return completion(.failure(.notInternet))
            }
            
            guard let data = data else {
                return completion(.failure(.noData))
            }
            
            do {
                let model = try self.decoder.decode(json, from: data)
                completion(.success(model))
            } catch {
                return completion(.failure(.jsonDecoderError))
            }
        }.resume()
    }
}
