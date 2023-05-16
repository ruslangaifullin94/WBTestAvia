//
//  DetailViewController.swift
//  WBTestAvia
//
//  Created by Руслан Гайфуллин on 15.05.2023.
//

import UIKit
import SnapKit

final class DetailViewController: UIViewController {
    
    //MARK: - Private Properties
    
    private var ticket: AviaFlight?
    
    private lazy var cityOfDeparture: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.text = ticket?.cityDeparture
        return label
    }()
    
    private lazy var cityOfArrival: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.text = ticket?.cityArrival
        return label
    }()
    
    private lazy var dateOfStart: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.text = ticket?.departureDate
        return label
    }()
    
    private lazy var dateOfReturn: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.text = ticket?.arrivalDate
        return label
    }()
    
    private lazy var price: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Купить за " + String(ticket!.price)
        config.image = UIImage(systemName: "cart")
        config.imagePlacement = .trailing
        config.imagePadding = 10
        config.baseBackgroundColor = UIColor(named: "purple2")
        config.cornerStyle = .medium

        let button = UIButton(configuration: config)
        button.sizeToFit()
        button.tintColor = .white
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var likeChecked: UIImageView = {
       let image = UIImageView()
        image.isUserInteractionEnabled = true
        image.tintColor = UIColor(named: "purple4")

        if ticket!.likeCheck {
            image.image = UIImage(systemName: "heart.fill")
        } else {
            image.image = UIImage(systemName: "heart")
        }
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
    
    //MARK: - LifeCycle
    
    init(ticket: AviaFlight) {
        super.init(nibName: nil, bundle: nil)
        self.ticket = ticket
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSubviewsAndLayout()
        setupGestureRecognizer()
        price.addTargetToButtonForAnimation()

    }

    //MARK: - Private Metods
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupSubviewsAndLayout() {
        view.addSubview(cityOfDeparture)
        view.addSubview(cityOfArrival)
        view.addSubview(dateOfStart)
        view.addSubview(dateOfReturn)
        view.addSubview(price)
        view.addSubview(likeChecked)
        view.addSubview(departureIcon)
        view.addSubview(arrivalIcon)
        
        price.snp.makeConstraints { make in
            make.top.equalTo(dateOfReturn.snp.bottom).offset(20)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(40)
        }
        likeChecked.snp.makeConstraints { make in
            make.top.equalTo(price.snp.top)
            make.right.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(45)
            make.height.equalTo(40)
        }
        dateOfStart.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(15)
        }
        cityOfDeparture.snp.makeConstraints { make in
            make.top.equalTo(dateOfStart.snp.bottom).offset(20)
            make.left.equalTo(departureIcon.snp.right).offset(5)
            make.width.equalTo(140)
            make.height.equalTo(20)
        }
        departureIcon.snp.makeConstraints { make in
            make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
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
            make.top.equalTo(cityOfArrival.snp.bottom).offset(20)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
        }

    }
    
    private func setupGestureRecognizer() {
        let tapGestureStatus = UITapGestureRecognizer(target: self, action: #selector(didTapButton))
        tapGestureStatus.numberOfTapsRequired = 1
        likeChecked.addGestureRecognizer(tapGestureStatus)
    }
    
    
    @objc private func didTapButton() {
        if ticket?.likeCheck != true {
            ticket?.likeCheck = true
            likeChecked.image = UIImage(systemName: "heart.fill")
        } else {
            ticket?.likeCheck = false
            likeChecked.image = UIImage(systemName: "heart")
        }
    }
}

//MARK: - Extensions

extension UIButton {
    func addTargetToButtonForAnimation() {
        addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
    }

    @objc private func animateDown(sender: UIButton) {
        animate(sender, transform: CGAffineTransform.identity.scaledBy(x: 0.6, y: 0.6))
    }

    @objc private func animateUp(sender: UIButton) {
        animate(sender, transform: .identity)
    }

    private func animate(_ button: UIButton, transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3,
                       options: .curveEaseInOut,
                       animations: {
                        button.transform = transform
            }, completion: nil)
    }
    
}

