//
//  PlayerViewController.swift
//  SoundBit
//
//  Created by Daval Cato on 2/20/21.
//

import UIKit
import SDWebImage

class PlayerViewController: UIViewController {
    
    // An instance of the dataSource
    weak var dataSource: PlayerDataSource?
    
    // Adding a single view
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemBlue
        
        return imageView
    }()
    
    // Adding the PlayerControlsView to the UI
    private let controlsView = PlayerControlsView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(controlsView)
        controlsView.delegate = self
        configureBarButtons()
        configure()
        
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
        
        controlsView.frame = CGRect(
            x: 10,
            y: imageView.bottom+10,
            width: view.width-20,
            height: view.height-imageView.height-view.safeAreaInsets.top-view.safeAreaInsets.bottom-15)
    }
    // Pulls in the imageView provided by the datasource
    private func configure() {
        imageView.sd_setImage(with: dataSource?.imageURL, completed: nil)
        // Configure the controlview with the viewModel
        controlsView.configure(with: PlayerControlsViewViewModel(title: dataSource?.songName, subtitle: dataSource?.subtitle)
        )
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

// Conformed to the protocol PlayerViewController
extension PlayerViewController: PlayerControlsViewDelegate {
    func PlayerControlsViewDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView) {
        
    }
    
    func PlayerControlsViewDidTapForwardButton(_ playerControlsView: PlayerControlsView) {
        
    }
    
    func PlayerControlsViewDidTapBackwardsButton(_ playerControlsView: PlayerControlsView) {
        
    }
    
    
    
}
