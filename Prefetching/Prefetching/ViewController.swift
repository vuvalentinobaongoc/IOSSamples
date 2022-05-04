//
//  ViewController.swift
//  Prefetching
//
//  Created by Ngoc Vũ on 04/05/2022.
//

import UIKit

final class ViewController: UIViewController {

    // MARK: Datas
    private let viewModels = (0...100).map { index in ViewModel(downloadIndex: index)}
    
    // MARK: Views
    
    private lazy var _tableView: UITableView = {
        let tbv = UITableView()
        tbv.translatesAutoresizingMaskIntoConstraints = false
        tbv.delegate = self
        tbv.dataSource = self
        tbv.prefetchDataSource = self
        tbv.allowsSelection = false
        tbv.register(PhotoCell.self, forCellReuseIdentifier: String(describing: PhotoCell.self))
        return tbv
    }()
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        addViewsAndLayout()
    }
    
    // Setup views and layout
    private func addViewsAndLayout() {
        self.view.addSubview(_tableView)
        NSLayoutConstraint.activate([
            self._tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self._tableView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            self._tableView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor),
            self._tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}


// MARK: Datasources & Delegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PhotoCell.self), for: indexPath) as! PhotoCell
        
        let viewModel = self.viewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}

// MARK: Prefetching
extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let viewModel = self.viewModels[indexPath.row]
            viewModel.downloadImage(completion: nil)
        }
    }
}

