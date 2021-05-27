//
//  ActionLabelView.swift
//  SoundBit
//
//  Created by Daval Cato on 5/23/21.
//

import UIKit

// Create view model
struct ActionLabelViewViewModel {
    // Two things
    let text: String
    let actionTitle: String
    
}
// Create protocol for ActionLabelView delegate
 protocol ActionLabelViewDelegate: AnyObject {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView)
    
}
class ActionLabelView: UIView {
    // Hold delegate with weak reference
    weak var delegate: ActionLabelViewDelegate?
    
    // Add the two subviews
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        // Line wrap with 0
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()
    // Button
    private let button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)

        return button
    }()

   // Label button for updateUI
    override init(frame: CGRect) {
        super.init(frame: frame)
        // No over flow
        clipsToBounds = true
        // Hidden by default
        isHidden = true
        // Add label & button as subviews
        addSubview(button)
        addSubview(label)
        // Action tied to the button
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    // Use delegate for didTapButton
    @objc func didTapButton() {
        delegate?.actionLabelViewDidTapButton(self)
    }
    
    // Two subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        // Layout the button
        button.frame = CGRect(
            x: 0,
            y: height-40,
            width: width,
            height: 40)
        
        label.frame = CGRect(
            x: 0,
            y: 0,
            width: width,
            height: height-45)
        
    }
    // View model gets added to funcion
    func configure(with viewModel: ActionLabelViewViewModel) {
        // Assign labels text
        label.text = viewModel.text
        button.setTitle(viewModel.actionTitle, for: .normal)
        
    }
    
}
