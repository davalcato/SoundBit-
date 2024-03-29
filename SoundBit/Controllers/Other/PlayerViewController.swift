//
//  PlayerViewController.swift
//  SoundBit
//
//  Created by Daval Cato on 2/20/21.
//

import UIKit
import SDWebImage

// Define the protocol - AnyObject to hold in a weak way
protocol PlayerViewControllerDelegate: AnyObject {
    // Three functions
    func didTapPlayPause()
    func didTapForward()
    func didTapBackward()
    func didSlideSlider(_ value: Float)
    
}

class PlayerViewController: UIViewController {
    
    // An instance of the dataSource
    weak var dataSource: PlayerDataSource?
    // Connect the play buttons
    weak var delegate: PlayerViewControllerDelegate?
    // Adding a single view
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // Adding the PlayerControlsView to the UI
    private let controlsView = SoundBit.PlayerControlsView()

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
    // Add refreshUI function
    func refreshUI() {
        // Takes the datasource
        configure()
    }
}

// Conformed to the protocol PlayerViewController
extension PlayerViewController: PlayerControlsViewDelegate {
    func PlayerControlsViewDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapPlayPause()
        
    }
    
    func PlayerControlsViewDidTapForwardButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapForward()
    }
    
    func PlayerControlsViewDidTapBackwardsButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapBackward()
    }
    
    func PlayerControlsView(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float) {
        delegate?.didSlideSlider(value)
    

    }
}
