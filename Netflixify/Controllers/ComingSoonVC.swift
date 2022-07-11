//
//  ComingSoonVC.swift
//  Netflixify
//
//  Created by Nwachukwu Ejiofor on 24/05/2022.
//

import UIKit

class ComingSoonVC: UIViewController {
    
    private var shows = [Show]()
    
    private let upcomingTable: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.register(ShowTVC.self, forCellReuseIdentifier: ShowTVC.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        // Do any additional setup after loading the view.
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        view.addSubview(upcomingTable)
        
        fetchUpcomingShows()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    private func fetchUpcomingShows() {
        NetworkManager.instance.getUpcomingMovies { [weak self] results in
            switch results {
            case .success(let shows):
                self?.shows = shows
                DispatchQueue.main.async {
                    self?.upcomingTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension ComingSoonVC: UITableViewDelegate, UITableViewDataSource {
    
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
    
}
