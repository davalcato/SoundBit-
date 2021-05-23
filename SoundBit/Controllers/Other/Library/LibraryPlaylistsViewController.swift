//
//  LibraryPlaylistsViewController.swift
//  SoundBit
//
//  Created by Daval Cato on 5/18/21.
//

import UIKit

class LibraryPlaylistsViewController: UIViewController {
    
    // Create playlist for switch state
    var playlists = [Playlist]()
    
    // Hold an instance on the controller
    private let noPlaylistsView = ActionLabelView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Background Color
        view.backgroundColor = .systemBackground
        // Add as a subview noPlaylistsView
        view.addSubview(noPlaylistsView)
        
        noPlaylistsView.configure(with: ActionLabelViewViewModel(text: "No playlist yet!", actionTitle: "Create"))
        
        // Call API using weak self to avoid retain sycle
        APICaller.shared.getCurrentUserPlaylists { [weak self] result in
            // Main thread for API call
            DispatchQueue.main.async {
                switch result {
                case .success(let playlists):
                    // Hold on to playlist
                    self?.playlists = playlists
                    self?.updateUI()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // Create frame
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noPlaylistsView.frame = CGRect(
            x: 0,
            y: 0,
            width: 150,
            height: 150)
        noPlaylistsView.center = view.center
        
    }
    
    // Tableview list of updateUI
    private func updateUI() {
        if playlists.isEmpty {
            // Show label
            noPlaylistsView.isHidden = false
            
        }
        else {
            // Show table playlist
        }
    }
}
