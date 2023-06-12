//
//  TicketsNetworkService.swift
//  WBTestAvia
//
//  Created by Руслан Гайфуллин on 15.05.2023.
//

import UIKit

enum TicketsNetworkServiceErrors: Error {
    case invalidRequest
    case invalidInternet
    case invalidServer
}

protocol TicketsNetworkServiceProtocol {
    func getTicketRequest(completion: @escaping (Result<[AviaFlight], TicketsNetworkServiceErrors>) -> Void)
}

final class TicketsNetworkService {
    
    // MARK: - Private properties
    
    private let coreNetworkService: CoreNetworkServiceProtocol
    
    private let baseUrlString = "https://vmeste.wildberries.ru"
    private let path = "/api/avia-service/twirp/aviaapijsonrpcv1.WebAviaService/GetCheap"
    private let parameters = ["startLocationCode": "LED"]
 
    
    // MARK: - Init
    
    init(coreNetworkService: CoreNetworkServiceProtocol) {
        self.coreNetworkService = coreNetworkService
    }
    
    
    // MARK: - Private Methods
    
    private func createUrlRequest() -> URLRequest? {
        guard let url = URL(string: baseUrlString) else {
            return nil
        }
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = "POST"
        request.setValue("application/json, text/plain, /", forHTTPHeaderField: "accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let data = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        request.httpBody = data
        return request
    }
}



//MARK: - TicketsNetworkServiceProtocol

extension TicketsNetworkService: TicketsNetworkServiceProtocol {
    
    func getTicketRequest(completion: @escaping (Result<[AviaFlight], TicketsNetworkServiceErrors>) -> Void) {
       
        guard let urlRequest = createUrlRequest() else {
            return completion(.failure(.invalidRequest))
        }
        
        coreNetworkService.getRequest(urlRequest: urlRequest, json: Ticket.self) { result in
            switch result {
                
            case .success(let tickets):
                let date = DateManager.shared
                let aviaFlights = tickets.flights.map {
                    AviaFlight(
                        cityArrival: $0.endCity,
                        cityDeparture: $0.startCity,
                        price: $0.price,
                        departureDate: date.createDateFromString(from: $0.startDate, dateStringFormatter: "yyyy-MM-dd HH:mm:ss ZZZZ zzz") ?? Date.now,
                        arrivalDate: date.createDateFromString(from: $0.endDate, dateStringFormatter: "yyyy-MM-dd HH:mm:ss ZZZZ zzz") ?? Date.now,
                        likeCheck: false
                    )
                }
                completion(.success(aviaFlights))
                
            case .failure(let error):
                switch error {
                    
                case .notInternet:
                    completion(.failure(.invalidInternet))
                    
                default:
                    completion(.failure(.invalidServer))
                }
            }
        }
    }
}
