//
//  LoginViewController.swift
//  TV Shows
//
//  Created by mn on 11.07.2022..
//

import UIKit

public class LoginViewController : UIViewController {
    
    // parent
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Change background color and add starting text to label
        labelOutlet.text = "\(labelText)\(numberOfTaps)"
        self.view.backgroundColor = UIColor.lightGray
        
        // Loading indicator startup
        activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.activityIndicator.stopAnimating()
        }
    }
    
    // variables
    var labelText = "Number of taps:\n"
    var numberOfTaps : Int = 0;
    
    // outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var labelOutlet: UILabel!
    
    // actions
    @IBAction func IncreaseCounterAndUpdateLabel(_ sender: Any) {
        
        guard labelOutlet != nil else { return }
        guard activityIndicator != nil else { return }
        
        if(activityIndicator.isAnimating){
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        }
        
        numberOfTaps += 1
        labelOutlet.text = "\(labelText) \(numberOfTaps)"
    }
}
