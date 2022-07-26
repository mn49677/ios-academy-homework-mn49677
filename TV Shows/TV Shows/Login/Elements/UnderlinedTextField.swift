//
//  UnderlinedTextField.swift
//  TV Shows
//
//  Created by mn on 19.07.2022..
//

import UIKit

final class UnderlinedTextField: UITextField {

    let underlineLayer = CALayer()

    /// Size the underline layer and position it as a one point line under the text field.
    func setupUnderlineLayer() {
        var frame = self.bounds
        frame.origin.y = frame.size.height - 1
        frame.size.height = 1

        underlineLayer.frame = frame
        underlineLayer.backgroundColor = UIColor.white.cgColor
    }

    // In `init?(coder:)` Add our underlineLayer as a sublayer of the view's main layer
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.addSublayer(underlineLayer)
    }

    // in `init(frame:)` Add our underlineLayer as a sublayer of the view's main layer
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.addSublayer(underlineLayer)
    }

    // Any time we are asked to update our subviews,
    // adjust the size and placement of the underline layer too
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUnderlineLayer()
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
    }
}
