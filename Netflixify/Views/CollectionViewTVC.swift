//
//  CollectionViewTVC.swift
//  Netflixify
//
//  Created by Nwachukwu Ejiofor on 09/07/2022.
//

import UIKit

class CollectionViewTVC: UITableViewCell {

    static let identifier = String(describing: CollectionViewTVC.self)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
