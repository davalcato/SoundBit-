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
        // Otherwise the tracks collections is not empty
        else if !tracks.isEmpty {
            // Go ahead and return first track
            return tracks.first
        }
        return nil
    }
    
    // Create an optional player
    var player: AVPlayer?
    
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
        
        let vc = PlayerViewController()
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
    }
    
    func didTapForward() {
        if tracks.isEmpty {
            // Not playlist or album
            player?.pause()
            
        }
        else {
            
        }
    }
    
    func didTapBackward() {
        if tracks.isEmpty {
            // Not playlist or album
            player?.pause()
            player?.play()
        }
        else {
            
        }
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
        return URL(string: currentTrack?.album?.images.first?.url ?? "")
        
    }
    
}














