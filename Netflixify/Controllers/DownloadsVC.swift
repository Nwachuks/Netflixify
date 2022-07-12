//
//  DownloadsVC.swift
//  Netflixify
//
//  Created by Nwachukwu Ejiofor on 24/05/2022.
//

import UIKit

class DownloadsVC: UIViewController {
    
    private var showItems = [ShowItem]()
    
    private let downloadsTable: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.register(ShowTVC.self, forCellReuseIdentifier: ShowTVC.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .black
        // Do any additional setup after loading the view.
        downloadsTable.delegate = self
        downloadsTable.dataSource = self
        view.addSubview(downloadsTable)
        
        fetchLocalDownloads()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadsTable.frame = view.bounds
    }

    private func fetchLocalDownloads() {
        DataPersistenceManager.instance.fetchShow { [weak self] result in
            switch result {
            case .success(let shows):
                self?.showItems = shows
                self?.downloadsTable.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func convertShowItemToShow(using showItem: ShowItem) -> Show {
        let show = Show(id: Int(showItem.id), mediaType: showItem.mediaType, originalName: showItem.originalName, originalTitle: showItem.originalTitle, posterPath: showItem.posterPath, overview: showItem.overview, voteCount: Int(showItem.voteCount), voteAverage: showItem.voteAverage, releaseDate: showItem.releaseDate)
        return show
    }
}

extension DownloadsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ShowTVC.identifier, for: indexPath) as? ShowTVC else { return UITableViewCell() }
        let showItem = showItems[indexPath.row]
        let show = convertShowItemToShow(using: showItem)
        cell.configure(using: show)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DataPersistenceManager.instance.deleteShow(using: showItems[indexPath.row]) { [weak self] result in
                switch result {
                case .success():
                    print("Deleted successfully")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.showItems.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break
        }
    }
    
}
