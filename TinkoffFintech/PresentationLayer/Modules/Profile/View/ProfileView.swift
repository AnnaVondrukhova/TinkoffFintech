//
//  ProfileView.swift
//  TinkoffFintech
//
//  Created by Anya on 11.11.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import Foundation
import UIKit

class ProfileView: UIView {
    var avatarView: AvatarView = {
        let view = AvatarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constants.userPhotoBackgrounColor
        return view
    }()
    
    var nameTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont.systemFont(ofSize: 26, weight: .semibold)
        tf.textAlignment = .center
        return tf
    }()
    
    var descriptionTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 16)
        return tv
    }()
    
    var saveWithGCDButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 14
        button.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        button.setTitle("Save with GCD", for: .normal)
        button.tag = 0
        return button
    }()
    
    var saveWithOperationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 14
        button.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        button.setTitle("Save with Operation", for: .normal)
        button.tag = 1
        return button
    }()
    
    let avatarViewWidth = min(240.0, UIScreen.main.bounds.height * 0.3)
    let fontSize = min(120.0, UIScreen.main.bounds.height * 0.15)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpConstraints()
        setUpElements()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUpConstraints()
        setUpElements()
    }
    
    func setUpConstraints() {
        self.addSubview(avatarView)
        self.addSubview(nameTextField)
        self.addSubview(descriptionTextView)
        self.addSubview(saveWithGCDButton)
        self.addSubview(saveWithOperationButton)
        
        let avatarViewConstraints = [avatarView.heightAnchor.constraint(equalToConstant: avatarViewWidth),
                                     avatarView.widthAnchor.constraint(equalToConstant: avatarViewWidth),
                                     avatarView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                                     avatarView.topAnchor.constraint(equalTo: self.topAnchor, constant: 7)]
        let nameTextFieldConstraints = [nameTextField.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 32),
                                        nameTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
                                        nameTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                                        nameTextField.heightAnchor.constraint(equalToConstant: 30)]
        let descriptionTextViewConstraints = [descriptionTextView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 25),
                                              descriptionTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
                                              descriptionTextView.centerXAnchor.constraint(equalTo: self.centerXAnchor)]
        let saveWithGCDButtonConstraints = [saveWithGCDButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 5),
                                            saveWithGCDButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 56),
                                            saveWithGCDButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                                            saveWithGCDButton.heightAnchor.constraint(equalToConstant: 40)]
        let saveWithOperationButtonConstraints =  [saveWithOperationButton.topAnchor.constraint(equalTo: saveWithGCDButton.bottomAnchor, constant: 10),
                                                   saveWithOperationButton.leadingAnchor.constraint(equalTo: saveWithGCDButton.leadingAnchor),
                                                   saveWithOperationButton.centerXAnchor.constraint(equalTo: saveWithGCDButton.centerXAnchor),
                                                   saveWithOperationButton.heightAnchor.constraint(equalToConstant: 40),
                                                   saveWithOperationButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30)]
        
        NSLayoutConstraint.activate(avatarViewConstraints)
        NSLayoutConstraint.activate(nameTextFieldConstraints)
        NSLayoutConstraint.activate(descriptionTextViewConstraints)
        NSLayoutConstraint.activate(saveWithGCDButtonConstraints)
        NSLayoutConstraint.activate(saveWithOperationButtonConstraints)
    }
    
    func configureAvatarView(with user: User) {
        avatarView.layer.cornerRadius = avatarViewWidth / 2
        avatarView.configure(image: user.photo, name: user.name, fontSize: fontSize, cornerRadius: avatarViewWidth / 2)
    }
    
    func configureAvatarView(with image: UIImage) {
        avatarView.layer.cornerRadius = avatarViewWidth / 2
        avatarView.configure(image: image, cornerRadius: avatarViewWidth / 2)
    }
    
    func setUpElements() {
        avatarView.isUserInteractionEnabled = true
        avatarView.layer.cornerRadius = avatarViewWidth / 2
        
        nameTextField.isEnabled = false
        descriptionTextView.isEditable = false
        saveWithGCDButton.isEnabled = false
        saveWithOperationButton.isEnabled = false
    }
}
