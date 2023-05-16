//
//  Data.swift
//  WBTestAvia
//
//  Created by Руслан Гайфуллин on 15.05.2023.
//

import UIKit

class AviaFlight {
    var cityArrival: String
    var cityDeparture: String
    var price: Int
    var departureDate: String
    var arrivalDate: String
    var likeCheck: Bool
    
    init(cityArrival: String, cityDeparture: String, price: Int, departureDate: String, arrivalDate: String, likeCheck: Bool) {
        self.cityArrival = cityArrival
        self.cityDeparture = cityDeparture
        self.price = price
        self.departureDate = departureDate
        self.arrivalDate = arrivalDate
        self.likeCheck = likeCheck
    }
}

extension AviaFlight {
    static func make() -> [AviaFlight] {
        [
        
            AviaFlight(cityArrival: "Санкт-Петербург", cityDeparture: "Москва", price: 10000, departureDate: "15.05)23", arrivalDate: "18.05.23", likeCheck: false),
            
            AviaFlight(cityArrival: "Санкт-Петербург", cityDeparture: "Москва", price: 10000, departureDate: "15.05)23", arrivalDate: "18.05.23", likeCheck: false),
            
            AviaFlight(cityArrival: "Санкт-Петербург", cityDeparture: "Москва", price: 10000, departureDate: "15.05)23", arrivalDate: "18.05.23", likeCheck: false)
        ]
    }
}
