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
        
        let unwrappedUrl = item.imageURL != nil
        ? URL(string: item.imageURL!)
        : nil
        showImage.kf.setImage(
            with: unwrappedUrl,
            placeholder: UIImage(named: "ic-show-placeholder-vertical"),
            options: [.cacheOriginalImage])
    }
}
