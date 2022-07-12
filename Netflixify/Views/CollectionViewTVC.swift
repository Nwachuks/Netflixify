//
//  CollectionViewTVC.swift
//  Netflixify
//
//  Created by Nwachukwu Ejiofor on 09/07/2022.
//

import UIKit

protocol CollectionViewTVCDelegate: AnyObject {
    func collectionViewTVCTapped(_ cell: CollectionViewTVC, _ show: Show, _ previewUrl: String)
}

class CollectionViewTVC: UITableViewCell {

    static let identifier = String(describing: CollectionViewTVC.self)
    
    weak var collectionViewTVCDelegate: CollectionViewTVCDelegate!
    
    private var shows = [Show]()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 200)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.register(ShowCVC.self, forCellWithReuseIdentifier: ShowCVC.identifier)
        return collection
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    public func configure(using shows: [Show]) {
        self.shows = shows
        DispatchQueue.main.async { [ weak self] in
            self?.collectionView.reloadData()
        }
    }
    
}

extension CollectionViewTVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowCVC.identifier, for: indexPath) as? ShowCVC else { return UICollectionViewCell() }
        guard let urlString = shows[indexPath.row].posterPath else { return cell }
        cell.configure(with: urlString)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let show = shows[indexPath.row]
        guard let showName = show.originalName ?? show.originalTitle else { return }
        
        NetworkManager.instance.getMovieFromYoubtube(using: "\(showName) trailer") { [weak self] result in
            switch result {
            case .success(let video):
                self?.collectionViewTVCDelegate.collectionViewTVCTapped(self!, show, video.id.videoId)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
