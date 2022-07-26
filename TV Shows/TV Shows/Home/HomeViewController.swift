//
//  HomeViewController.swift
//  TV Shows
//
//  Created by mn on 20.07.2022..
//

import UIKit
import Alamofire

final class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var showsTableView: UITableView!
    
    // MARK: - Properties
    
    public var userResponse: UserResponse?
    public var authInfo: AuthInfo?
    private var shows: [Show]?
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getShowsResponse()
        setupTableView()
    }
}

private extension HomeViewController {
    
    // MARK: - API communication
    
    func getShowsResponse(){
        guard let authInfo = authInfo else { return }
        AF .request(
              "https://tv-shows.infinum.academy/shows",
              method: .get,
              parameters: ["page": "1", "items": "100"], // pagination arguments
              headers: HTTPHeaders(authInfo.headers)
          )
          .validate()
          .responseDecodable(of: ShowsResponse.self) { [weak self] dataResponse in
              guard let self = self else { return }
              switch dataResponse.result {
              case .success(let showsResponse):
                  self.shows = showsResponse.shows
                  print("Success loading shows")
                  self.showsTableView.reloadData()
                  
              case .failure(let error):
                  print(error)
              }
          }
    }
}

extension HomeViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let shows = shows else { return 0}
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let shows = shows else { return TvShowTableViewCell() }
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: TvShowTableViewCell.self),
            for: indexPath
        ) as! TvShowTableViewCell
        cell.configure(with: shows[indexPath.row])
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    // Delegate UI events, open up `UITableViewDelegate` and explore :)

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let shows = shows else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        let item = shows[indexPath.row]
        print("Selected Item: \(item)")
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
