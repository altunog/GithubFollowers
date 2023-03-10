//
//  FollowerListVC.swift
//  GithubFollowers
//
//  Created by Oğuz Kaan Altun on 1.01.2023.
//

import UIKit

final class FollowerListVC: GFDataLoadingVC {

    enum Section {
        case main
    }
    
    var username: String
    
    private var followers: [Follower] = []
    private var filteredFollowers: [Follower] = []
    
    private var page = 1
    private var hasMoreFollowers = true
    private var isSearching = false
    private var isLoadingMoreFollowers = false
    
    private var searchController: UISearchController!
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    
    init(username: String) {
        self.username = username
        super.init(nibName: nil, bundle: nil)
        title = username
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureCollectionView()
        getFollowers()
        configureDataSource()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    
    private func configureSearchController() {
        searchController = UISearchController()
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false // not dimming the background when search is active
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    
    private func getFollowers() {
        
        showLoadingView()
        isLoadingMoreFollowers = true
        
        NetworkManager.shared.getFollowers(for: self.username, page: self.page) { [weak self] result in
            guard let self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let followers):
                self.updateUI(with: followers)
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad stuff happened", message: error.rawValue, buttonTitle: "Ok")
            }
            
            self.isLoadingMoreFollowers = false
        }
    }
    
    
    private func updateUI(with followers: [Follower]) {
        
        if followers.count < 100 { self.hasMoreFollowers = false }
        self.followers.append(contentsOf: followers)
        
        if self.followers.isEmpty {
            let message = "This user doesn't have any followers. Go follow them 😃."
            DispatchQueue.main.async { self.showEmptyStateView(with: message) }
            return
        }
        
        self.updateData(on: self.followers)
    }
    
    
    private func configureDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView,
                                                                           cellProvider: { collectionView, indexPath, follower in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    
    private func updateData(on followers: [Follower]) {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    
    @objc private func addButtonTapped() {
        
        showLoadingView()
        
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let user):
                self.addUserToFavorites(user)
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    
    private func addUserToFavorites(_ user: User) {
        
        let follower = Follower(login: user.login, avatarUrl: user.avatarUrl)
        
        PersistanceManager.updateWith(favorite: follower, actionType: .add) { [weak self] error in
            guard let self else { return }
            guard let error else {
                self.presentGFAlertOnMainThread(title: "Success!",
                                                message: "You have successfully favorited this user 🥳",
                                                buttonTitle: "Hooray!")
                return
            }
            
            self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
        }
    }
}


extension FollowerListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        guard hasMoreFollowers, !isLoadingMoreFollowers else { return }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if offsetY + height >= contentHeight * 0.90 {
            page += 1
            getFollowers()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]
        
        let destVC = UserInfoVC()
        destVC.username = follower.login
        destVC.delegate = self
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
}


extension FollowerListVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredFollowers.removeAll()
            updateData(on: followers)
            isSearching = false
            return
        }
        
        isSearching = true
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        updateData(on: followers)
        isSearching = false
    }
}


extension FollowerListVC: UserInfoVCDelegate {
    
    func didRequestFollowers(for username: String) {
        
        self.username = username
        title = username
        page = 1
        followers.removeAll()
        filteredFollowers.removeAll()
//        collectionView.scrollsToTop = true
//        collectionView.setContentOffset(.zero, animated: true)
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        getFollowers()
    }
}
