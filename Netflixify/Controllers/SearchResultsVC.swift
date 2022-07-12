//
//  SearchResultsVC.swift
//  Netflixify
//
//  Created by Nwachukwu Ejiofor on 11/07/2022.
//

import UIKit

protocol SearchResultsDelegate: AnyObject {
    func searchResultsDelegateTapped(_ show: Show, _ previewUrl: String)
}

class SearchResultsVC: UIViewController {
    
    public var shows = [Show]()
    
    public weak var searchResultsDelegate: SearchResultsDelegate!
    
    public let searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3  - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ShowCVC.self, forCellWithReuseIdentifier: ShowCVC.identifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
        view.addSubview(searchResultsCollectionView)
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
    }
}

extension SearchResultsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
                self?.searchResultsDelegate.searchResultsDelegateTapped(show, video.id.videoId)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
