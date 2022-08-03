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
    
    private var authInfo: AuthInfo?
    private var showId: Int?
    
    // MARK: - Outlets
    
    @IBOutlet private weak var ratingView: RatingView!
    @IBOutlet private weak var commentTextView: UITextField!
    @IBOutlet private weak var submitButton: UIButton!
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        guard let showId = showId else { return }
        guard let comment = commentTextView.text else { return }
        postReview(rating: ratingView.rating, comment: comment, show_id: showId)
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
    func postReview(rating: Int, comment: String, show_id: Int) {
        guard let authInfo = authInfo else { return }
        let parameters = [
            "comment" : comment,
            "show_id" : show_id,
            "rating" : rating
        ] as [String : Any]
        AF
            .request(
                "https://tv-shows.infinum.academy/reviews",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: HTTPHeaders(authInfo.headers)
            )
            .validate()
            .responseDecodable(of: ReturnReviewResponse.self) { [weak self] dataResponse in
                
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                switch dataResponse.result {
                case .success(_):
                    self.onSuccess()
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
        ratingView.configure(withStyle: .large)
        ratingView.isEnabled = true
        commentTextView.delegate = self
    }
    
    func onSuccess() {
        self.dismiss(animated: true)
    }
    
    func configure(authInfo: AuthInfo?, showId: Int?) {
        self.authInfo = authInfo
        self.showId = showId
    }
}

extension WriteReviewViewController : UITextFieldDelegate{
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        if(textView.text.isEmpty){
            submitButton.isEnabled = false
        } else {
            submitButton.isEnabled = true
        }
    }
}
