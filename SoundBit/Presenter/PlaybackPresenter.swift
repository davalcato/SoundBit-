//
//  PlaybackPresenter.swift
//  SoundBit
//
//  Created by Daval Cato on 5/6/21.
//

import Foundation
import UIKit


final class PlaybackPresenter {
    
    static func startPlayback(
        from viewController: UIViewController,
        track: AudioTrack
        ) {
        // Insatiate the viewcontroller
        let vc = PlayerViewController()
        vc.title = track.name
        // Wrapped in a navigationController
        viewController.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    static func startPlayback(
        from viewController: UIViewController,
        // Collections of multiple tracks 
        tracks: [AudioTrack]
        // Create the player viewcontroller
        ) {
        let vc = PlayerViewController()
        viewController.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        
        }
        
    }














