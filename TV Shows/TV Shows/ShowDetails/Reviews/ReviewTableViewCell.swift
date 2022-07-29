//
//  ReviewTableViewCell.swift
//  TV Shows
//
//  Created by mn on 27.07.2022..
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet private weak var userLabel: UILabel!
    @IBOutlet private weak var commentLabel: UILabel!
    @IBOutlet private weak var showRatingView: RatingView!
    
    public func configure(email: String, rating: Int, comment: String){
        userLabel.text = email
        commentLabel.text = comment
        showRatingView.rating = rating
        showRatingView.isEnabled = false
        showRatingView.configure(withStyle: .small)
        showRatingView.sizeToFit()
    }
}
