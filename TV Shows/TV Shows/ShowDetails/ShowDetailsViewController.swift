//
//  ShowDetailsViewController.swift
//  TV Shows
//
//  Created by mn on 27.07.2022..
//

import UIKit

final class ShowDetailsViewController: UIViewController {
    
    // MARK: - Properties
    public var authInfo: AuthInfo?
    public var show: Show?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = show?.title ?? "Unknown title"
    }

    
}
