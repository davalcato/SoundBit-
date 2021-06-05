//
//  LibraryAlbumsViewController.swift
//  SoundBit
//
//  Created by Daval Cato on 5/18/21.
//

import UIKit

class LibraryAlbumsViewController: UIViewController {
    
        // Array of Album objects user saved
        var albums = [Album]()
    
        // Hold an instance on the controller
        private let noAlbumsView = ActionLabelView()
        
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
            view.backgroundColor = .green
            setUpNoAlbumsView()
            // Make function
            fetchPlaylist()
        }
        
        @objc func didTapClose() {
            dismiss(animated: true, completion: nil)
            
        }
        
        // Create frame
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            noAlbumsView.frame = CGRect(
                x: 0,
                y: 0,
                width: 150,
                height: 150)
//            noAlbumsView.center = view.center
            //Add frame for tableView playlist
//            tableView.frame = view.bounds
        }
        
        // Function setUpNoPlaylistsView
        private func setUpNoAlbumsView() {
            view.addSubview(noAlbumsView)
            noAlbumsView.delegate = self
            noAlbumsView.configure(
                with: ActionLabelViewViewModel(
                    text: "You have not saved any albums yet!",
                    actionTitle: "Browse"
                )
            )
        }
        // Fetch playlist
        private func fetchPlaylist() {
            // Call API using weak self to avoid retain sycle
            APICaller.shared.getCurrentUserAlbums { [weak self] result in
                // Main thread for API call
                DispatchQueue.main.async {
                    switch result {
                    case .success(let albums):
                        // Hold on to playlist
                        self?.albums = albums
                        self?.updateUI()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
        
        // Tableview list of updateUI
        private func updateUI() {
            if albums.isEmpty {
                noAlbumsView.backgroundColor = .red
                // Show label
                noAlbumsView.isHidden = false
                // tableView is hidden
                tableView.isHidden = true
            }
            
            else {
                // Reload tableView 
                tableView.reloadData()
                noAlbumsView.isHidden = true
                tableView.isHidden = false
            }
        }
    }
    // To get the create button call on the ActionLabel
    extension LibraryAlbumsViewController: ActionLabelViewDelegate {
        func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
           // Switch the user back to the browse tab
            tabBarController?.selectedIndex = 0
        }
    }

    extension LibraryAlbumsViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return albums.count
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // Guard when casting the viewModel
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath
                // Cast it with the viewModel
            ) as? SearchResultSubtitleTableViewCell else {
                return UITableViewCell()
            }
            // Get playlist at given position
            let album = albums[indexPath.row]
            cell.configure(with: SearchResultSubtitleTableViewCellViewModel(
                            title: album.name,
                            subtitle: album.artists.first?.name ?? "-",
                            imageURL: URL(string: album.images.first?.url ?? "")))
            return cell
        }
        
        // Delegate function for tableView
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            // When user selects albums
            let album = albums[indexPath.row]
            // Reusable ViewController
            let vc = AlbumViewController(album: album)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        }
        
        // Change the height of the cells
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 70
        }
    }
