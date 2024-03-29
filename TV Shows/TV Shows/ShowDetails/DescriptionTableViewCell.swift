//
//  DescriptionTableViewCell.swift
//  TV Shows
//
//  Created by mn on 27.07.2022..
//

import UIKit
import Kingfisher

final class DescriptionTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var reviewSummaryLabel: UILabel!
    @IBOutlet private weak var showImage: UIImageView!
    
    public func configure(description: String, numberOfReviews: Int, averageRating: Float, showImageUrl: URL?) {
        descriptionLabel.text = description
        if numberOfReviews == 0 {
            reviewSummaryLabel.text = "No reviews yet."
        } else {
            reviewSummaryLabel.text = "\(numberOfReviews) REVIEWS, \(averageRating) AVERAGE"
            reviewSummaryLabel.textAlignment = .left
        }
        selectionStyle = .none
        showImage.kf.setImage(
            with: showImageUrl,
            placeholder: UIImage(named: "ic-show-placeholder-rectangle"),
            options: [.cacheOriginalImage])
    }
}
