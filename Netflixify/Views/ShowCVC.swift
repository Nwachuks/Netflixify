//
//  ShowCVC.swift
//  Netflixify
//
//  Created by Nwachukwu Ejiofor on 11/07/2022.
//

import UIKit
import SDWebImage

class ShowCVC: UICollectionViewCell {
    
    static let identifier = String(describing: ShowCVC.self)
    
    private let posterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImage.frame = contentView.bounds
    }
    
    public func configure(with urlString: String) {
        let imageUrl = URL(string: "\(Constants.IMAGE_BASE_URL)\(urlString)")
        posterImage.sd_setImage(with: imageUrl)
    }
}
