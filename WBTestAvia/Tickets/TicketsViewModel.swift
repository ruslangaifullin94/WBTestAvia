//
//  MainViewModel.swift
//  WBTestAvia
//
//  Created by Руслан Гайфуллин on 08.06.2023.
//

import Foundation

protocol TicketChangeStateDelegateProtocol: AnyObject {
    func didChangeStateTickets(ticket: AviaFlight)
}

protocol TicketsViewModelProtocol {
    var dataTicket: [AviaFlight] { get }
    var stateChanger: ((TicketsViewModel.State) -> Void)? { get set }
    func getTickets()
    func didTapCell(index: IndexPath)
    func didTapLikeInCell(ticket: AviaFlight)
}

final class TicketsViewModel {
    
    enum State {
        case loading
        case loaded
        case reloadCell(index: IndexPath)
        case loadedError(error: String)
    }
    
    
    //MARK: - Public Properties
    
    var dataTicket: [AviaFlight] = []
    var stateChanger: ((State) -> Void)?
    
    
    //MARK: - Private Properties
    
    private let ticketsNetworkService: TicketsNetworkServiceProtocol
    private let coordinator: TicketsCoordinatorProtocol
    private var state: State = .loading {
        didSet {
            self.stateChanger?(state)
        }
    }
    
    
    //MARK: - LifeCycle
    
    init(ticketsNetworkService: TicketsNetworkServiceProtocol, coordinator: TicketsCoordinatorProtocol) {
        self.ticketsNetworkService = ticketsNetworkService
        self.coordinator = coordinator
    }
}



//MARK: - TicketsViewModelProtocol

extension TicketsViewModel: TicketsViewModelProtocol {
    
    func getTickets() {
        state = .loading
        ticketsNetworkService.getTicketRequest { [weak self] result in
            guard let self else { return }
            switch result {
                
            case .success(let aviaFlights):
                self.dataTicket = aviaFlights
                DispatchQueue.main.async {
                    self.state = .loaded
                }
                
            case .failure(let error):
                switch error {
                case .invalidInternet:
                    DispatchQueue.main.async {
                        self.state = .loadedError(error: "Нет соединения с интернетом")
                    }
                    
            default:
                    DispatchQueue.main.async {
                        self.state = .loadedError(error: "Нет соединения с сервером")
                    }
                }
            }
        }
    }
    
    func didTapCell(index: IndexPath) {
        coordinator.pushDetailViewController(ticket: dataTicket[index.item], delegate: self)
    }
    
    func didTapLikeInCell(ticket: AviaFlight) {
        guard let index = dataTicket.firstIndex(where: {$0.searchToken == ticket.searchToken}) else {return}
        dataTicket[index].likeCheck.toggle()
        state = .reloadCell(index: IndexPath(item: index, section: 0))
    }
}



//MARK: - TicketChangeStateDelegateProtocol

extension TicketsViewModel: TicketChangeStateDelegateProtocol {
    func didChangeStateTickets(ticket: AviaFlight) {
        guard let index = dataTicket.firstIndex(where: {$0.searchToken == ticket.searchToken}) else {return}
        dataTicket[index].likeCheck.toggle()
    }
}
