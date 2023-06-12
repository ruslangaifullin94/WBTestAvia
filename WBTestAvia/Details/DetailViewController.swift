//
//  DetailViewController.swift
//  WBTestAvia
//
//  Created by Руслан Гайфуллин on 15.05.2023.
//

import UIKit

final class DetailViewController: UIViewController {
    
    //MARK: - Private Properties
    
    private var viewModel: DetailViewModelProtocol
    
    private let date = DateManager.shared
        
    private lazy var cityOfDeparture: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.text = viewModel.ticket.cityDeparture
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cityOfArrival: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.text = viewModel.ticket.cityArrival
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateOfStart: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.text = date.getDateToString(from: viewModel.ticket.departureDate, dateFormat: "MM-dd-yyyy HH:mm")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateOfReturn: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.text = date.getDateToString(from: viewModel.ticket.arrivalDate, dateFormat: "MM-dd-yyyy HH:mm")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var price: PriceButtom = {
        var config = UIButton.Configuration.filled()
        config.title = "Купить за \(viewModel.ticket.price)"
        config.image = UIImage(systemName: "cart")
        config.imagePlacement = .trailing
        config.imagePadding = 10
        config.baseBackgroundColor = UIColor(named: "purple2")
        config.cornerStyle = .medium

        let button = PriceButtom(configuration: config)
        button.sizeToFit()
        button.tintColor = .white
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTargetToButtonForAnimation()
        return button
    }()
    
    private lazy var likeChecked: UIImageView = {
       let image = UIImageView()
        image.isUserInteractionEnabled = true
        image.tintColor = UIColor(named: "purple4")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: viewModel.ticket.likeCheck ? "heart.fill" : "heart")
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
    
    init(viewModel: DetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSubviewsAndLayout()
        setupConstraits()
        setupGestureRecognizer()
        bindingModel()
    }

    
    //MARK: - Private Methods
    
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
    }
    
    private func setupConstraits() {
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            likeChecked.topAnchor.constraint(equalTo: price.topAnchor),
            likeChecked.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            likeChecked.widthAnchor.constraint(equalToConstant: 35),
            likeChecked.heightAnchor.constraint(equalToConstant: 30),
            
            dateOfStart.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 40),
            dateOfStart.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            dateOfStart.heightAnchor.constraint(equalToConstant: 15),
            
            departureIcon.topAnchor.constraint(equalTo: dateOfStart.bottomAnchor, constant: 10),
            departureIcon.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
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
            
            dateOfReturn.topAnchor.constraint(equalTo: cityOfArrival.bottomAnchor, constant: 20),
            dateOfReturn.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            
            price.topAnchor.constraint(equalTo: dateOfReturn.bottomAnchor, constant: 20),
            price.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            price.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupGestureRecognizer() {
        let tapGestureStatus = UITapGestureRecognizer(target: self, action: #selector(didTapLike))
        likeChecked.addGestureRecognizer(tapGestureStatus)
    }
    
    private func bindingModel() {
        viewModel.stateChanger = { [weak self] state in
            guard let self else {return}
            switch state {
            case .didLikeToggle(let before):
                likeChecked.image = UIImage(systemName: before ? "heart" : "heart.fill" )
            }
        }
    }
    
    @objc private func didTapLike() {
        viewModel.didTapLike()
    }
}
