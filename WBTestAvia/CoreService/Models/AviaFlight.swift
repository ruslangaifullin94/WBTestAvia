//
//  AviaFlight.swift
//  WBTestAvia
//
//  Created by Руслан Гайфуллин on 15.05.2023.
//

import UIKit

final class AviaFlight {
    let uid: String
    var cityArrival: String
    var cityDeparture: String
    var price: Int
    var departureDate: Date
    var arrivalDate: Date
    var likeCheck: Bool
    
    init(cityArrival: String, cityDeparture: String, price: Int, departureDate: Date, arrivalDate: Date, likeCheck: Bool) {
        self.cityArrival = cityArrival
        self.cityDeparture = cityDeparture
        self.price = price
        self.departureDate = departureDate
        self.arrivalDate = arrivalDate
        self.likeCheck = likeCheck
        self.uid = UUID().uuidString
    }
}
