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
        
        setUpNoPlaylistsView()
        // Make function
        fetchPlaylist()
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
    
    // Function setUpNoPlaylistsView
    private func setUpNoPlaylistsView() {
        view.addSubview(noPlaylistsView)
        noPlaylistsView.delegate = self
        noPlaylistsView.configure(
            with: ActionLabelViewViewModel(
                text: "No playlist yet!",
                actionTitle: "Create"
            )
        )
    }
    // Fetch playlist
    private func fetchPlaylist() {
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
// To get the create button call on the ActionLabel
extension LibraryPlaylistsViewController: ActionLabelViewDelegate {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        // Show Creation UI
        
        // Show Alert
        let alert = UIAlertController(
            title: "New Playlists",
            message: "Enter playlist name!",
            preferredStyle: .alert
        )
        // Add text field
        alert.addTextField { textField in
            textField.placeholder = "Playlist..."
        }
        
        // Two buttons
        alert.addAction(UIAlertAction(
                            title: "Cancel",
                            style: .cancel,
                            handler: nil))
        
        alert.addAction(UIAlertAction(
                            title: "Create",
                            style: .default,
                            handler: {_ in
                                // Get the textField out
                guard let field = alert.textFields?.first,
                      // Get text out
                      let text = field.text,
                      // Validate that the text is not empty
                      !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                    
                    return
                }
                                
                                APICaller.shared.createPlaylist(with: text) { success in
                                    if success {
                                        // Refresh the playlists
                                    }
                                    else {
                                        
                                        print("Failed to create playlist")
                                    }
                                }
                                
            }))
        
        // Show this alert
        present(alert, animated: true)
    }
}
