//
//  ReviewTableViewCell.swift
//  TV Shows
//
//  Created by mn on 27.07.2022..
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var showRatingView: RatingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(email: String, rating: Int, comment: String){
        userLabel.text = email
        commentLabel.text = comment
        showRatingView.rating = rating
        showRatingView.isEnabled = false
        showRatingView.sizeToFit()
    }
}
