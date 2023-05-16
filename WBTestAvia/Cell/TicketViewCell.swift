//
//  TicketViewCell.swift
//  WBTestAvia
//
//  Created by Руслан Гайфуллин on 15.05.2023.
//

import UIKit
import SnapKit


final class TicketViewCell: UICollectionViewCell {
    
    weak var delegate: MainViewControllerDelegate?
    
    //MARK: - Private Properties
    
    private var ticket: AviaFlight?
    
  
    private lazy var cityOfDeparture: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private lazy var cityOfArrival: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        
        return label
    }()
    
    private lazy var dateOfStart: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var dateOfReturn: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .systemGray

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
        return label
    }()
     

    
    private lazy var likeChecked: UIImageView = {
       let image = UIImageView()
        image.isUserInteractionEnabled = true
        image.tintColor = UIColor(named: "purple4")
        return image
    }()
    
    private lazy var departureIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "airplane.departure")
        return icon
    }()
    
    private lazy var arrivalIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "airplane.arrival")
        return icon
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupSubviewsAndLayout()
        setupGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override var isHighlighted: Bool {
        didSet {
            toggleIsHighlighted()
        }
    }
    
    //MARK: - Private Properties
    
    private func setupSubviewsAndLayout() {
        contentView.addSubview(cityOfDeparture)
        contentView.addSubview(cityOfArrival)
        contentView.addSubview(dateOfStart)
        contentView.addSubview(dateOfReturn)
        contentView.addSubview(price)
        contentView.addSubview(likeChecked)
        contentView.addSubview(departureIcon)
        contentView.addSubview(arrivalIcon)
        
        price.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(20)
            make.centerX.equalTo(contentView)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        likeChecked.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).inset(20)
            make.width.equalTo(45)
            make.height.equalTo(40)
        }
        dateOfStart.snp.makeConstraints { make in
            make.top.equalTo(price.snp.bottom).offset(20)
            make.left.equalTo(contentView).offset(20)
            make.height.equalTo(15)
        }
        cityOfDeparture.snp.makeConstraints { make in
            make.top.equalTo(dateOfStart.snp.bottom).offset(10)
            make.left.equalTo(departureIcon.snp.right).offset(5)
            make.width.equalTo(140)
            make.height.equalTo(20)
        }
        departureIcon.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(20)
            make.top.equalTo(cityOfDeparture.snp.top)
            make.height.equalTo(20)
        }
        
        arrivalIcon.snp.makeConstraints { make in
            make.left.equalTo(departureIcon.snp.left)
            make.top.equalTo(cityOfArrival.snp.top)
            make.height.equalTo(20)
        }
        cityOfArrival.snp.makeConstraints { make in
            make.top.equalTo(cityOfDeparture.snp.bottom).offset(20)
            make.left.equalTo(cityOfDeparture.snp.left)
            make.height.equalTo(20)
        }
        dateOfReturn.snp.makeConstraints { make in
            make.bottom.equalTo(contentView).inset(20)
            make.left.equalTo(contentView).offset(20)
        }

    }
    
    private func setupGestureRecognizer() {
        let tapGestureStatus = UITapGestureRecognizer(target: self, action: #selector(didTapButton))
        tapGestureStatus.numberOfTapsRequired = 1
        likeChecked.addGestureRecognizer(tapGestureStatus)
    }
    
   private func toggleIsHighlighted() {
       UIView.animate(withDuration: 0.1, delay: 0.1, options: [.curveEaseOut], animations: {
                self.alpha = self.isHighlighted ? 0.9 : 1.0
                self.transform = self.isHighlighted ?
                    CGAffineTransform.identity.scaledBy(x: 0.97, y: 0.97) :
                    CGAffineTransform.identity
            })
        }
    @objc private func didTapButton() {
        if ticket?.likeCheck != true {
            ticket?.likeCheck = true
        } else {
            ticket?.likeCheck = false
        }
        delegate?.reload()
    }
    
    //MARK: - Public Metods
    
    func setupCollectionCell(_ ticket: AviaFlight) {
        self.ticket = ticket
        price.text = String(ticket.price) + " ₽"
        dateOfStart.text = ticket.departureDate
        cityOfDeparture.text = ticket.cityDeparture
        cityOfArrival.text = ticket.cityArrival
        dateOfReturn.text = ticket.arrivalDate
        if ticket.likeCheck {
            likeChecked.image = UIImage(systemName: "heart.fill")
        } else {
            likeChecked.image = UIImage(systemName: "heart")
        }
    }
}
