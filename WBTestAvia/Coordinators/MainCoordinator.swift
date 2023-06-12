//
//  MainCoordinator.swift
//  WBTestAvia
//
//  Created by Руслан Гайфуллин on 08.06.2023.
//

import UIKit

final class MainCoordinator {
    
    //MARK: - Private Properties
        
    private var childCoordinators: [CoordinatorProtocol] = []
    
    
    //MARK: - Private Methods
    
    private func addChildCoordinator(_ coordinator: CoordinatorProtocol) {
        guard !self.childCoordinators.contains(where: {$0 === coordinator}) else { return }
        childCoordinators.append(coordinator)
    }
    
    private func removeChildCoodinator(_ coordinator: CoordinatorProtocol) {
        childCoordinators.removeAll(where: {$0 === coordinator})
    }
}



//MARK: - CoordinatorProtocol

extension MainCoordinator: CoordinatorProtocol {
    func start() -> UIViewController {
        let ticketsCoodinator = TicketsCoordinator(navigationController: UINavigationController())
        addChildCoordinator(ticketsCoodinator)
        return ticketsCoodinator.start()
    }
}
