//
//  PlayerViewController.swift
//  SoundBit
//
//  Created by Daval Cato on 2/20/21.
//

import UIKit

class PlayerViewController: UIViewController {
    
    // Adding a single view
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemBlue
        
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        configureBarButtons()
        
    }
    
    // Build out the user interface
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Layout the imageView
        imageView.frame = CGRect(
            x: 0,
            y: 0,
            width: view.width,
            height: view.width)
    }
    
    // Add function
    private func configureBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapAction))
    }
    
    // Define the selector
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
        
    }
    // Bring up the actionsheet
    @objc private func didTapAction() {
        //
        
    }

}
