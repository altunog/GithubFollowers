//
//  UserInfoVC.swift
//  GithubFollowers
//
//  Created by Oğuz Kaan Altun on 8.01.2023.
//

import UIKit

class UserInfoVC: UIViewController {

    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        
        print(username!)
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let user):
                print(user)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
  
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}
