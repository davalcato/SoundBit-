//
//  WelcomeViewController.swift
//  SoundBit
//
//  Created by Daval Cato on 2/20/21.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    // Create the button here
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In with SoundBit", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SoundBit"
        view.backgroundColor = .systemGreen
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
         
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInButton.frame = CGRect(
            x: 20,
            y: view.height-50-view.safeAreaInsets.bottom,
            width: view.width-40, height: 50)
        
    }
    
    // Action handler for the button
    @objc func didTapSignIn() {
        // When tapped we're going to create an instance of th e view controller
        let vc = AuthViewController()
        vc.completionHandler = { success in
            DispatchQueue.main.async {
                self.handleSignIn(success: success)
            }
        }
        
        vc.navigationItem.largeTitleDisplayMode = .never
        // Here we push the viewcontroller onto the screen
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    private func handleSignIn(success: Bool) {
        // Here the user is Logged In
        guard success else {
            // If there's an error
            let alert = UIAlertController(title: "Oops",
                                          message: "Something went wrong when trying to sign In.",
                                          preferredStyle: .alert)
            // Here is the dismiss button
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
            
        }
        
        let mainAppTabBarVC = TabBarViewController()
        //Create an instance of the TabBarViewController
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVC, animated: true)
        
    }
    
}
