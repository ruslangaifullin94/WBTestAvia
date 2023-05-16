//
//  Network.swift
//  WBTestAvia
//
//  Created by Руслан Гайфуллин on 15.05.2023.
//

import UIKit

enum APIError: Error {
    case notInternet
    case jsonError
    
    var errorDescription: String {
        switch self {
        case .notInternet:
            return "Нет соединения с интернетом"
        case .jsonError:
            return "Неизвестная ошибка"
        }
    }
}

class NetworkApi {
    func getTicketRequest(completion: @escaping (Result<Ticket, APIError>) -> Void) {
        let url = URL(string: "https://vmeste.wildberries.ru/api/avia-service/twirp/aviaapijsonrpcv1.WebAviaService/GetCheap")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json, text/plain, /", forHTTPHeaderField: "accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody = """
    {
        "startLocationCode": "LED"
    }
    """
        request.httpBody = requestBody.data(using: .utf8)
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                return completion(.failure(.notInternet))
            }
            guard let data = data,
                  let tiketCodable = try? JSONDecoder().decode(Ticket.self, from: data)
            else {
                return completion(.failure(.jsonError))
            }
            completion(.success(tiketCodable))
        }
        task.resume()
    }
}







