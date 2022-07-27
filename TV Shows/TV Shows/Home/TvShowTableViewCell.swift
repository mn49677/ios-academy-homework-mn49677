//
//  TvShowTableViewCell.swift
//  TV Shows
//
//  Created by mn on 26.07.2022..
//

import UIKit

final class TvShowTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension TvShowTableViewCell {

    // MARK: - Configure
    
    func configure(with item: Show) {
        titleLabel.text = item.title
    }
}
