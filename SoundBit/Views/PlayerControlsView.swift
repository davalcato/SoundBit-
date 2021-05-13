//
//  PlayerControlsView.swift
//  SoundBit
//
//  Created by Daval Cato on 5/9/21.
//

import Foundation
import UIKit

// Delegate to relay the button taps to the control (hold in weak - AnyObject)
protocol PlayerControlsViewDelegate: AnyObject {
    func PlayerControlsViewDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView)
    func PlayerControlsViewDidTapForwardButton(_ playerControlsView: PlayerControlsView)
    func PlayerControlsViewDidTapBackwardsButton(_ playerControlsView: PlayerControlsView)
}

final class PlayerControlsView: UIView {
    
    weak var delegate: PlayerControlsViewDelegate?
    
    // Create slide
    private let volumeSlider: UISlider = {
        let slider = UISlider()
        // The value of slider
        slider.value = 0.5
        return slider
    }()
    
    // Two labels
    private let namelabel: UILabel = {
        let label = UILabel()
        label.text = "Your song"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let subtitlelabel: UILabel = {
        let label = UILabel()
        label.text = "Sade (feat. Snoop Dogg)"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    // Three buttons
    private let backButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    private let playPauseButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "pause", withConfiguration: UIImage.SymbolConfiguration(
                                pointSize: 34,
                                weight: .regular))
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(namelabel)
        addSubview(subtitlelabel)
        
        addSubview(volumeSlider)
        
        addSubview(backButton)
        addSubview(nextButton)
        addSubview(playPauseButton)
        
        // Add targets to our buttons
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // Define the buttons delegate functions
    @objc private func didTapBack() {
        delegate?.PlayerControlsViewDidTapBackwardsButton(self)
    }
    
    @objc private func didTapNext() {
        delegate?.PlayerControlsViewDidTapForwardButton(self)
    }
    
    @objc private func didTapPlayPause() {
        delegate?.PlayerControlsViewDidTapPlayPauseButton(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        namelabel.frame = CGRect(
            x: 0,
            y: 0,
            width: width,
            height: 50)
        
        subtitlelabel.frame = CGRect(
            x: 0,
            y: namelabel.bottom+10,
            width: width,
            height: 50)
        
        volumeSlider.frame = CGRect(
            x: 10,
            y: subtitlelabel.bottom+40,
            width: width-20,
            height: 44)
        
        let buttonSize: CGFloat = 60
        
        playPauseButton.frame = CGRect(
            x: (width - buttonSize)/2,
                y: volumeSlider.bottom + 30,
                width: buttonSize,
                height: buttonSize)
        // Relational to the playPauseButton
        backButton.frame = CGRect(
            // X is the left origin of a frame so subtract the width of frame
            x: playPauseButton.left-80-buttonSize,
            y: playPauseButton.top,
            width: buttonSize,
            height: buttonSize)
        
        nextButton.frame = CGRect(
            x: playPauseButton.right+80,
            y: playPauseButton.top,
            width: buttonSize,
            height: buttonSize)
        
    }
}











