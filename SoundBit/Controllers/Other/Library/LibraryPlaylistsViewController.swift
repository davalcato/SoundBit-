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
    
    // Add closure of selectionHandler
    public var selectionHandler: ((Playlist) -> Void)?
    
    // Hold an instance on the controller
    private let noPlaylistsView = ActionLabelView()
    
    // Create an instance for a tableview
    private let tableView: UITableView = {
        // Cells register in tableView
        let tableView = UITableView(frame: .zero, style: .grouped)
        // Register a cell
        tableView.register(SearchResultSubtitleTableViewCell.self,
                           forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        // TableView hidden
        tableView.isHidden = true
        return tableView
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Background Color
        view.backgroundColor = .systemBackground
        // Unhided tableView if playlist is not empty
        tableView.delegate = self
        tableView.dataSource = self
        // Add as subview
        view.addSubview(tableView)
        // Add as a subview noPlaylistsView
        view.addSubview(noPlaylistsView)
        setUpNoPlaylistsView()
        // Make function
        fetchPlaylist()
        
        // Cancel barbutton selectionHandler
        if selectionHandler != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .close,
                target: self,
                action: #selector(didTapClose))
        }
        
    }
    
    @objc func didTapClose() {
        dismiss(animated: true, completion: nil)
        
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
        //Add frame for tableView playlist
        tableView.frame = view.bounds
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
            // tableView is hidden
            tableView.isHidden = true
        }
        
        else {
            // Show table playlist
            tableView.reloadData()
            noPlaylistsView.isHidden = true
            tableView.isHidden = false
        }
    }
    // Public function
    public func showCreatePlaylistAlert() {
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
                                
                                APICaller.shared.createPlaylist(with: text) { [weak self] success in
                                    if success {
                                        // Refresh the playlists
                                        self!.fetchPlaylist()
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
// To get the create button call on the ActionLabel
extension LibraryPlaylistsViewController: ActionLabelViewDelegate {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
       showCreatePlaylistAlert()
    }
}

extension LibraryPlaylistsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Guard when casting the viewModel
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath
            // Cast it with the viewModel
        ) as? SearchResultSubtitleTableViewCell else {
            return UITableViewCell()
        }
        // Get playlist at given position
        let playlist = playlists[indexPath.row]
        cell.configure(with: SearchResultSubtitleTableViewCellViewModel(
                        title: playlist.name,
                        subtitle: playlist.owner.display_name,
                        imageURL: URL(string: playlist.images.first?.url ?? "")))
        return cell
    }
    
    // Delegate function for tableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Playlist collection
        let playlist = playlists[indexPath.row]
        // Check if selectionHandler is set or not
        guard selectionHandler == nil else {
            // Pass in the playlist
            selectionHandler?(playlist)
            dismiss(animated: true, completion: nil)
            return
            
        }
        // Open playlist - pass to reusable ViewController
        let vc = PlaylistViewController(playlist: playlist)
        vc.navigationItem.largeTitleDisplayMode = .never
        // isOwner bool to swipe to delete playlist
        vc.isOwner = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // Change the height of the cells
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
        
    }
}
