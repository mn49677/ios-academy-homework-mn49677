//
//  SplashViewController.swift
//  TV Shows
//
//  Created by mn on 19.07.2022..
//

import UIKit

final class SplashViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var logoImage: UIImageView!
    
    // MARK: - Parent
    
    override func viewDidLoad() {
        print("Entered splash screen")
        super.viewDidLoad()
        switchToLoginView()
    }
    
    // MARK: - Methods
    
    private func switchToLoginView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            print("Switching to login screen")
            
            let storyboard = UIStoryboard(name: Constants.Storyboards.LoginStoryboard, bundle: .main)
            let loginController = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllers.LoginViewController)
            self.navigationController?.pushViewController(loginController, animated: true)
        }
    }
}

private extension SplashViewController {

    @IBAction func navigateAction() {
        let storyboard = UIStoryboard(name: Constants.Storyboards.LoginStoryboard, bundle: .main)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllers.LoginViewController) as! LoginViewController
        navigationController?.pushViewController(loginViewController, animated: true)
    }
}
