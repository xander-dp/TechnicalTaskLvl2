//
//  ViewController.swift
//  ShipsInfo
//
//  Created by Oleksandr Savchenko on 17.12.24.
//

import UIKit
import SwiftUI

final class ShipsListViewController: UITableViewController {
    private var dataSource: [ShipEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        dataSource = getHardcodedData()
    }
    
    private func configureTableView() {
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    @IBAction func refreshControllTriggered() {
        dataSource = getHardcodedData()
        self.tableView.reloadData()
        
        if let refreshControl = self.tableView.refreshControl {
            if refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            }
        }
    }
}

//MARK: UITableViewDataSource
extension ShipsListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell( withIdentifier: ShipTableViewCell.reuseIdentifier, for: indexPath)
        
        guard let shipCell = cell as? ShipTableViewCell else {
            return cell
        }
        
        shipCell.configureCell(with: dataSource[indexPath.row])
        
        return shipCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let sb = UIStoryboard(name: "Main", bundle: .main)
        let vc = sb.instantiateViewController(withIdentifier: "ShipDetailsViewController") as? ShipDetailsViewController
        
        guard let vc else { return }
        
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .pageSheet
        vc.entity = self.dataSource[indexPath.row]
        
        self.present(vc, animated: true)
    }
}

//MARK: UITableViewDelegate
extension ShipsListViewController {
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) {[weak self] (_, _, completionHandler) in
            
            self?.dataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = .lightGray
        deleteAction.image = UIImage(systemName: "trash")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

//TEMP hardcoded data
private extension ShipsListViewController {
    func getHardcodedData() -> [ShipEntity] {
        let jsonData = readLocalJSONFile(forName: "SampleRecords")
        if let data = jsonData {
            if let sampleRecordsList = parse(jsonData: data) {
                return sampleRecordsList
            } else {
                fatalError("unable to parse file")
            }
        } else {
            fatalError("unable to read file")
        }
    }
    
    func parse(jsonData: Data) -> [ShipEntity]? {
        do {
            let decodedData = try JSONDecoder().decode([ShipEntity].self, from: jsonData)
            return decodedData
        } catch {
            print("error: \(error)")
        }
        return nil
    }
    
    func readLocalJSONFile(forName name: String) -> Data? {
        do {
            if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                return data
            }
        } catch {
            print("error: \(error)")
        }
        return nil
    }
}
