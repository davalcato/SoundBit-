//
//  SearchResulDefaultTableViewCell.swift
//  SoundBit
//
//  Created by Daval Cato on 5/2/21.
//

import UIKit
import SDWebImage

class SearchResulDefaultTableViewCell: UITableViewCell {
    static let identifier = "SearchResulDefaultTableViewCell"
    
    // Cell to have a single image and title
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(iconImageView)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.frame = CGRect(
            x: 10,
            y: 0,
            width: contentView.height,
            height: contentView.height)
        label.frame = CGRect(
            x: iconImageView.right+10,
            y: 0,
            width: contentView.width-iconImageView.right-15,
            height: contentView.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
    }
    
    func configure(with viewModel: SearchResulDefaultTableViewCellViewModel) {
        label.text = viewModel.title
        iconImageView.sd_setImage(
            with: viewModel.imageURL,
            completed: nil)
        
    }
    
}
