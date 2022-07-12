//
//  TopSearchesVC.swift
//  Netflixify
//
//  Created by Nwachukwu Ejiofor on 24/05/2022.
//

import UIKit

class TopSearchesVC: UIViewController {
    
    private var shows = [Show]()

    private let searchTable: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.register(ShowTVC.self, forCellReuseIdentifier: ShowTVC.identifier)
        return table
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsVC())
        controller.searchBar.placeholder = "Search for a movie"
        controller.searchBar.searchBarStyle = .prominent
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .black
        // Do any additional setup after loading the view.
        searchTable.delegate = self
        searchTable.dataSource = self
        view.addSubview(searchTable)
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        
        fetchDiscoverMovies()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        searchTable.frame = view.bounds
    }

    private func fetchDiscoverMovies() {
        NetworkManager.instance.getDiscoverMovies { [weak self] results in
            switch results {
            case .success(let shows):
                self?.shows = shows
                DispatchQueue.main.async {
                    self?.searchTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension TopSearchesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ShowTVC.identifier, for: indexPath) as? ShowTVC else { return UITableViewCell() }
        cell.configure(using: shows[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let show = shows[indexPath.row]
        guard let showName = show.originalName ?? show.originalTitle else { return }
        
        NetworkManager.instance.getMovieFromYoubtube(using: "\(showName) trailer") { [weak self] result in
            switch result {
            case .success(let video):
                DispatchQueue.main.async {
                    let vc = ShowPreviewVC()
                    vc.configure(using: show, previewUrl: video.id.videoId)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension TopSearchesVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let query = searchBar.text, query.trimmingCharacters(in: .whitespaces).isNotEmpty, query.trimmingCharacters(in: .whitespaces).count >= 3, let resultsController = searchController.searchResultsController as? SearchResultsVC else { return }
        resultsController.searchResultsDelegate = self
        
        NetworkManager.instance.getSearchMovies(with: query.trimmingCharacters(in: .whitespaces)) { results in
            DispatchQueue.main.async {
                switch results {
                case .success(let shows):
                    resultsController.shows = shows
                    resultsController.searchResultsCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}

extension TopSearchesVC: SearchResultsDelegate {
    
    func searchResultsDelegateTapped(_ show: Show, _ previewUrl: String) {
        DispatchQueue.main.async { [weak self] in
            let vc = ShowPreviewVC()
            vc.configure(using: show, previewUrl: previewUrl)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
