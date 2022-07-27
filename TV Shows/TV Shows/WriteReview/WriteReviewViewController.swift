//
//  WriteReviewViewController.swift
//  TV Shows
//
//  Created by mn on 27.07.2022..
//

import UIKit
import Alamofire
import MBProgressHUD

class WriteReviewViewController: UIViewController {
    
    // MARK: - Properties
    
    public var authInfo: AuthInfo?
    public var showId: Int?
    
    // MARK: - Outlets
    
    @IBOutlet private weak var ratingView: RatingView!
    @IBOutlet weak var commentTextView: UITextField!
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        guard let showId = showId else { return }
        guard let comment = commentTextView.text else { return }
        PostReview(rating: ratingView.rating, comment: comment, show_id: showId)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension WriteReviewViewController {
    @objc func close() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}

extension WriteReviewViewController {
    func PostReview(rating: Int, comment: String, show_id: Int) {
        guard let authInfo = authInfo else { return }
        let parameters = ReviewParameters(rating: rating, comment: comment, showID: show_id)
        AF
            .request(
                "https://tv-shows.infinum.academy/reviews",
                method: .post,
                parameters: parameters,
                encoder: JSONParameterEncoder.default,
                headers: HTTPHeaders(authInfo.headers)
            )
            .validate()
            .responseDecodable(of: UserResponse.self) { [weak self] dataResponse in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                switch dataResponse.result {
                case .success(let userResponse):
                    print("Success")
                case .failure(let error):
                    print(error)
                }
            }
    }
}

extension WriteReviewViewController {
    func setupUI() {
        navigationItem.title = "Write a review"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(close))
        ratingView.configure(withStyle: .small)
        ratingView.isEnabled = true
    }
}
