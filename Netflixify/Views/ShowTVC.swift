//
//  ShowTVC.swift
//  Netflixify
//
//  Created by Nwachukwu Ejiofor on 11/07/2022.
//

import UIKit

class ShowTVC: UITableViewCell {

    static let identifier = String(describing: ShowTVC.self)
    
    private let showImagePoster: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(showImagePoster)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playButton)
        
        applyContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func applyContraints() {
        let showImagePosterConstraints = [
            showImagePoster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            showImagePoster.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            showImagePoster.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            showImagePoster.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let playButtonConstraints = [
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 30),
            playButton.heightAnchor.constraint(equalToConstant: 30)
        ]
        
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: showImagePoster.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -10),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(showImagePosterConstraints)
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
    }
    
    public func configure(using show: Show) {
        titleLabel.text = show.originalName ?? show.originalTitle ?? "Unknown title"
        
        guard let posterImage = show.posterPath else { return }
        let imageUrl = URL(string: "\(Constants.IMAGE_BASE_URL)\(posterImage)")
        showImagePoster.sd_setImage(with: imageUrl)
    }
}
