//
//  CoreNetworkSeviceErrors.swift
//  WBTestAvia
//
//  Created by Руслан Гайфуллин on 10.06.2023.
//

import Foundation

enum CoreNetworkSeviceErrors: Error {
    case notInternet
    case noData
    case jsonDecoderError
    
    var errorDescription: String {
        switch self {
        case .notInternet:
            return "Нет соединения с интернетом"
        case .noData:
            return "Ошибка данных"
        case .jsonDecoderError:
            return "Ошибка декодирования"
        }
    }
}
