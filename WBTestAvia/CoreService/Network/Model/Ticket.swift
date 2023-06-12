//
//  Ticket.swift
//  WBTestAvia
//
//  Created by Руслан Гайфуллин on 15.05.2023.
//


import Foundation


struct Ticket: Codable {
    let flights: [Flight]
}


struct Flight: Codable {
    let startDate: String
    let endDate: String
    let startLocationCode: String
    let endLocationCode: String
    let startCity: String
    let endCity: String
    let serviceClass: String
    let price: Int
    let searchToken: String
    
}

