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
    
    @IBOutlet weak var showsTableView: UITableView!
    
    // MARK: - Properties
    
    public var userResponse: UserResponse?
    public var authInfo: AuthInfo?
    private var shows: [Show] = []
    private var currentPage: Int = 1
    private let numberOfCellsPerPage: Int = 20
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getShowsResponse(page: currentPage, numberOfCells: numberOfCellsPerPage)
        setupTableView()
    }
}

private extension HomeViewController {
    
    // MARK: - API communication
    
    func getShowsResponse(page: Int, numberOfCells: Int){
        guard let authInfo = authInfo else { return }
        MBProgressHUD.showAdded(to: view, animated: true)
        AF .request(
              "https://tv-shows.infinum.academy/shows",
              method: .get,
              parameters: ["page": String(page), "items": String(numberOfCells)], // pagination arguments
              headers: HTTPHeaders(authInfo.headers)
          )
          .validate()
          .responseDecodable(of: ShowsResponse.self) { [weak self] dataResponse in
              guard let self = self else { return }
              MBProgressHUD.hide(for: self.view, animated: true)
              switch dataResponse.result {
              case .success(let showsResponse):
                  if self.currentPage < showsResponse.meta.pagination.pages {
                      self.shows.append(contentsOf: showsResponse.shows)
                      print("Success loading shows")
                      self.showsTableView.reloadData()
                  }
                  
              case .failure(let error):
                  print(error)
              }
          }
    }
}

extension HomeViewController : UITableViewDataSource {
    
    // MARK: - UITableView data loading delegate
    
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

extension HomeViewController: UITableViewDelegate {

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = shows[indexPath.row]
        print("Selected Item: \(item)")
        pushShowDetailsViewController(withShowAt: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row > currentPage * numberOfCellsPerPage - 5 {
            currentPage += 1
            getShowsResponse(page: currentPage, numberOfCells: numberOfCellsPerPage)
        }
    }
}

private extension HomeViewController {
    
    // MARK: - Setup table view
    
    func setupTableView() {
        showsTableView.estimatedRowHeight = 110
        showsTableView.rowHeight = UITableView.automaticDimension
        showsTableView.tableFooterView = UIView()
        
        showsTableView.delegate = self
        showsTableView.dataSource = self
        
        showsTableView.register(UINib.init(nibName: "TvShowTableViewCell", bundle: nil), forCellReuseIdentifier: "TvShowTableViewCell")
    }
    
}

private extension HomeViewController {
    
    // MARK: - Private methods
        
    func pushShowDetailsViewController(withShowAt indexRow: Int) {
        let detailsController = storyboard?.instantiateViewController(withIdentifier: Constants.ViewControllers.details) as? ShowDetailsViewController
        if let detailsController = detailsController {
            guard let authInfo = authInfo else { return }
            detailsController.authInfo = authInfo
            detailsController.show = shows[indexRow]
            navigationController?.pushViewController(detailsController, animated: true)
        }
    }
}
