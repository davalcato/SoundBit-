//
//  LibraryToggleView.swift
//  SoundBit
//
//  Created by Daval Cato on 5/18/21.
//

import UIKit

class LibraryToggleView: UIView {
    
    // Two buttons
    private let playlistButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Playlists", for: .normal)
        
        return button
    }()
    
    private let albumsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Albums", for: .normal)
        
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        addSubview(playlistButton)
        addSubview(albumsButton)
        
        // Add target to the buttons
        playlistButton.addTarget(self,
                                 action: #selector(didTapPlaylists),
                                 for: .touchUpInside)
        
        albumsButton.addTarget(self,
                                 action: #selector(didTapAlbums),
                                 for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapPlaylists() {
        
        
    }
    
    @objc private func didTapAlbums() {
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Layout both buttons
        playlistButton.frame = CGRect(
            x: 0,
            y: 0,
            width: 100,
            height: 50)
        
        albumsButton.frame = CGRect(
            x: playlistButton.right,
            y: 0,
            width: 100,
            height: 50)
    }
}
