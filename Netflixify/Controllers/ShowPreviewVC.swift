//
//  ShowPreviewVC.swift
//  Netflixify
//
//  Created by Nwachukwu Ejiofor on 12/07/2022.
//

import UIKit
import WebKit

class ShowPreviewVC: UIViewController {
    
    private var selectedShow: Show?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.backgroundColor = .black
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("Download", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.addTarget(ShowPreviewVC.self, action: #selector(downloadShow), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        containerView.addSubview(webView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(overviewLabel)
        containerView.addSubview(downloadButton)
        
        applyConstraints()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func applyConstraints() {
        let scrollViewConstraints = [
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        let containerViewConstraints = [
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ]
        
        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            webView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            webView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            webView.heightAnchor.constraint(equalToConstant: 300)
        ]
        
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ]
        
        let overviewLabelConstraints = [
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            overviewLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ]
        
        let downloadButtonConstraints = [
            downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 25),
            downloadButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            downloadButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            downloadButton.heightAnchor.constraint(equalToConstant: 50),
            downloadButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30)
        ]
        
        NSLayoutConstraint.activate(scrollViewConstraints)
        NSLayoutConstraint.activate(containerViewConstraints)
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overviewLabelConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    public func configure(using show: Show, previewUrl: String) {
        selectedShow = show
        titleLabel.text = show.originalName ?? show.originalTitle
        overviewLabel.text = show.overview
        
        guard let url = URL(string: Constants.YOUTUBE_PREVIEW_BASE_URL + previewUrl) else { return }
        webView.load(URLRequest(url: url))
    }
    
    @objc func downloadShow() {
        guard let show = selectedShow else { return }
        DataPersistenceManager.instance.downloadShow(using: show) { result in
            switch result {
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name("download"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}
