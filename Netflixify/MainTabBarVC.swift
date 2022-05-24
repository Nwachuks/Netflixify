//
//  MainTabBarVC.swift
//  Netflixify
//
//  Created by Nwachukwu Ejiofor on 24/05/2022.
//

import UIKit

class MainTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemYellow
        
        let homeNav = UINavigationController(rootViewController: HomeVC())
        let comingSoonNav = UINavigationController(rootViewController: ComingSoonVC())
        let topSearchesNav = UINavigationController(rootViewController: TopSearchesVC())
        let downloadsNav = UINavigationController(rootViewController: DownloadsVC())
        
        // Set tint color to contrast light/dark mode
//        homeNav.navigationBar.tintColor = .label
//        comingSoonNav.navigationBar.tintColor = .label
//        topSearchesNav.navigationBar.tintColor = .label
//        downloadsNav.navigationBar.tintColor = .label
        
        tabBar.tintColor = .label
        
        homeNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        comingSoonNav.tabBarItem = UITabBarItem(title: "Coming Soon", image: UIImage(systemName: "play.circle"), tag: 1)
        topSearchesNav.tabBarItem = UITabBarItem(title: "Top Searches", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        downloadsNav.tabBarItem = UITabBarItem(title: "Downloads", image: UIImage(systemName: "arrow.down.to.line"), tag: 1)
        
        setViewControllers([homeNav, comingSoonNav, topSearchesNav, downloadsNav], animated: true)
    }


}

