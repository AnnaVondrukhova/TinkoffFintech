//
//  ViewController.swift
//  TinkoffFintech
//
//  Created by Anya on 11.09.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import UIKit
import os

extension Log {
    static let viewController = OSLog(subsystem: subsystem, category: "viewController")
}

class ProfileViewController: UIViewController, AlertPresentable {
    
    @IBOutlet var avatarView: AvatarView!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var detailsLabel: UILabel!
    @IBOutlet var saveButton: UIButton!
    var imagePicker: UIImagePickerController!
    
    var user = User.testUser
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        //os_log не сработает, выдается ошибка "Unexpectedly found nil while implicitly unwrapping an Optional value"
        //Это происходит из-за того, что основная view клнтроллера и ее subviews в этот момент еще не загружены, они загружаются позже, в методе loadView()
//        os_log("Frame in init: %s", log: Log.viewController, type: .info, "\(saveButton.frame)")
    }
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        saveButton.layer.cornerRadius = 14
        
        os_log("Frame in viewDidLoad: %s", log: Log.viewController, type: .info, "\(saveButton.frame)")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureElements(with: user)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        configureAvatarView(with: userMarina)
        
        os_log("Frame in viewDidAppear: %s", log: Log.viewController, type: .info, "\(saveButton.frame)")
        //метод ViewDidLoad вызывается до того, как определяются окончательные границы экрана, это происходит в viewDidLayoutSubviews. В данном случае в viewDidLoad используются размеры экрана из сториборда, настроенного на iPhone SE, поэтому в viewDidLoad ширина кнопки Save и ее положение, привязанные к размерам экрана, отличаются от финальных размеров и положения кнопки, которые определяются во viewDidLayoutSubviews после определения размеров экрана для iPhone 11.
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        let choosePhotoAction = UIAlertAction(title: "Choose photo", style: .default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                self.showAlert(title: "Error", message: "No access to Photo Library", preferredStyle: .alert, actions: [okAction], completion: nil)
            }

        }
        let takePhotoAction = UIAlertAction(title: "Take photo", style: .default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .camera
                self.imagePicker.cameraDevice = .front
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                self.showAlert(title: "Error", message: "Camera is not available", preferredStyle: .alert, actions: [okAction], completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        self.showAlert(title: "Change photo", message: nil, preferredStyle: .actionSheet, actions: [choosePhotoAction, takePhotoAction, cancelAction], completion: nil)

    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        User.testUser = user
    }
    
    func configureElements(with user: User) {
        nameLabel.text = user.name
        detailsLabel.text = user.description
        
        configureAvatarView(with: user)
    }
    
    func configureAvatarView(with user: User) {
        avatarView.layer.cornerRadius = avatarView.bounds.width/2
        avatarView.backgroundColor = Constants.userPhotoBackgrounColor
        avatarView.configure(image: user.photo, name: user.name, fontSize: 120, cornerRadius: avatarView.layer.cornerRadius)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newPhoto = UIImage()
        
        if let photo = info[.editedImage] as? UIImage {
            newPhoto = photo
        } else if let photo = info[.originalImage] as? UIImage {
            newPhoto = photo
        } else {
            return
        }
        
        user.photo = newPhoto
        avatarView.configure(image: user.photo, cornerRadius: avatarView.bounds.width/2)
        dismiss(animated: true, completion: nil)
    }
}

