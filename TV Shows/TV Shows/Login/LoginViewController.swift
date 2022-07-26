//
//  LoginViewController.swift
//  TV Shows
//
//  Created by mn on 11.07.2022..
//

import UIKit
import MBProgressHUD
import Alamofire

final class LoginViewController : UIViewController {
    
    // MARK: - Properties
    
    private var user: User?
    private var headers: HTTPHeaders?
    private var visibilityButton: UIButton?

    // MARK: - Outlets
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction func loginButtonTapped() {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        guard let email = email, let password = password else { return }
        loginUserWith(email: email, password: password)
    }
    
    @IBAction func registerButtonTapped() {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        guard let email = email, let password = password else { return }
        registerUserWith(email: email, password: password)
    }
    
    @IBAction func rememberMeButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @IBAction func setPasswordVisibilityButton(sender: UIButton) {
        guard let visibilityButton = visibilityButton else { return }
        passwordTextField.isSecureTextEntry.toggle()
        if passwordTextField.isSecureTextEntry == true {
            visibilityButton.setImage(UIImage(named: Constants.Assets.visibilityIcon), for: .normal)
        } else {
            visibilityButton.setImage(UIImage(named: Constants.Assets.nonVisibileIcon), for: .normal)
        }
    }
    @IBAction func emailTextChanged(_ sender: Any) {
        updateButtonState()
    }
    @IBAction func passwordTextChanged(_ sender: Any) {
        updateButtonState()
    }
    
    // MARK: - Lifecycle methods
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Methods
    
    private func setupUI() {
        // email placeholder white color
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        
        // password placeholder white color, secure entry
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        passwordTextField.isSecureTextEntry.toggle()
        visibilityButton = UIButton(type: .custom)
        visibilityButton!.setImage(UIImage(named: Constants.Assets.visibilityIcon), for: .normal)
        visibilityButton!.addTarget(self, action: #selector(setPasswordVisibilityButton(sender: )), for: .touchUpInside)
        passwordTextField.rightView = visibilityButton
        passwordTextField.rightViewMode = .always
        
        // setup buttons
        updateButtonState()
        registerButton.setTitleColor(.white, for: .disabled)
        registerButton.alpha = 0.5
        registerButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }
}

private extension LoginViewController {
    
    // MARK: - Registration
    
    func registerUserWith(email: String, password: String) {
        // start
        MBProgressHUD.showAdded(to: view, animated: true)
        let parameters: [String: String] = [
            "email": email,
            "password": password,
            "password_confirmation": password
        ]

        AF
            .request(
                "https://tv-shows.infinum.academy/users",
                method: .post,
                parameters: parameters,
                encoder: JSONParameterEncoder.default,
                headers: headers
            )
            .validate()
            .responseDecodable(of: UserResponse.self) { [weak self] dataResponse in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                switch dataResponse.result {
                case .success(let userResponse):
                    self.responseToSuccess(userResponse: userResponse)
                case .failure(let error):
                    self.responseToError(error: error)
                }
            }
    }
}

private extension LoginViewController {
    
    // MARK: - Login
    
    func loginUserWith(email: String, password: String) {
        MBProgressHUD.showAdded(to: view, animated: true)

        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]

        AF
            .request(
                "https://tv-shows.infinum.academy/users/sign_in",
                method: .post,
                parameters: parameters,
                encoder: JSONParameterEncoder.default
            )
            .validate()
            .responseDecodable(of: UserResponse.self) { [weak self] dataResponse in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                switch dataResponse.result {
                case .success(let userResponse):
                    self.responseToSuccess(userResponse: userResponse)
                case .failure(let error):
                    self.responseToError(error: error)
                }
            }
    }
}

private extension LoginViewController {
    
    // MARK: - Handle successful login or registration
    
    func responseToSuccess(userResponse: UserResponse){
        user = userResponse.user
        print("User email: \(String(describing: self.user?.email))")
        print("User id: \(String(describing: self.user?.id))")
        pushHomeViewController()
    }
    
    // MARK: - Handle failed login or registration
    
    func responseToError(error: AFError){
        print("Error: \(error)")
    }
    
    // MARK: - Push home view controller
    
    func pushHomeViewController() {
        let homeController = self.storyboard?.instantiateViewController(withIdentifier: Constants.ViewControllers.home)
        if let homeController = homeController {
            navigationController?.pushViewController(homeController, animated: true)
        }
    }
}

extension LoginViewController {

    private func updateButtonState() -> Void {
        
        if !self.emailTextField.hasText || !self.passwordTextField.hasText {
            loginButton.isEnabled = false
            registerButton.isEnabled = false
            registerButton.alpha = 0.5
            registerButton.setTitleColor(.white, for: .disabled)
        } else {
            loginButton.isEnabled = true
            registerButton.isEnabled = true
            registerButton.alpha = 0.5
        }
    }
}
