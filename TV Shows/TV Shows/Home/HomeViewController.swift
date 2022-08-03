//
//  HomeViewController.swift
//  TV Shows
//
//  Created by mn on 20.07.2022..
//

import UIKit
import Alamofire
import MBProgressHUD

final class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var showsTableView: UITableView!
    
    // MARK: - Properties
    
    private var userResponse: UserResponse?
    private var authInfo: AuthInfo?
    private var shows: [Show] = []
    private var currentPage = 1
    private let numberOfCellsPerPage = 20
    private var notificationToken: NSObjectProtocol?
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        resolveAuthInfo()
        getShowsResponse()
        setupTableView()
        setupRightBarButton()
        setupObserver()
    }
}

// MARK: - API communication methods

private extension HomeViewController {
    
    func getShowsResponse(){
        guard let authInfo = authInfo else { return }
        MBProgressHUD.showAdded(to: view, animated: true)
        AF .request(
              "https://tv-shows.infinum.academy/shows",
              method: .get,
              parameters: ["page": String(currentPage), "items": String(numberOfCellsPerPage)], // pagination arguments
              headers: HTTPHeaders(authInfo.headers)
          )
          .validate()
          .responseDecodable(of: ShowsResponse.self) { [weak self] dataResponse in
              guard let self = self else { return }
              MBProgressHUD.hide(for: self.view, animated: true)
              
              switch dataResponse.result {
              case .success(let showsResponse):
                  self.onSuccess(showsResponse)
              case .failure(_):
                  self.onError()
              }
          }
    }
    
    func resolveAuthInfo() {
        if authInfo == nil {
            authInfo = KeychainAccess.getAuthInfo()
        }
    }
}

// MARK: - UITableView data loading delegate methods

extension HomeViewController : UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: TvShowTableViewCell.self),
            for: indexPath
        ) as! TvShowTableViewCell
        cell.configure(with: shows[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate for selecting and pagination methods

extension HomeViewController: UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = shows[indexPath.row]
        print("Selected Item: \(item)")
        pushShowDetailsViewController(withShowAt: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == shows.count - 1 {
            currentPage += 1
            getShowsResponse()
        }
    }
}

// MARK: - Setup view and observer methods

private extension HomeViewController {
        
    func setupTableView() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        
        showsTableView.estimatedRowHeight = 110
        showsTableView.rowHeight = UITableView.automaticDimension
        showsTableView.tableFooterView = UIView()
        showsTableView.addSubview(refreshControl)
        
        showsTableView.delegate = self
        showsTableView.dataSource = self
        
        showsTableView.register(UINib.init(nibName: "TvShowTableViewCell", bundle: nil), forCellReuseIdentifier: "TvShowTableViewCell")
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        // Code to refresh table view
        currentPage = 1
        shows = []
        getShowsResponse()
        sender.endRefreshing()
        showsTableView.reloadData()
    }
    
    func setupRightBarButton() {
        let profileDetailsItem = UIBarButtonItem(
            image: UIImage(named: "ic-profile"),
            style: .plain,
            target: self,
            action: #selector(profileDetailsActionHandler)
        )
        profileDetailsItem.tintColor = UIColor.blue
        navigationItem.rightBarButtonItem = profileDetailsItem
    }
    
    @objc private func profileDetailsActionHandler() {
        // open profile view
        let profileViewController = storyboard?.instantiateViewController(withIdentifier: Constants.ViewControllers.profile) as! ProfileViewController
        profileViewController.configure(authInfo: authInfo)
        let navigationController = UINavigationController(rootViewController: profileViewController)
        present(navigationController, animated: true)
    }
    
    func setupObserver() {
        notificationToken = NotificationCenter
            .default
            .addObserver(
                forName: Constants.Notifications.logout,
                object: nil,
                queue: nil,
                using: { [weak self] notification in
                    guard let self = self else { return }
                    let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.ViewControllers.login) as! LoginViewController
                    self.navigationController?.setViewControllers([loginViewController], animated: true)
                }
            )
    }
}

// MARK: - Navigation methods

extension HomeViewController {
            
    func pushShowDetailsViewController(withShowAt indexRow: Int) {
        let detailsController =
            storyboard?.instantiateViewController(withIdentifier: Constants.ViewControllers.details) as! ShowDetailsViewController
        detailsController.configure(authInfo: authInfo, show: shows[indexRow])
        navigationController?.pushViewController(detailsController, animated: true)
    }
    
    public func configure(authInfo: AuthInfo?, userResponse: UserResponse?) {
        self.authInfo = authInfo
        self.userResponse = userResponse
    }
}

// MARK: - API Response handler methods

private extension HomeViewController {
    
    private func onError() {
        let alert = UIAlertController(title: "Failed loading shows!", message: "Failed loading shows. Please restart the app and relogin.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func onSuccess(_ showsResponse: ShowsResponse) {
        if self.currentPage < showsResponse.meta.pagination.pages {
            self.shows.append(contentsOf: showsResponse.shows)
            self.showsTableView.reloadData()
        }
    }
}

