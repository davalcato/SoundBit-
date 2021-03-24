//
//  PlaylistHeaderCollectionReusableView.swift
//  SoundBit
//
//  Created by Daval Cato on 3/24/21.
//

import UIKit
import SDWebImage


final class PlaylistHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "PlaylistHeaderCollectionReusableView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
