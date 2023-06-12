//
//  TicketViewCell.swift
//  WBTestAvia
//
//  Created by Руслан Гайфуллин on 15.05.2023.
//

import UIKit

final class TicketViewCell: UICollectionViewCell {
    
    static let reuseId = "BaseTicketViewCell_ReuseID"
    
    //MARK: - Public Properties
    
    weak var delegate: TicketsViewControllerDelegate?
    
    //MARK: - Private Properties
    
    private var ticket: AviaFlight?
  
    private lazy var cityOfDeparture: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cityOfArrival: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateOfStart: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateOfReturn: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var price: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.backgroundColor = UIColor(named: "purple2")
        label.layer.cornerRadius = 5
        label.textColor = .white
        label.clipsToBounds = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var likeChecked: UIImageView = {
       let image = UIImageView()
        image.isUserInteractionEnabled = true
        image.tintColor = UIColor(named: "purple4")
        image.translatesAutoresizingMaskIntoConstraints = false

        return image
    }()
    
    private lazy var departureIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "airplane.departure")
        icon.translatesAutoresizingMaskIntoConstraints = false

        return icon
    }()
    
    private lazy var arrivalIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "airplane.arrival")
        icon.translatesAutoresizingMaskIntoConstraints = false

        return icon
    }()
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        setupSubviewsAndLayout()
        setupConstraits()
        setupGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            toggleIsHighlighted()
        }
    }
    
    
    //MARK: - Public Methods
    
    func setupCollectionCell(_ ticket: AviaFlight) {
        let date = DateManager.shared
        self.ticket = ticket
        price.text = "\(ticket.price) ₽"
        dateOfStart.text = date.getDateToString(from: ticket.departureDate, dateFormat: "MM-dd-yyyy HH:mm")
        cityOfDeparture.text = ticket.cityDeparture
        cityOfArrival.text = ticket.cityArrival
        dateOfReturn.text = date.getDateToString(from: ticket.arrivalDate, dateFormat: "MM-dd-yyyy HH:mm")
        likeChecked.image = UIImage(systemName: ticket.likeCheck ? "heart.fill" : "heart")
    }
    
    
    //MARK: - Private Methods
    
    private func setupView() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
    }
    
    private func setupSubviewsAndLayout() {
        contentView.addSubview(cityOfDeparture)
        contentView.addSubview(cityOfArrival)
        contentView.addSubview(dateOfStart)
        contentView.addSubview(dateOfReturn)
        contentView.addSubview(price)
        contentView.addSubview(likeChecked)
        contentView.addSubview(departureIcon)
        contentView.addSubview(arrivalIcon)
        
    }
    
    private func setupConstraits() {
        NSLayoutConstraint.activate([
            price.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            price.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            price.widthAnchor.constraint(equalToConstant: 80),
            price.heightAnchor.constraint(equalToConstant: 30),
            
            likeChecked.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            likeChecked.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            likeChecked.widthAnchor.constraint(equalToConstant: 45),
            likeChecked.heightAnchor.constraint(equalToConstant: 40),
            
            dateOfStart.topAnchor.constraint(equalTo: price.bottomAnchor, constant: 20),
            dateOfStart.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateOfStart.heightAnchor.constraint(equalToConstant: 15),
            
            departureIcon.topAnchor.constraint(equalTo: dateOfStart.bottomAnchor, constant: 10),
            departureIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            departureIcon.heightAnchor.constraint(equalToConstant: 20),
            
            cityOfDeparture.topAnchor.constraint(equalTo: departureIcon.topAnchor),
            cityOfDeparture.leadingAnchor.constraint(equalTo: departureIcon.trailingAnchor, constant: 5),
            cityOfDeparture.widthAnchor.constraint(equalToConstant: 140),
            cityOfDeparture.heightAnchor.constraint(equalToConstant: 20),
            
            cityOfArrival.topAnchor.constraint(equalTo: cityOfDeparture.bottomAnchor, constant: 20),
            cityOfArrival.leadingAnchor.constraint(equalTo: cityOfDeparture.leadingAnchor),
            cityOfArrival.heightAnchor.constraint(equalToConstant: 20),
            
            arrivalIcon.leadingAnchor.constraint(equalTo: departureIcon.leadingAnchor),
            arrivalIcon.topAnchor.constraint(equalTo: cityOfArrival.topAnchor),
            arrivalIcon.heightAnchor.constraint(equalToConstant: 20),
            
            dateOfReturn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            dateOfReturn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
    }
    
    private func setupGestureRecognizer() {
        let tapGestureStatus = UITapGestureRecognizer(target: self, action: #selector(didTapLike))
        likeChecked.addGestureRecognizer(tapGestureStatus)
    }
    
   private func toggleIsHighlighted() {
       UIView.animate(
        withDuration: 0.1,
        delay: 0.1,
        options: [.curveEaseOut],
        animations: {
                self.alpha = self.isHighlighted ? 0.9 : 1.0
                self.transform = self.isHighlighted ?
                    CGAffineTransform.identity.scaledBy(x: 0.97, y: 0.97) :
                    CGAffineTransform.identity
            })
        }
    
    @objc private func didTapLike() {
        guard let ticket else {return}
        ticket.likeCheck.toggle()
        delegate?.reload(ticket: ticket)
    }
}
