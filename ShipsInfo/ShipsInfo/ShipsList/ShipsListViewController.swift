//
//  ViewController.swift
//  ShipsInfo
//
//  Created by Oleksandr Savchenko on 17.12.24.
//

import UIKit
import Combine

protocol ShipsViewControllerDelegate: AnyObject {
    func didSelectItem(_ item: ShipEntity)
    func viewControllerIsDeiniting(_ sender: ShipsListViewController)
}

final class ShipsListViewController: UITableViewController {
    weak var delegate: ShipsViewControllerDelegate?
    
    private var cancellables = Set<AnyCancellable>()
    
    private static let storyboardName = "Main"
    private var viewModel: ShipsListViewModel!
    
    static func instantiate(viewModel: ShipsListViewModel) -> ShipsListViewController {
        let storyboard = UIStoryboard(name: Self.storyboardName, bundle: nil)
        let identifier = String(describing: ShipsListViewController.self)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as! ShipsListViewController
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        bindViewModel()
        self.viewModel?.getData()
        self.viewModel?.viewRequestedRefresh()
    }
    
    private func configureTableView() {
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func bindViewModel() {
        guard let viewModel else { return }
        
        viewModel.$ships
            .receive(on: DispatchQueue.main)
            .sink { [weak tableView] _ in
                if let refreshControl = tableView?.refreshControl {
                    if refreshControl.isRefreshing {
                        refreshControl.endRefreshing()
                    }
                }
                
                tableView?.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$selectedEntity
            .receive(on: DispatchQueue.main)
            .sink { [weak delegate] selected in
                if let selected {
                    delegate?.didSelectItem(selected)
                }
            }
            .store(in: &cancellables)
    }
    
    @IBAction func refreshControllTriggered() {
        self.viewModel?.viewRequestedRefresh()
    }
    
    deinit {
        self.delegate?.viewControllerIsDeiniting(self)
    }
}

//MARK: UITableViewDataSource
extension ShipsListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel?.ships.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell( withIdentifier: ShipTableViewCell.reuseIdentifier, for: indexPath)
        
        guard let shipCell = cell as? ShipTableViewCell,
              let viewModel
        else {
            return cell
        }
        
        shipCell.configureCell(with: viewModel.ships[indexPath.row])
        
        return shipCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
        self.viewModel?.viewRequestedSelection(at: indexPath.row)
    }
}

//MARK: UITableViewDelegate
extension ShipsListViewController {
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) {[weak self] (_, _, completionHandler) in
            self?.viewModel?.viewRequestedDeletion(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = .lightGray
        deleteAction.image = UIImage(systemName: "trash")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
