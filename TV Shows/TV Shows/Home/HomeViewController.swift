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
    
    var userResponse: UserResponse?
    var authInfo: AuthInfo?
    private var shows: [Show] = []
    private var currentPage = 1
    private let numberOfCellsPerPage = 20
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        resolveAuthInfo()
        getShowsResponse()
        setupTableView()
    }
}

// MARK: - API communication

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
            do {
                authInfo = try UserDefaults.standard.getObject(forKey: Constants.Keys.authInfo, castTo: AuthInfo.self)
            } catch {}
        }
    }
}

// MARK: - UITableView data loading delegate

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

// MARK: - UITableViewDelegate for selecting and pagination

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

// MARK: - Setup table view

private extension HomeViewController {
        
    func setupTableView() {
        showsTableView.estimatedRowHeight = 110
        showsTableView.rowHeight = UITableView.automaticDimension
        showsTableView.tableFooterView = UIView()
        
        showsTableView.delegate = self
        showsTableView.dataSource = self
        
        showsTableView.register(UINib.init(nibName: "TvShowTableViewCell", bundle: nil), forCellReuseIdentifier: "TvShowTableViewCell")
    }
    
}

// MARK: - Navigation

private extension HomeViewController {
            
    func pushShowDetailsViewController(withShowAt indexRow: Int) {
        let detailsController =
            storyboard?.instantiateViewController(withIdentifier: Constants.ViewControllers.details) as! ShowDetailsViewController
        detailsController.authInfo = authInfo
        detailsController.show = shows[indexRow]
        navigationController?.pushViewController(detailsController, animated: true)
    }
}

// MARK: - API Response handlers

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

