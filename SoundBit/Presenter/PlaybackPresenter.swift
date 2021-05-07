//
//  PlaybackPresenter.swift
//  SoundBit
//
//  Created by Daval Cato on 5/6/21.
//

import Foundation
import UIKit


final class PlaybackPresenter {
    
    static func startPlayback(from viewController: UIViewController,
                              track: AudioTrack
        ) {
        
        // Insatiate the viewcontroller
        let vc = PlayerViewController()
        viewController.present(vc, animated: true, completion: nil)
    }
    
    static func startPlayback(from viewController: UIViewController,
                              album: Album
                              
        ) {
    }

    static func startPlayback(from viewController: UIViewController,
                              playlist: Playlist
                              
        ) {
    }
}













