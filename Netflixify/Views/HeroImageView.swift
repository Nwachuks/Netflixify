//
//  HeroImageView.swift
//  Netflixify
//
//  Created by Nwachukwu Ejiofor on 09/07/2022.
//

import UIKit
import SDWebImage

protocol HeroShowDelegate: AnyObject {
    func showPreview(using show: Show, and previewUrl: String)
}

class HeroImageView: UIView {
    
    private var selectedHeroShow: Show?
    
    weak var heroShowDelegate: HeroShowDelegate!
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let centerView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
        addGradient()
        addSubview(centerView)
        addSubview(playButton)
        addSubview(downloadButton)
        downloadButton.addTarget(self, action: #selector(downloadShow), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(playShow), for: .touchUpInside)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = self.bounds
        centerView.frame = CGRect(x: self.bounds.width/2, y: 0, width: 1, height: self.bounds.height)
    }
    
    private func applyConstraints() {
        let playButtonConstraints = [
            playButton.trailingAnchor.constraint(equalTo: centerView.leadingAnchor, constant: -20),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant:  -20),
            playButton.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let downloadButtonConstraints = [
            downloadButton.leadingAnchor.constraint(equalTo: centerView.trailingAnchor, constant: 20),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant:  -20),
            downloadButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = self.bounds
        layer.addSublayer(gradientLayer)
    }
    
    public func configureHeroImage(using show: Show?) {
        guard let show = show, let poster = show.posterPath, let url = URL(string: "\(Constants.IMAGE_BASE_URL)\(poster)") else { return }
        selectedHeroShow = show
        heroImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "HeroImage"))
    }
    
    @objc func downloadShow() {
        guard let show = selectedHeroShow else { return }
        DataPersistenceManager.instance.downloadShow(using: show) { result in
            switch result {
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name("download"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func playShow() {
        guard let show = selectedHeroShow else { return }
        guard let showName = show.originalName ?? show.originalTitle else { return }
        
        NetworkManager.instance.getMovieFromYoubtube(using: "\(showName) trailer") { [weak self] result in
            switch result {
            case .success(let video):
                self?.heroShowDelegate.showPreview(using: show, and: video.id.videoId)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
