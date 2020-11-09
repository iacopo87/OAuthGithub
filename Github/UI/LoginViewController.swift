//
//  LoginViewController.swift
//  Github
//
//  Created by Iacopo Pazzaglia on 17/10/2020.
//

import UIKit
import SafariServices

class LoginViewController: UIViewController {
    let oAuthService: OAuthService
    private let makeHomeViewController: () -> UIViewController
    
    init(oAuthService: OAuthService ,makeHomeViewController: @escaping () -> UIViewController) {
        self.oAuthService = oAuthService
        self.makeHomeViewController = makeHomeViewController
      
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        oAuthService.onAuthenticationResult = { [weak self] in self?.onAuthenticationResult(result: $0) }
    }
    
    @IBAction func onLoginClick(_ sender: Any) {
        guard let url = oAuthService.getAuthPageUrl(state: "state") else { return }
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .fullScreen
        present(safariVC, animated: true, completion: nil)
    }
    
    func onAuthenticationResult(result: Result<TokenBag, Error>) {
        DispatchQueue.main.async {
            self.presentedViewController?.dismiss(animated: true) {
                switch result {
                case .success:
                    self.navigationController?.pushViewController(self.makeHomeViewController(), animated: true)

                case .failure:
                    let alert = UIAlertController(title: "Something went wrong :(",
                                                  message: "Authentication error",
                                                  preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }
}
