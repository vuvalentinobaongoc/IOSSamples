//
//  PhotoCell.swift
//  Prefetching
//
//  Created by Ngoc Vũ on 04/05/2022.
//

import Foundation
import UIKit
final class PhotoCell: UITableViewCell {
    
    // MARK: Views
    
    private lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        lb.textColor = UIColor.black
        lb.translatesAutoresizingMaskIntoConstraints = false
        
        return lb
    }()
    
    private lazy var photoImageView: UIImageView = {
        let imgv = UIImageView()
        imgv.contentMode = .scaleAspectFill
        imgv.translatesAutoresizingMaskIntoConstraints = false
        imgv.clipsToBounds = true
        return imgv
    }()
    
    // MARK: Life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.photoImageView.image = nil
    }
    
    // Add views and layout
    private func initialize() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(photoImageView)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 100),
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 100),
            
            photoImageView.leadingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            photoImageView.heightAnchor.constraint(equalToConstant: 300),
            photoImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.photoImageView.layer.cornerRadius = 32
    }
    
    // MARK: configure viewmodel
    func configure(with viewModel: ViewModel) {
        self.titleLabel.text = "Number: \(viewModel.downloadIndex)"
        viewModel.downloadImage { (image, index) in
            DispatchQueue.main.async {
                guard index == viewModel.downloadIndex else {
                    return
                }
                self.photoImageView.image = image
            }
        }
    }
}
