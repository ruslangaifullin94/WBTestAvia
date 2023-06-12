//
//  MainViewController.swift
//  WBTestAvia
//
//  Created by Руслан Гайфуллин on 15.05.2023.
//

import UIKit

protocol TicketsViewControllerDelegate: AnyObject {
    func reload(ticket: AviaFlight)
}

final class TicketsViewController: UIViewController {
    
    //MARK: - Private Properties
    
    private var viewModel: TicketsViewModelProtocol
    
    private lazy var compositionalLayout: UICollectionViewLayout = {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            return self?.makeTicketCollectionViewLayoutSection()
        }
    }()
    
    private lazy var aviaTicketCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TicketViewCell.self, forCellWithReuseIdentifier: TicketViewCell.reuseId)
        return collectionView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.tintColor = .white
        return activityIndicator
    }()
    
    private lazy var activityIndicatorBackground: UIView = {
        let loader = UIView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.backgroundColor = .white
        loader.alpha = 0
        return loader
    }()
    
    
    //MARK: - LifeCycle
    
    init(viewModel: TicketsViewModel) {
        self.viewModel = viewModel
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
        bindingModel()
        viewModel.getTickets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        aviaTicketCollectionView.reloadData()
    }
    
    
    //MARK: - Private Metods
    
    private func setupView() {
        title = "Авиарейсы"
        view.backgroundColor = UIColor(named: "purple2")
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupSubviews() {
        view.addSubview(aviaTicketCollectionView)
        view.addSubview(activityIndicatorBackground)
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraits() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            aviaTicketCollectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            aviaTicketCollectionView.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            aviaTicketCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            aviaTicketCollectionView.rightAnchor.constraint(equalTo: safeArea.rightAnchor),
            
            activityIndicatorBackground.topAnchor.constraint(equalTo: safeArea.topAnchor),
            activityIndicatorBackground.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            activityIndicatorBackground.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            activityIndicatorBackground.rightAnchor.constraint(equalTo: safeArea.rightAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor)
        ])
    }
    
    private func bindingModel() {
        viewModel.stateChanger = { [weak self] state in
            guard let self else {return}
            switch state {
            case .loading:
                activityIndicatorEnabled(true)
            case .loaded:
                activityIndicatorEnabled(false)
                aviaTicketCollectionView.reloadData()
            case .loadedError(error: let error):
                activityIndicatorEnabled(false)
                AlertNotifications.shared.presentAlert(for: self, error)
            case .reloadCell(index: let index):
                aviaTicketCollectionView.reloadItems(at: [index])
            }
        }
    }
    
    private func activityIndicatorEnabled(_ isTrue: Bool) {
        switch isTrue {
        case true:
            activityIndicator.startAnimating()
            activityIndicatorBackground.alpha = 1
        case false:
            activityIndicator.stopAnimating()
            activityIndicatorBackground.alpha = 0
        }
    }
    
    private func makeTicketCollectionViewLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(
            layoutSize: itemSize
        )
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 8,
            leading: 8,
            bottom: 0,
            trailing: 8
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.3)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}



//MARK: - UICollectionViewDataSource

extension TicketsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.dataTicket.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TicketViewCell.reuseId, for: indexPath) as? TicketViewCell else {return UICollectionViewCell()}
        
        let model = viewModel.dataTicket[indexPath.row]
        cell.setupCollectionCell(model)
        cell.delegate = self
        return cell
    }
}



//MARK: - UICollectionViewDelegate

extension TicketsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didTapCell(index: indexPath)
    }
}



//MARK: - TicketsViewControllerDelegate

extension TicketsViewController: TicketsViewControllerDelegate {
    
    func reload(ticket: AviaFlight) {
        viewModel.didTapLikeInCell(ticket: ticket)
    }
}
