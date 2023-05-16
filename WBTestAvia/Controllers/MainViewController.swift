//
//  MainViewController.swift
//  WBTestAvia
//
//  Created by Руслан Гайфуллин on 15.05.2023.
//

import UIKit

protocol MainViewControllerDelegate: AnyObject {
    func reload()
}

final class MainViewController: UIViewController {
    
    //MARK: - Private Properties
    
    private var data: [AviaFlight] = []
    private let networkApi: NetworkApi
    
    private lazy var aviaTicketCollectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 22, left: 15, bottom: 0, right: 15)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TicketViewCell.self, forCellWithReuseIdentifier: CellReuse.base.rawValue)
        return collectionView
    }()
    
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.tintColor = .white
        return activityIndicator
    }()
    
    private lazy var loader: UIView = {
        let loader = UIView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.backgroundColor = .white
        loader.alpha = 0
        return loader
    }()
    
    //MARK: - LifeCycle
    
    init(networkApi: NetworkApi) {
        self.networkApi = networkApi
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSubviews()
        setupConstraits()
        setupNetwork()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        aviaTicketCollectionView.reloadData()
    }
    //MARK: - Private Metods
    
    private func setupView() {
        view.backgroundColor = UIColor(named: "purple2")
    }
    
    private func setupSubviews() {
        view.addSubview(aviaTicketCollectionView)
        view.addSubview(loader)
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraits() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            aviaTicketCollectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            aviaTicketCollectionView.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            aviaTicketCollectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            aviaTicketCollectionView.rightAnchor.constraint(equalTo: safeArea.rightAnchor),
            
            loader.topAnchor.constraint(equalTo: safeArea.topAnchor),
            loader.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            loader.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            loader.rightAnchor.constraint(equalTo: safeArea.rightAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor)
            

        ])
    }
    
    private func setupNetwork() {
        
        startLoader(true)
        networkApi.getTicketRequest { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let tickets):
                for index in 0...tickets.flights.count-1 {
                    self.data.append(AviaFlight(cityArrival: tickets.flights[index].endCity, cityDeparture: tickets.flights[index].startCity.rawValue, price: tickets.flights[index].price, departureDate: tickets.flights[index].startDate, arrivalDate: tickets.flights[index].endDate.rawValue, likeCheck: false))
                }
                DispatchQueue.main.async {
                    self.startLoader(false)
                    self.aviaTicketCollectionView.reloadData()
                }
            case .failure(let error):
                    DispatchQueue.main.async {
                        self.startLoader(false)
                        self.presentAlert(error.errorDescription)
                    }
            }
        }
    }
    
    private func startLoader(_ isTrue: Bool) {
        if isTrue {
            activityIndicator.startAnimating()
            loader.alpha = 1
        } else {
            activityIndicator.stopAnimating()
            loader.alpha = 0
        }
    }


}

//MARK: - UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout{
    
    private var sideInset: CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width - 30
        
        return CGSize(width: width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        sideInset
    }
    
}

//MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellReuse.base.rawValue, for: indexPath) as? TicketViewCell else {return UICollectionViewCell()}
        
        let model = data[indexPath.row]
        cell.setupCollectionCell(model)
        cell.backgroundColor = .systemBackground
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ticketDetailViewController = DetailViewController(ticket: data[indexPath.item])
        self.navigationController?.pushViewController(ticketDetailViewController, animated: true)
    }
}

//MARK: - Other Extetnsions

extension MainViewController: MainViewControllerDelegate {
    func reload() {
        aviaTicketCollectionView.reloadData()
    }
}

extension MainViewController {
    func presentAlert(_ text: String) {
        let optionMenu = UIAlertController(title: "Ошибка", message: text, preferredStyle: .alert)
        let optionAction = UIAlertAction(title: "Ok", style: .default)
        optionMenu.addAction(optionAction)
        self.navigationController?.present(optionMenu, animated: true)
    }
}
