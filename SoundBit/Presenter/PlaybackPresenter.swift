//
//  PlaybackPresenter.swift
//  SoundBit
//
//  Created by Daval Cato on 5/6/21.
//

import AVFoundation
import Foundation
import UIKit

// Create a date source
protocol PlayerDataSource: AnyObject {
    var songName: String? { get }
    var subtitle: String? { get }
    var imageURL: URL? { get }
}

final class PlaybackPresenter {
    // A single shared instance of the controller
    static let shared = PlaybackPresenter()
    
    // Hold on to a reference of the track playing
    private var track: AudioTrack?
    private var tracks = [AudioTrack]()
    
    // Computed property
    var currentTrack: AudioTrack? {
        // Unwrap the track up above
        if let track = track, tracks.isEmpty {
            // Return if empty
            return track
        }
        // Return the current playing item
        else if let player = self.playerQueue, !tracks.isEmpty {
            // The item wanted is currentItem
            let item = player.currentItem
            // Then get list
            let items = player.items()
            // Find the index item
            guard let index = items.firstIndex(where: { $0 == item }) else {
                // If we're not able to find then current item is nil
                return nil
            }
            // If we do find the index
            return tracks[index]
        }
        return nil
    }
    
    // Create an optional player
    var player: AVPlayer?
    // Play tracks in a queue
    var playerQueue: AVQueuePlayer?
    
    func startPlayback(
        from viewController: UIViewController,
        track: AudioTrack
        ) {
        // Else to coalesce to an empty string
        guard let url = URL(string: track.preview_url ?? "") else {
            // If it fails we return
            return
        }
        // AVPlayer is created with url
        player = AVPlayer(url: url)
        player?.volume = 0.5
        
        // The opposite
        self.track = track
        self.tracks = []
        // Insatiate the viewcontroller
        let vc = PlayerViewController()
        vc.title = track.name
        
        // Every time we create a datasource
        vc.dataSource = self
        // Connecting the play buttons
        vc.delegate = self
        
        // Wrapped in a navigationController
        viewController.present(UINavigationController(rootViewController: vc), animated: true) { [weak self] in
            // In this completion block we start playing the audio
            self?.player?.play()
        }
    }
    
     func startPlayback(
        from viewController: UIViewController,
        // Collections of multiple tracks 
        tracks: [AudioTrack]
        // Create the player viewcontroller
        ) {
        // When we call either function
        self.tracks = tracks
        self.track = nil
       
        // Play songs in sequence
        self.playerQueue = AVQueuePlayer(items: tracks.compactMap({
            // Instantiate AVPlayerItem
            // Create the URL
            guard let url = URL(string: $0.preview_url ?? "") else {
                // Else coalesce into empty string if nil
                return nil
            }
            return AVPlayerItem(url: url)
        }))
        self.playerQueue?.volume = 0
        self.playerQueue?.play()
        
        let vc = PlayerViewController()
        // Every time we create a datasource
        vc.dataSource = self
        // Connecting the play buttons
        vc.delegate = self
        viewController.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        
        }
        
    }
// Conform to the protocol PlayerViewControllerDelegate
extension PlaybackPresenter: PlayerViewControllerDelegate {
    // Three functions
    func didTapPlayPause() {
        // Check if there's a player
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
            }
            else if player.timeControlStatus == .paused {
                player.play()
            }
        }
        else if let player = playerQueue {
            // Figure out if this player is playing
            if player.timeControlStatus == .playing {
                player.pause()
            }
            else if player.timeControlStatus == .paused {
                player.play()
            }
        }
    }
    
    func didTapForward() {
        if tracks.isEmpty {
            // Not playlist or album
            player?.pause()
        }
        // Check if we have a non-nil playerQueue
        else if let player = playerQueue {
            playerQueue?.advanceToNextItem()
        }
    }
    
    func didTapBackward() {
        if tracks.isEmpty {
            // Not playlist or album
            player?.pause()
            player?.play()
        }
        else if let firstItem = playerQueue?.items().first {
            playerQueue?.pause()
            playerQueue?.removeAllItems()
            playerQueue = AVQueuePlayer(items: [firstItem])
            playerQueue?.play()
            // Reset volume
            playerQueue?.volume = 0.8
        }
    }
    
    func didSlideSlider(_ value: Float) {
        player?.volume = value
    }
}

extension PlaybackPresenter: PlayerDataSource {
    var songName: String? {
        // Return for the song name 
        return currentTrack?.name
    }
    
    var subtitle: String? {
        return currentTrack?.artists.first?.name
    }
    
    var imageURL: URL? {
        print("Images: \(currentTrack?.album?.images.first)")
        return URL(string: currentTrack?.album?.images.first?.url ?? "")
        
    }
    
}














