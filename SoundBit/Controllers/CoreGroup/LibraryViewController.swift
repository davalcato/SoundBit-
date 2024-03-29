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
    
    // Create instance of LibraryToggleView
    private let toggleView = LibraryToggleView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(toggleView)
        // Assign delegate of LibraryToggleViewDelegate
        toggleView.delegate = self
        
        // Set the delegate for the scrollview
        scrollView.delegate = self
        
        view.addSubview(scrollView)
    
        // Add swipe
        scrollView.contentSize = CGSize(
            width: view.width*2,
            height: scrollView.height)
        
        // Add children
        addChildren()
        // Add a bar button playlist on Playlist not Album
        updateBarButtons()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top+55,
            width: view.width,
            height: view.height-view.safeAreaInsets.top-view.safeAreaInsets.bottom-55
        )
        // Toggle frame
        toggleView.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: 200,
            height: 55)
    }
    // Create updateBarButtons function
    private func updateBarButtons() {
        switch toggleView.state {
        case .playlist:
            // Show BarButton
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(didTapAdd))
        case .album:
            navigationItem.rightBarButtonItem = nil
        }
    }
    // Create the selector
    @objc private func didTapAdd() {
        // Call the function that shows the alert
        playlistsVC.showCreatePlaylistAlert()
        
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
        
        addChild(albumsVC)
        // Allows view lifecycle functions to work on playlist
        scrollView.addSubview(albumsVC.view)
        // Views frame
        albumsVC.view.frame = CGRect(
            x: view.width,
            y: 0,
            width: scrollView.width,
            height: scrollView.height)
        // Did become child of parent
        albumsVC.didMove(toParent: self)
    }
}

extension LibraryViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            // What the x offset is
            if scrollView.contentOffset.x >= (view.width-100) {
                toggleView.update(for: .album)
                // Call updateBarButton when the toggle changes
                updateBarButtons()
            }
            else {
                toggleView.update(for: .playlist)
                // Update here
                updateBarButtons()
            }
        
    }
}

extension LibraryViewController: LibraryToggleViewDelegate {
    func LibraryToggleViewDidTapPlaylists(_ toggleView: LibraryToggleView) {
        // Scroll the view
        scrollView.setContentOffset(.zero, animated: true)
        // Update here
        updateBarButtons()
    }
    
    func LibraryToggleViewDidTapAlbums(_ toggleView: LibraryToggleView) {
        scrollView.setContentOffset(CGPoint(x: view.width, y: 0), animated: true)
        // Update here
        updateBarButtons()
    }

}
