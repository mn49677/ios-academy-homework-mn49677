//
//  ShowDetailsViewController.swift
//  TV Shows
//
//  Created by mn on 27.07.2022..
//

import UIKit
import Alamofire
import MBProgressHUD

final class ShowDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    var authInfo: AuthInfo?
    var show: Show?
    var reviewResponse: ReviewResponse?
    
    // MARK: - Outlets
    
    @IBOutlet private weak var infoTableView: UITableView!
    
    // MARK: - Actions
    
    @IBAction func writeReviewButtonClicked(_ sender: UIButton) {
        guard let id = show?.id else { return }
        let reviewController = storyboard?.instantiateViewController(withIdentifier: Constants.ViewControllers.review) as! WriteReviewViewController
        reviewController.showId = Int(id)
        reviewController.authInfo = authInfo
        let navigationController = UINavigationController(rootViewController: reviewController)
        present(navigationController, animated: true)
    }
    
    // MARK: - Lifetime cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle()
        getReviews(page: 1, numberOfCells: 100)
        setupTableView()
    }
}

// MARK: - UITableView data loading delegate

extension ShowDetailsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let reviewResponse = reviewResponse else { return 1 }
        return reviewResponse.reviews.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let show = show else { return DescriptionTableViewCell() }
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: DescriptionTableViewCell.self),
                for: indexPath
            ) as! DescriptionTableViewCell
            cell.configure(
                description: show.showDescription,
                numberOfReviews: show.noOfReviews,
                averageRating: show.averageRating,
                showImageUrl: show.imageURL)
            return cell
        } else {
            guard let reviewResponse = reviewResponse else { return ReviewTableViewCell() }
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: ReviewTableViewCell.self),
                for: indexPath
            ) as! ReviewTableViewCell
            let review = reviewResponse.reviews[indexPath.row]
            cell.configure(email: review.user.email, rating: review.rating, comment: review.comment ?? "")
            return cell
        }
    }
}

// MARK: - Table view setup

private extension ShowDetailsViewController {
        
    func setupTableView() {
        infoTableView.dataSource = self
        infoTableView.estimatedRowHeight = 700
        infoTableView.rowHeight = UITableView.automaticDimension
        infoTableView.tableFooterView = UIView()
        
        infoTableView.register(UINib.init(nibName: "DescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "DescriptionTableViewCell")
        infoTableView.register(UINib.init(nibName: "ReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "ReviewTableViewCell")
    }
}

// MARK: - API and data handlers

private extension ShowDetailsViewController {
    
    func getReviews(page: Int, numberOfCells: Int) {
        guard let authInfo = authInfo,
              let show = show
        else { return }
        AF
            .request(
            "https://tv-shows.infinum.academy/shows/\(show.id)/reviews",
              method: .get,
            parameters: ["page": String(page), "items": String(show.noOfReviews)], // pagination arguments
              headers: HTTPHeaders(authInfo.headers)
          )
          .validate()
          .responseDecodable(of: ReviewResponse.self) { [weak self] dataResponse in
              guard let self = self else { return }
              MBProgressHUD.hide(for: self.view, animated: true)
              switch dataResponse.result {
              case .success(let reviewResponse):
                  self.reviewResponse = reviewResponse
                  self.infoTableView.reloadData()
              case .failure(_):
                  self.showSimpleAlert()
              }
          }
    }
    
    func setTitle(){
        guard let show = show else { return }
        title = show.title
    }
    
    func showSimpleAlert() {
        let alert = UIAlertController(title: "Failed getting the reviews.", message: "Please try again.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
        present(alert, animated: true, completion: nil)
    }
}
