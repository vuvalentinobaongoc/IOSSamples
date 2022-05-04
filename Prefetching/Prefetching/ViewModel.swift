//
//  ViewModel.swift
//  Prefetching
//
//  Created by Ngoc Vũ on 04/05/2022.
//

import Foundation
import UIKit

final class ViewModel {
    let downloadIndex: Int
    init(downloadIndex: Int) {
        self.downloadIndex = downloadIndex
    }
    
    private var cachedImage: UIImage?
    private var isDownloading: Bool = false
    private var completionHandler: ((_ image: UIImage?, _ index: Int) -> Void)?
    
    func downloadImage(completion: ((_ image: UIImage?, _ index: Int) -> Void)?) {
        if let image = cachedImage {
            completion?(image, self.downloadIndex)
            return
        }
        
        guard !isDownloading else {
            self.completionHandler = completion
            return
        }
        
        isDownloading = true
        
        let randomSize: Int = Int.random(in: 100...300)
        guard let url = URL(string: "https://source.unsplash.com/random/\(randomSize)x\(randomSize)") else {
            return
        }
        
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        let task = URLSession(configuration: configuration).dataTask(with: url) { data, _, _ in
            guard let data = data else {
                return
            }
            let image = UIImage(data: data)
            self.cachedImage = image
            self.isDownloading = false
            self.completionHandler?(image, self.downloadIndex)
            self.completionHandler = nil
            completion?(image, self.downloadIndex)
        }
        task.resume()
    }
}
