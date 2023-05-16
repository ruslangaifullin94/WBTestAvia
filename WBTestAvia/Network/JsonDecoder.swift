//
//  JsonDecoder.swift
//  WBTestAvia
//
//  Created by Руслан Гайфуллин on 15.05.2023.
//

import UIKit


// MARK: - Ticket
struct Ticket: Codable {
    let flights: [Flight]
}

// MARK: - Flight
struct Flight: Codable {
    let startDate: String
    let endDate: EndDate
    let startLocationCode: StartLocationCode
    let endLocationCode: String
    let startCity: StartCity
    let endCity: String
    let serviceClass: ServiceClass
    let seats: [Seat]
    let price: Int
    let searchToken: String
}

enum EndDate: String, Codable {
    case the000101010000000000UTC = "0001-01-01 00:00:00 +0000 UTC"
}

// MARK: - Seat
struct Seat: Codable {
    let passengerType: PassengerType
    let count: Int
}

enum PassengerType: String, Codable {
    case adt = "ADT"
    case chd = "CHD"
    case inf = "INF"
}

enum ServiceClass: String, Codable {
    case economy = "ECONOMY"
}

enum StartCity: String, Codable {
    case санктПетербург = "Санкт-Петербург"
}

enum StartLocationCode: String, Codable {
    case led = "LED"
}

