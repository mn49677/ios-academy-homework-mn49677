//
//  ExtensionsUIButton.swift
//  TV Shows
//
//  Created by Maximilian Novak on 01.08.2022..
//

import UIKit

extension UIButton {
    
    func shake(duration: TimeInterval = 0.5) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
    
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = duration
        animation.values = [-12.0, 12.0, -12.0, 12.0, -6.0, 6.0, -3.0, 3.0, 0.0]
        self.layer.add(animation, forKey: "shake")
    }
}
