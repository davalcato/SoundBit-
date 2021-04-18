//
//  GenreCollectionViewCell.swift
//  SoundBit
//
//  Created by Daval Cato on 4/18/21.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    // Add the identifier
    static let identifier = "GenreCollectionViewCell"
    
    // Add two subviews
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        // Assign image
        imageView.image = UIImage(systemName: "music.quarternote.3",
                                  withConfiguration: UIImage.SymbolConfiguration(
                                    pointSize: 50,
                                    weight: .regular))
        
        return imageView
        
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        
        return label
    }()
    
    // Create random colors on the cell
    private let colors: [UIColor] = [
        .systemGreen,
        .systemPurple,
        .systemRed,
        .systemOrange,
        .systemBlue,
        .darkGray,
        .systemPink,
        .systemTeal
    ]
    
    // Add the initizier
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        // Add subviews to label
        contentView.addSubview(label)
        contentView.addSubview(imageView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Layout the label
        label.frame = CGRect(
            x: 10,
            y: contentView.height/2,
            width: contentView.width-20,
            height: contentView.height/2)
        
        imageView.frame = CGRect(
            x: contentView.width/2,
            y: 0,
            width: contentView.width/2,
            height: contentView.height/2)
    }
    
    // Configure the genre names
    func configure(with title: String) {
        label.text = title
        // Background color
        contentView.backgroundColor = colors.randomElement()
        
    }
    
}
