//
//  ProfileViewController.swift
//  TV Shows
//
//  Created by Maximilian Novak on 02.08.2022..
//

import UIKit
import Kingfisher
import Alamofire

class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    private var authInfo: AuthInfo?
    private var userInfo: User?
    
    // MARK: - Outlets

    @IBOutlet weak var profilePhotoImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    // MARK: - Actions
    
    @IBAction func logoutButtonClicked(_ sender: Any) {
        dismiss(animated: true) {
            KeychainAccess.removeAll()
            let nc = NotificationCenter.default
            nc.post(name: Constants.Notifications.logout, object: nil)
        }
        
    }
    
    @IBAction func changePofilePhotoClicked(_ sender: Any) {
        present(getImagePickerController(), animated: true)
    }
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProfileInfo()
    }

}

extension ProfileViewController {
    
    private func setupUI() {
        navigationItem.title = "My account"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(close))
        setupUserData()
    }
    
    private func setupUserData() {
        guard let userInfo = userInfo else  { return }
        let imageUrl = userInfo.imageUrl != nil
        ? URL(string: userInfo.imageUrl!)
        : nil
        usernameLabel.text = userInfo.email
        profilePhotoImage.kf.setImage(
            with: imageUrl,
            placeholder: UIImage(named: "ic-profile-placeholder"))
    }
    
    @objc func close() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    private func getImagePickerController() -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        return imagePicker
    }
    
    
   func storeImage(_ image: UIImage) {
       guard let imageData = image.jpegData(compressionQuality: 0.9) else { return }
       guard let headers = authInfo?.headers else { return }

       let requestData = MultipartFormData()
       requestData.append(
           imageData,
           withName: "image",
           fileName: "image.jpg",
           mimeType: "image/jpg")
       AF
       .upload(
           multipartFormData: requestData,
           to: "https://tv-shows.infinum.academy/users",
           method: .put,
           headers: HTTPHeaders(headers)
       )
       .validate()
       .responseDecodable(of: UserResponse.self) { [weak self] dataResponse in
           guard let self = self else  { return }
           switch dataResponse.result {
           case .success(let userResponse):
               self.userInfo = userResponse.user
               self.setupUserData()
           case .failure(let error):
               print(error)
           }
       }
   }
}

extension ProfileViewController {
    
    private func getProfileInfo() {
        guard let headers = authInfo?.headers else { return }
        AF .request(
              "https://tv-shows.infinum.academy/users/me",
              method: .get,
              headers: HTTPHeaders(headers)
          )
          .validate()
          .responseDecodable(of: UserResponse.self) { [weak self] dataResponse in
              guard let self = self else { return }
              switch dataResponse.result {
              case .success(let userResponse):
                  self.userInfo = userResponse.user
                  self.setupUI()
              case .failure(_):
                  print("Error")
              }
          }
    }
}

extension ProfileViewController {
    
    func configure(authInfo: AuthInfo?) {
        self.authInfo = authInfo
    }
}

extension ProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        storeImage(image)
        self.dismiss(animated: true)
    }
}
