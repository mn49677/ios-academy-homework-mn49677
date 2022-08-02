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
    
    private var userResponse: UserResponse?
    private var headers: [String: String]?
    private var visibilityButton: UIButton?

    // MARK: - Outlets
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var rememberMeButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction func loginButtonTapped() {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        guard let email = email, let password = password else { return }
        loginUserWith(email: email, password: password, redirectToHome: true)
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
        animateLogo()
        
        #if DEBUG
        emailTextField.text = "john@doe.com"
        passwordTextField.text = "test1234"
        #endif
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
                encoder: JSONParameterEncoder.default
            )
            .validate()
            .responseDecodable(of: UserResponse.self) { [weak self] dataResponse in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                self.headers = dataResponse.response?.headers.dictionary
                switch dataResponse.result {
                case .success(let userResponse):
                    self.responseToSuccess(userResponse: userResponse, redirectToHome: true)
                case .failure(let error):
                    self.responseToError(error: error, button: self.registerButton)
                }
            }
    }
}

private extension LoginViewController {
    
    // MARK: - Login
    
    func loginUserWith(email: String, password: String, redirectToHome: Bool) {
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
                self.headers = dataResponse.response?.headers.dictionary
                switch dataResponse.result {
                case .success(let userResponse):
                    self.responseToSuccess(userResponse: userResponse, redirectToHome: redirectToHome)
                case .failure(let error):
                    self.responseToError(error: error, button: self.loginButton)
                }
                print("user response saved")
            }
    }
}

// MARK: - API handling

private extension LoginViewController {
        
    func responseToSuccess(userResponse: UserResponse, redirectToHome: Bool){
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        self.userResponse = userResponse
        if rememberMeButton.isSelected {
            rememberAuthInfo()
            rememberCredentials(username: email, password: password)
        }
        if redirectToHome {
            pushHomeViewController()
        }
    }
        
    func responseToError(error: AFError, button: UIButton){
        button.shake()
    }
}

// MARK: - Push home view controller

private extension LoginViewController {
    
    func pushHomeViewController() {
        guard let headers = headers else { return }
        let homeController = storyboard?.instantiateViewController(withIdentifier: Constants.ViewControllers.home) as! HomeViewController
        homeController.userResponse = userResponse
        do {
            try homeController.authInfo = AuthInfo(headers: headers)
        } catch { }
        navigationController?.setViewControllers([homeController], animated: true)
    }
}

// MARK: - Other internal methods

private extension LoginViewController {
    
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

private extension LoginViewController {
    func animateLogo() {
        let newTransform = CGAffineTransform(
            scaleX: 0.8, // 2 times the width
            y: 0.8
        )
//        .rotated(by: 40)
//        .translatedBy(x: 20, y: 0)

        UIView.animate(
            withDuration: 1,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5,
            options: [.curveEaseInOut, .autoreverse]) {

                self.logoImage.transform = newTransform

            } completion: { _ in
                self.logoImage.transform = .identity
            }
    }
}


private extension LoginViewController {
    
    func rememberAuthInfo() {
        guard let headers = headers else  { return }
        do {
            let authInfo = try AuthInfo(headers: headers)
            KeychainAccess.setAuthInfo(authInfo: authInfo)
            print("!!!!!!!Keychain: \(KeychainAccess.getAuthInfo()?.headers)")
        } catch {
            print("Error while saving...")
        }
    }
    
    func rememberCredentials(username: String, password: String) {
        KeychainAccess.setUsername(username: username)
        KeychainAccess.setPassword(password: password)
    }
}
