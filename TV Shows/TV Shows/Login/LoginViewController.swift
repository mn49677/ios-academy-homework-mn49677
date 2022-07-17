//
//  LoginViewController.swift
//  TV Shows
//
//  Created by mn on 11.07.2022..
//

import UIKit

final class LoginViewController : UIViewController {
    
    // MARK: - Lifecycle methods
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        animateSpinner()
    }
    
    // MARK: - Properties
    
    private var labelText = "Number of taps:\n"
    private var numberOfTaps : Int = 0
    
    // MARK: - Outlets
    
    @IBOutlet private weak var showcaseIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var numberOfTapsLabel: UILabel!
    
    // MARK: - IBActions
    
    @IBAction private func increaseCounterAndUpdateLabel() {
        if showcaseIndicator.isAnimating {
            showcaseIndicator.stopAnimating()
        } else {
            showcaseIndicator.startAnimating()
        }
        
        numberOfTaps += 1
        numberOfTapsLabel.text = "\(labelText) \(numberOfTaps)"
    }
    
    // MARK: - Controller setup methods
    
    private func setupUI(){
        numberOfTapsLabel.text = "\(labelText)\(numberOfTaps)"
        view.backgroundColor = .lightGray
    }
    
    private func animateSpinner(){
        showcaseIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.showcaseIndicator.stopAnimating()
        }
    }
}
