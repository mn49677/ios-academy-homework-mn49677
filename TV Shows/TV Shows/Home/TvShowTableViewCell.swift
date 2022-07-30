//
//  TvShowTableViewCell.swift
//  TV Shows
//
//  Created by mn on 26.07.2022..
//

import UIKit

final class TvShowTableViewCell: UITableViewCell {
    
    @IBOutlet weak private var titleLabel: UILabel!

}

extension TvShowTableViewCell {

    // MARK: - Configure
    
    func configure(with item: Show) {
        titleLabel.text = item.title
    }
}
