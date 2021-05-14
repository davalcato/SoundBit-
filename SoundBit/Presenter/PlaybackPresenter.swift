//
//  PlaybackPresenter.swift
//  SoundBit
//
//  Created by Daval Cato on 5/6/21.
//

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
    
    func startPlayback(
        from viewController: UIViewController,
        track: AudioTrack
        ) {
        // The opposite
        self.track = track
        self.tracks = []
        
        // Insatiate the viewcontroller
        let vc = PlayerViewController()
        vc.title = track.name
        
        // Every time we create a datasource
        vc.dataSource = self
        
        // Wrapped in a navigationController
        viewController.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
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














