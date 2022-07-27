//
//  DescriptionTableViewCell.swift
//  TV Shows
//
//  Created by mn on 27.07.2022..
//

import UIKit

final class DescriptionTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var reviewSummaryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(description: String, numberOfReviews: Int, averageRating: Float) {
        descriptionLabel.text = description
        if numberOfReviews == 0 {
            reviewSummaryLabel.text = "No reviews yet."
        } else {
            reviewSummaryLabel.text = "\(numberOfReviews) REVIEWS, \(averageRating) AVERAGE"
            reviewSummaryLabel.textAlignment = .left
        }
    }
}
