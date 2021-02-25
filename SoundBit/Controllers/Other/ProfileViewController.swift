//
//  ProfileViewController.swift
//  SoundBit
//
//  Created by Daval Cato on 2/20/21.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Calling the API here
        title = "Profile"
        fetchProfile()
        view.backgroundColor = .systemBackground
    }
    private func fetchProfile() {
            APICaller.shared.getCurrentUserProfile { [weak self] result in
                DispatchQueue.main.async {
                    self?.failedToGetProfile()
            }
        }
    }
    private func updateUI(with: UserProfile) {
        
        
    }
    private func failedToGetProfile() {
        let label = UILabel(frame: .zero)
        label.text = "Failed to load profile."
        label.sizeToFit()
        label.textColor = .secondaryLabel
        view.addSubview(label)
        label.center = view.center
    }
}
