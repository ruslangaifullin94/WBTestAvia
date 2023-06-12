//
//  DetailViewModel.swift
//  WBTestAvia
//
//  Created by Руслан Гайфуллин on 09.06.2023.
//

import Foundation

protocol DetailViewModelProtocol {
    var ticket: AviaFlight {get}
    var stateChanger: ((DetailViewModel.State) -> Void)? {get set}
    func didTapLike()
}

final class DetailViewModel {
    
    enum State {
        case didLikeToggle(before: Bool)
    }
    
    
    //MARK: - Public Properties
    
    var ticket: AviaFlight
    
    var stateChanger: ((State) -> Void)?
    
    
    //MARK: - Private Prperties
    
    private var state: State = .didLikeToggle(before: false) {
        didSet {
            self.stateChanger?(state)
        }
    }
    
    private weak var delegate: TicketChangeStateDelegateProtocol?
    
    
    //MARK: - Init

    init(ticket: AviaFlight, delegate: TicketChangeStateDelegateProtocol?) {
        self.ticket = ticket
        self.delegate = delegate
    }
    
}


//MARK: - DetailViewModelProtocol

extension DetailViewModel: DetailViewModelProtocol {
    func didTapLike() {
        state = .didLikeToggle(before: ticket.likeCheck)
        delegate?.didChangeStateTickets(ticket: ticket)
    }
}
