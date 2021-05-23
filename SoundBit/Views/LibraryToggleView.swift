//
//  LibraryToggleView.swift
//  SoundBit
//
//  Created by Daval Cato on 5/18/21.
//

import UIKit

// Delegate for tap event
protocol LibraryToggleViewDelegate: AnyObject {
    func LibraryToggleViewDidTapPlaylists(_ toggleView: LibraryToggleView)
    func LibraryToggleViewDidTapAlbums(_ toggleView: LibraryToggleView)
    
}

class LibraryToggleView: UIView {
    // Tap to update the state
    enum State {
        case playlist
        case album
        
    }
    // Update the state
    var state: State = .playlist
    
    // Weak reference to delegate
    weak var delegate: LibraryToggleViewDelegate?
    
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
    
    // UIView indicatorView
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        return view
        
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(playlistButton)
        addSubview(albumsButton)
        addSubview(indicatorView)
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
        // Tap Playlist state
        state = .playlist
        delegate?.LibraryToggleViewDidTapPlaylists(self)
        
    }
    
    @objc private func didTapAlbums() {
        state = .album
        delegate?.LibraryToggleViewDidTapAlbums(self)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Layout both buttons
        playlistButton.frame = CGRect(
            x: 0,
            y: 0,
            width: 100,
            height: 40)
        
        albumsButton.frame = CGRect(
            x: playlistButton.right,
            y: 0,
            width: 100,
            height: 40)
       // Layout based on the state
        switch state {
        case .playlist:
        // Layout frames
        indicatorView.frame = CGRect(
            x: 0,
            y: playlistButton.bottom,
            width: 100,
            height: 3)
        
        case .album:
        // Layout frames
        indicatorView.frame = CGRect(
            x: 100,
            y: playlistButton.bottom,
            width: 100,
            height: 3)
        }
    }
}
