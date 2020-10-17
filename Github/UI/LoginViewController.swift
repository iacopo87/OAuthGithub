//
//  LoginViewController.swift
//  Github
//
//  Created by Iacopo Pazzaglia on 17/10/2020.
//

import UIKit

class LoginViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func onLoginClick(_ sender: Any) {
    }
}
