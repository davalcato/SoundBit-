//
//  FeaturedPlaylistCollectionViewCell.swift
//  SoundBit
//
//  Created by Daval Cato on 3/2/21.
//

import UIKit

class FeaturedPlaylistCollectionViewCell: UICollectionViewCell {
    static let identifier = "FeaturedPlaylistCollectionViewCell"
    
    private let playlistCoverImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
        
    }()
    
    private let playlistNameLabel: UILabel = {
       let label = UILabel()
        // Text will wrap if it needs to
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let creatorNameLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(playlistCoverImageView)
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(creatorNameLabel)
        // Fixing the text label overflow
        contentView.clipsToBounds = true
       
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Create a fixed heighted for the Creator playlist
        creatorNameLabel.frame = CGRect(
            x: 3,
            y: contentView.height-44,
            width: contentView.width-6,
            height: 44
        )
        playlistNameLabel.frame = CGRect(
            x: 3,
            y: contentView.height-90,
            width: contentView.width-6,
            height: 44
        )
        let imageSize = contentView.height-105
        playlistCoverImageView.frame = CGRect(
            x: (contentView.width-imageSize)/2,
            y: 3,
            width: imageSize,
            height: imageSize
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playlistNameLabel.text = nil
        playlistCoverImageView.image = nil
        creatorNameLabel.text = nil
       
    }
    // Func here takes a viewModel
    func configure(with viewModel: FeaturedPlaylistCellViewModel) {
        playlistNameLabel.text = viewModel.name
        playlistCoverImageView.sd_setImage(with: viewModel.artworkURL,
                                           completed: nil)
        creatorNameLabel.text = viewModel.creatorName
       
    }
    
}
