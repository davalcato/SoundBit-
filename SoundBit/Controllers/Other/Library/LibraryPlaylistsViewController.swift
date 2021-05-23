//
//  LibraryPlaylistsViewController.swift
//  SoundBit
//
//  Created by Daval Cato on 5/18/21.
//

import UIKit

class LibraryPlaylistsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Background Color
        view.backgroundColor = .systemBackground
        
        // Call API
        APICaller.shared.getCurrentUserPlaylist { result in
            switch result {
            case .success(let playlists): break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
