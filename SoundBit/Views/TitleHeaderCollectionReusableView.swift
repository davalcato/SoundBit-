//
//  TitleHeaderCollectionReusableView.swift
//  SoundBit
//
//  Created by Daval Cato on 4/11/21.
//

import UIKit

class TitleHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "TitleHeaderCollectionReusableView"
    
    // Single view
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 22, weight: .regular)
        
        return label
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(label)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 15,
                             y: 0,
                             width: width-30,
                             height: height)
    }
    
    
    func configure(with title: String) {
        // Assign text title
        label.text = title
    }
        
}
