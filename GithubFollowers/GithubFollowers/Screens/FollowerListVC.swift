//
//  FollowerListVC.swift
//  GithubFollowers
//
//  Created by Oğuz Kaan Altun on 1.01.2023.
//

import UIKit

class FollowerListVC: UIViewController {

    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        NetworkManager.shared.getFollowers(for: username, page: 1) { takipçiler, hataMesajı in
            guard let takipçiler else {
                self.presentGFAlertOnMainThread(title: "Bad stuff happened", message: hataMesajı!, buttonTitle: "Tamam")
                return
            }
            
            print("takipçi sayısı:", takipçiler.count)
            print(takipçiler)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    deinit {
        print(#function)
    }

}
