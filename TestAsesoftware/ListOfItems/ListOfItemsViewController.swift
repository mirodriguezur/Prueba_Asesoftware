//
//  ListOfItemsViewController.swift
//  TestAsesoftware
//
//  Created by Michael Alexander Rodriguez Urbina on 4/02/24.
//

import Foundation
import UIKit

protocol ListOfItemsViewControllerProtocol: AnyObject {
    func update()
    func showSaveCacheAlert()
    func showCheckCacheAlert()
}

class ListOfItemsViewController: UIViewController, ListOfItemsViewControllerProtocol {
    private var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.estimatedRowHeight = 120
        table.rowHeight = UITableView.automaticDimension
        table.register(ItemTableViewCell.self, forCellReuseIdentifier: ItemTableViewCell.identifier)
        return table
    }()

    private var presenter: ListOfItemsPresenterInput?
    
    init(presenter: ListOfItemsPresenterInput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.onViewAppear()
    }

    private func setupView() {
        setupTableView()
    }
        
    func update() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showSaveCacheAlert() {
        let alert = UIAlertController(title: "Error", message: "Algo paso al intentar guardar en cache la información, vuelva a intentar", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showCheckCacheAlert() {
        let alert = UIAlertController(title: "Error", message: "No se puedo consultar la base de datos, vuelva a intentarlo", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}

extension ListOfItemsViewController: UITableViewDelegate, UITableViewDataSource {
    func setupTableView() {
        view.addSubview(tableView)
        registerCell()
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        tableView.dataSource = self
        tableView.delegate = self
    }
        
    func registerCell(){
        tableView.register(ItemTableViewCell.self, forCellReuseIdentifier: ItemTableViewCell.identifier)
    }
        
    //MARK: TableViewDelegate
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.listOfLocalItems.count ?? 0
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.identifier, for: indexPath) as? ItemTableViewCell,
                let itemsModel = presenter?.listOfLocalItems[indexPath.row]
        else { return UITableViewCell()}
                
        cell.setupCell(with: itemsModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let itemsModel = presenter?.listOfLocalItems[indexPath.row] else { return }
        presenter?.handleCellSelected(with: itemsModel)
    }
}

