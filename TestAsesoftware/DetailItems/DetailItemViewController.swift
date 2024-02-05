//
//  DetailItemViewController.swift
//  TestAsesoftware
//
//  Created by Michael Alexander Rodriguez Urbina on 4/02/24.
//

import Foundation
import UIKit
import Kingfisher

protocol DetailItemViewProtocol: AnyObject {
    func update(with item: ItemEntity)
}

class DetailItemViewController: UIViewController, DetailItemViewProtocol {
    let detailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Título:"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let albumIdLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "AlbumId:"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let idLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Id:"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let detailTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 32, weight: .bold, width: .condensed)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let detailId: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .regular, width: .standard)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let albumId: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .regular, width: .standard)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Eliminar", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let presenter: DetailItemPresenterInput
    
    init(presenter: DetailItemPresenterInput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not een implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter.onViewAppear()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(detailImageView)
        view.addSubview(titleLabel)
        view.addSubview(albumIdLabel)
        view.addSubview(idLabel)
        view.addSubview(detailTitle)
        view.addSubview(detailId)
        view.addSubview(albumId)
        view.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            detailImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 25),
            detailImageView.heightAnchor.constraint(equalToConstant: 300),
            detailImageView.widthAnchor.constraint(equalToConstant: 300),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: detailImageView.bottomAnchor, constant: 20),
            titleLabel.widthAnchor.constraint(equalToConstant: 100),
            
            detailTitle.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 20),
            detailTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            detailTitle.topAnchor.constraint(equalTo: detailImageView.bottomAnchor, constant: 20),
            
            idLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            idLabel.topAnchor.constraint(equalTo: detailTitle.bottomAnchor, constant: 20),
            idLabel.widthAnchor.constraint(equalToConstant: 100),
            
            detailId.leadingAnchor.constraint(equalTo: idLabel.trailingAnchor, constant: 20),
            detailId.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            detailId.topAnchor.constraint(equalTo: detailTitle.bottomAnchor, constant: 20),
            
            albumIdLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            albumIdLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 20),
            albumIdLabel.widthAnchor.constraint(equalToConstant: 100),
            
            albumId.leadingAnchor.constraint(equalTo: albumIdLabel.trailingAnchor, constant: 20),
            albumId.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            albumId.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 20),
            
            deleteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 200)
        ])
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    @objc func deleteButtonTapped() {
        print("Botón Eliminar presionado")
    }
    
    //MARK: - DetailItemPresenterProtocol
    func update(with item: ItemEntity) {
        detailImageView.kf.setImage(with: item.url)
        detailTitle.text = item.title
        detailId.text = String(item.id)
        albumId.text = String(item.id)
    }
}
