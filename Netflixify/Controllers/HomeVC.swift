//
//  HomeVC.swift
//  Netflixify
//
//  Created by Nwachukwu Ejiofor on 24/05/2022.
//

import UIKit

class HomeVC: UIViewController {
    
    let sectionTitles = ["Popular", "Trending Movies", "Trending TV Shows", "Upcoming", "Top Rated"]
    
    private var heroShow: Show?
    private var headerView: HeroImageView?
    
    private var popularShows = [Show]()
    private var trendingMovies = [Show]()
    private var trendingTV = [Show]()
    private var upcomingShows = [Show]()
    private var topRatedShows = [Show]()
    
    private let feedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTVC.self, forCellReuseIdentifier: CollectionViewTVC.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .black
        // Do any additional setup after loading the view.
        view.addSubview(feedTable)
        configureNavBar()
        feedTable.delegate = self
        feedTable.dataSource = self
        feedTable.backgroundColor = .white
        
        headerView = HeroImageView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        headerView?.heroShowDelegate = self
        feedTable.tableHeaderView = headerView
        configureHeroShow()
        getShowsForCategories()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        feedTable.frame = view.bounds
    }
    
    private func configureNavBar() {
        let image = UIImage(named: "NetflixLogo")?.resizeTo(size: CGSize(width: 25, height: 40))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func configureHeroShow() {
        NetworkManager.instance.getTrendingMovies { [weak self] results in
            switch results {
            case .success(let shows):
                let selectedShow = shows.randomElement()
                self?.heroShow = selectedShow
                self?.headerView?.configureHeroImage(using: selectedShow)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func getShowsForCategories() {
        NetworkManager.instance.getPopularMovies { [weak self] results in
            switch results {
            case .success(let shows):
                self?.popularShows = shows.shuffled()
                DispatchQueue.main.async {
                    self?.feedTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        NetworkManager.instance.getTrendingMovies { [weak self] results in
            switch results {
            case .success(let shows):
                self?.trendingMovies = shows.shuffled()
                DispatchQueue.main.async {
                    self?.feedTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        NetworkManager.instance.getTrendingTVShows { [weak self] results in
            switch results {
            case .success(let shows):
                self?.trendingTV = shows.shuffled()
                DispatchQueue.main.async {
                    self?.feedTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        NetworkManager.instance.getUpcomingMovies { [weak self] results in
            switch results {
            case .success(let shows):
                self?.upcomingShows = shows.shuffled()
                DispatchQueue.main.async {
                    self?.feedTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        NetworkManager.instance.getTopRatedMovies { [weak self] results in
            switch results {
            case .success(let shows):
                self?.topRatedShows = shows.shuffled()
                DispatchQueue.main.async {
                    self?.feedTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.textColor = .black
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTVC.identifier, for: indexPath) as? CollectionViewTVC  else { return UITableViewCell() }
        cell.collectionViewTVCDelegate = self
        
        switch indexPath.section {
        case Sections.Popular.rawValue:
            cell.configure(using: popularShows)
            break
        case Sections.TrendingMovies.rawValue:
            cell.configure(using: trendingMovies)
            break
        case Sections.TrendingTVShows.rawValue:
            cell.configure(using: trendingTV)
            break
        case Sections.Upcoming.rawValue:
            cell.configure(using: upcomingShows)
            break
        case Sections.TopRated.rawValue:
            cell.configure(using: topRatedShows)
            break
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}

extension HomeVC: CollectionViewTVCDelegate {
    func collectionViewTVCTapped(_ cell: CollectionViewTVC, _ show: Show, _ previewUrl: String) {
        DispatchQueue.main.async { [weak self] in
            let vc = ShowPreviewVC()
            vc.configure(using: show, previewUrl: previewUrl)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension HomeVC: HeroShowDelegate {
    func showPreview(using show: Show, and previewUrl: String) {
        DispatchQueue.main.async { [weak self] in
            let vc = ShowPreviewVC()
            vc.configure(using: show, previewUrl: previewUrl)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
