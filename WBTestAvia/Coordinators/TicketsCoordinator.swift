//
//  TicketsCoordinator.swift
//  WBTestAvia
//
//  Created by Руслан Гайфуллин on 08.06.2023.
//

import UIKit

protocol TicketsCoordinatorProtocol {
    func pushDetailViewController(ticket: AviaFlight)
}


final class TicketsCoordinator {
        
    //MARK: - Private Properties
    
    private var navigationController: UINavigationController
    
    
    //MARK: -  Init
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
}



//MARK: - CoordinatorProtocol

extension TicketsCoordinator: CoordinatorProtocol {
    func start() -> UIViewController{
        let coreNetworkService = CoreNetworkService()
        let ticketsNetworkService = TicketsNetworkService(coreNetworkService: coreNetworkService)
        let mainViewModel = TicketsViewModel(ticketsNetworkService: ticketsNetworkService, coordinator: self)
        let ticketsViewController = TicketsViewController(viewModel: mainViewModel)
        let navigationController = UINavigationController(rootViewController: ticketsViewController)
        self.navigationController = navigationController
        return navigationController
    }
    
}



//MARK: - TicketsCoordinatorProtocol

extension TicketsCoordinator: TicketsCoordinatorProtocol {
    func pushDetailViewController(ticket: AviaFlight) {
        let detailViewModel = DetailViewModel(ticket: ticket)
        let ticketDetailViewController = DetailViewController(viewModel: detailViewModel)
        navigationController.pushViewController(ticketDetailViewController, animated: true)
    }
    
    
}
