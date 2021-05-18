//
//  LibraryViewController.swift
//  SoundBit
//
//  Created by Daval Cato on 2/20/21.
//

import UIKit

class LibraryViewController: UIViewController {
    
    // Two controllers
    private let playlistsVC = LibraryPlaylistsViewController()
    private let albumsVC = LibraryAlbumsViewController()
    
    // ScrollView
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // Set the delegate for the scrollview
        scrollView.delegate = self
        
        view.addSubview(scrollView)
        // Background color on scrollview
        scrollView.backgroundColor = .yellow
        // Add swipe
        scrollView.contentSize = CGSize(
            width: view.width*2,
            height: scrollView.height)
        
        // Add children
        addChildren()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top+55,
            width: view.width,
            height: view.height-view.safeAreaInsets.top-view.safeAreaInsets.bottom-55
        )
    }
    
    // Implementing the children
    private func addChildren() {
        addChild(playlistsVC)
        // Allows view lifecycle functions to work on playlist
        scrollView.addSubview(playlistsVC.view)
        // Views frame
        playlistsVC.view.frame = CGRect(
            x: 0,
            y: 0,
            width: scrollView.width,
            height: scrollView.height)
        // Did become child of parent
        playlistsVC.didMove(toParent: self)
    }
}

extension LibraryViewController: UIScrollViewDelegate {
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        
    }
    
}
