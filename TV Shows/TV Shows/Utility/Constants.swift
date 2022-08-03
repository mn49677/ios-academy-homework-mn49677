//
//  Constants.swift
//  TV Shows
//
//  Created by mn on 20.07.2022..
//

import Foundation

enum Constants {
    enum ViewControllers {
        static var login = "LoginViewController"
        static var home = "HomeViewController"
        static var details = "ShowDetailsViewController"
        static var review = "WriteReviewViewController"
        static var profile = "ProfileViewController"
    }
    
    enum Storyboards {
        static var login = "Login"
        static var splash = "SplashScreen"
    }
    
    enum Assets {
        static var visibilityIcon = "visibility-icon.png"
        static var nonVisibileIcon = "visibility-2-icon.png"
    }
    
    enum Keys {
        static var authInfo = "authInfo"
        static var username = "username"
        static var password = "password"
    }
    
    enum App {
        static var bundleIdentifier = "com.infinum-academy-mn49677.TV-Shows"
    }
    
    enum Notifications {
        static var logout = NSNotification.Name("didLogout")
    }
}
