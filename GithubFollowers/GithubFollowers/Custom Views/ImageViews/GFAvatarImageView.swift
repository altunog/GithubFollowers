//
//  GFAvatarImageView.swift
//  GithubFollowers
//
//  Created by Oğuz Kaan Altun on 2.01.2023.
//

import UIKit

final class GFAvatarImageView: UIImageView {

    private let cache = NetworkManager.shared.cache
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = Images.placeholder
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func downloadImage(fromUrl url: String) {
        
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
}
