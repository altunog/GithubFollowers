//
//  GFButton.swift
//  GithubFollowers
//
//  Created by Oğuz Kaan Altun on 1.01.2023.
//

import UIKit

final class GFButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(color: UIColor, title: String, systemImageName: String) {
        self.init(frame: .zero)
        set(color: color, title: title, systemImageName: systemImageName)
    }
    
    
    private func configure() {
        configuration = .tinted()
        configuration?.cornerStyle = .large
        translatesAutoresizingMaskIntoConstraints = false
    }
    
//    private func configure() {
//        layer.cornerRadius = 10
//        setTitleColor(.white, for: .normal)
//        titleLabel?.font = .preferredFont(forTextStyle: .headline)
//        translatesAutoresizingMaskIntoConstraints = false
//    }
    
    
    func set(color: UIColor, title: String, systemImageName: String) {
        configuration?.baseBackgroundColor = color
        configuration?.baseForegroundColor = color
        configuration?.title = title
        configuration?.image = UIImage(systemName: systemImageName)
        configuration?.imagePlacement = .leading
        configuration?.imagePadding = 6
    }
}
