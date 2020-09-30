//
//  SentMessageCell.swift
//  TinkoffFintech
//
//  Created by Anya on 28.09.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import UIKit

class SentMessageCell: UITableViewCell, ConfigurableView {

    let messageView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.sentMessageViewColor
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpLayers()
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUpLayers() {
        contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        contentView.addSubview(messageView)
        messageView.addSubview(messageLabel)
        
        messageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0).isActive = true
        messageView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: contentView.frame.width/4).isActive = true
        messageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0).isActive = true
        messageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 5.0).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 15.0).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -5.0).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -15.0).isActive = true
    }
    
    func configure(with model: MessageCellModel) {
        messageLabel.text = model.text
    }

}
