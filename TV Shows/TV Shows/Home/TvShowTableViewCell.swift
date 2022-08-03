//
//  TvShowTableViewCell.swift
//  TV Shows
//
//  Created by mn on 26.07.2022..
//

import UIKit
import Kingfisher

final class TvShowTableViewCell: UITableViewCell {
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var showImage: UIImageView!
}

extension TvShowTableViewCell {

    // MARK: - Configure
    
    func configure(with item: Show) {
        titleLabel.text = item.title
        showImage.kf.setImage(
            with: item.imageURL,
            placeholder: UIImage(named: "ic-show-placeholder-vertical"),
            options: [.cacheOriginalImage])
    }
}
