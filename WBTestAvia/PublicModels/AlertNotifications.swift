//
//  AlertNotifications.swift
//  WBTestAvia
//
//  Created by Руслан Гайфуллин on 09.06.2023.
//

import UIKit

final class AlertNotifications {
    
   static let shared = AlertNotifications()
    
   private init () {}
    
    func presentAlert(for viewController: UIViewController, _ text: String) {
        
        let alertController = UIAlertController(title: "Ошибка", message: text, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true)
    }
    
}
