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
    private var headers: Dictionary<String, String>?
    private var visibilityButton: UIButton?
    private var canGoToHomeController: Int = 0

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
                self.headers = dataResponse.response?.headers.dictionary
                print("Saved headers: \(String(describing: self.headers))")
                switch dataResponse.result {
                case .success(let userResponse):
                    self.responseToSuccess(userResponse: userResponse)
                case .failure(let error):
                    self.responseToError(error: error)
                }
                print("user response saved")
            }
    }
}

private extension LoginViewController {
    
    // MARK: - Handle successful login or registration
    
    func responseToSuccess(userResponse: UserResponse){
        self.userResponse = userResponse
        print("User email: \(String(describing: userResponse.user.email))")
        print("User id: \(String(describing: userResponse.user.id))")
        pushHomeViewController()
    }
    
    // MARK: - Handle failed login or registration
    
    func responseToError(error: AFError){
        print("Error: \(error)")
        showSimpleAlert()
    }
    
    // MARK: - Push home view controller
    
    func pushHomeViewController() {
        guard let headers = headers else { return }
        let homeController = storyboard?.instantiateViewController(withIdentifier: Constants.ViewControllers.home) as? HomeViewController
        homeController?.userResponse = userResponse
        do {
            try homeController?.authInfo = AuthInfo(headers: headers)
        } catch {
            print("Fail")
        }
        if let homeController = homeController {
            navigationController?.setViewControllers([homeController], animated: true)
        }
    }
}

extension LoginViewController {
    
    // MARK: - Other internal methods

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
    
    func showSimpleAlert() {
        let alert = UIAlertController(title: "Login/registration failed.", message: "Please try again.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
        self.present(alert, animated: true, completion: nil)
    }
}
