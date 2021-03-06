//
//  NewReleaseCollectionViewCell.swift
//  SoundBit
//
//  Created by Daval Cato on 3/2/21.
//

import UIKit
import SDWebImage

class NewReleaseCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewReleaseCollectionViewCell"
    
    private let albumCoverImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
        
    }()
    
    private let albumNameLabel: UILabel = {
       let label = UILabel()
        // Text will wrap if it needs to
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    private let numberOfTracksLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .thin)
        label.numberOfLines = 0
        return label
    }()
    private let artistNameLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(artistNameLabel)
        // Fixing the text label overflow
        contentView.clipsToBounds = true
        contentView.addSubview(numberOfTracksLabel)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.height-10
        let albumLabelSize = albumNameLabel.sizeThatFits(CGSize(
                                                            width: contentView.width-imageSize-10,
                                                            height: contentView.height-10))
        albumNameLabel.sizeToFit()
        artistNameLabel.sizeToFit()
        numberOfTracksLabel.sizeToFit()
        
        // Image
        albumCoverImageView.frame = CGRect(
            x: 5,
            y: 5,
            width: imageSize,
            height: imageSize)
        // Making height it's own property
        let albumLabelHeight = min(60, albumLabelSize.height)
        
        // AlbumNameLabel
        albumNameLabel.frame = CGRect(
            x: albumCoverImageView.right+10,
            y: 5,
            width: albumLabelSize.width,
            height: albumLabelHeight)
        
        artistNameLabel.frame = CGRect(
            x: albumCoverImageView.right+10,
            y: albumNameLabel.bottom,
            // This buffers from the left and right
            width: contentView.width - albumCoverImageView.right-5,
            height: 26)
        
        numberOfTracksLabel.frame = CGRect(
            x: albumCoverImageView.right+10,
            y: albumCoverImageView.bottom-50,
            width: numberOfTracksLabel.width,
            height: 44)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        numberOfTracksLabel.text = nil
        albumCoverImageView.image = nil
    
    }
    // Func here takes a viewModel
    func configure(with viewModel: NewReleasesCellViewModel) {
        albumNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        numberOfTracksLabel.text = "Tracks: \(viewModel.numberOfTracks)"
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
}
