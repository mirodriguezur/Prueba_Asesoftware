//
//  ItemTableViewCell.swift
//  TestAsesoftware
//
//  Created by Michael Alexander Rodriguez Urbina on 4/02/24.
//

import UIKit
import Kingfisher

class ItemTableViewCell: UITableViewCell {
    let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let itemTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .regular, width: .condensed)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let itemAlbumId: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .regular, width: .standard)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Título:"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let albumIdLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "AlbumId:"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    static var identifier: String {
        get {
            "ItemTableViewCell"
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(itemImageView)
        addSubview(titleLabel)
        addSubview(itemTitle)
        addSubview(albumIdLabel)
        addSubview(itemAlbumId)
        
        NSLayoutConstraint.activate([
            itemImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            itemImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            itemImageView.heightAnchor.constraint(equalToConstant: 100),
            itemImageView.widthAnchor.constraint(equalToConstant: 100),
            itemImageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10),
            
            titleLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 5),
            titleLabel.topAnchor.constraint(equalTo: itemImageView.topAnchor, constant: 5),
            titleLabel.widthAnchor.constraint(equalToConstant: 78),
            
            albumIdLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 5),
            albumIdLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 52),
            albumIdLabel.widthAnchor.constraint(equalToConstant: 78),

            itemTitle.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            itemTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            itemTitle.topAnchor.constraint(equalTo: itemImageView.topAnchor, constant: 5),
                    
            itemAlbumId.leadingAnchor.constraint(equalTo: albumIdLabel.trailingAnchor, constant: 8),
            itemAlbumId.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            itemAlbumId.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 52),
            itemAlbumId.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -12)
        ])
    }
    
    func setupCell(with item: ItemEntity) {
        self.itemImageView.kf.setImage(with: item.thumbnailUrl)
        self.itemTitle.text = item.title
        self.itemAlbumId.text = String(item.id)
    }

}
