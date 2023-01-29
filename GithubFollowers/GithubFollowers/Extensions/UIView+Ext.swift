//
//  UIView+Ext.swift
//  GithubFollowers
//
//  Created by Oğuz Kaan Altun on 29.01.2023.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
