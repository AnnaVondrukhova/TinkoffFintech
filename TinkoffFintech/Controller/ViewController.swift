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

class ViewController: UIViewController {
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var initialsLabel: UILabel!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var occupationLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var saveButton: UIButton!
    var imagePicker: UIImagePickerController!
    
    let userMarina = User(name: "Marina Dudarenko", occupation: "UX/UI designer, web-designer", location: "Moscow, Russia")
    
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
        
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width/2
        saveButton.layer.cornerRadius = 14
                
        configureElements(with: userMarina)
        
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        os_log("Frame in viewDidAppear: %s", log: Log.viewController, type: .info, "\(saveButton.frame)")
        //метод ViewDidLoad вызывается до того, как определяются окончательные границы экрана, это происходит в viewDidLayoutSubviews. В данном случае в viewDidLoad используются размеры экрана из сториборда, настроенного на iPhone SE, поэтому в viewDidLoad ширина кнопки Save и ее положение, привязанные к размерам экрана, отличаются от финальных размеров и положения кнопки, которые определяются во viewDidLayoutSubviews после определения размеров экрана для iPhone 11.
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Change photo", message: nil, preferredStyle: .actionSheet)
        let choosePhotoAction = UIAlertAction(title: "Choose photo", style: .default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                AlertService.showAlert(in: self, message: "No access to Photo Library")
            }
            
        }
        let takePhotoAction = UIAlertAction(title: "Take photo", style: .default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .camera
                self.imagePicker.cameraDevice = .front
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                AlertService.showAlert(in: self, message: "Camera is not available")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(choosePhotoAction)
        alertController.addAction(takePhotoAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func configureElements(with user: User) {
        nameLabel.text = user.name
        occupationLabel.text = user.occupation
        locationLabel.text = user.location
        
        let initials = user.name.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first!)") + "\($1.first!)" }
        let initialsFont = UIFont(name: "Roboto-Regular", size: 120.0)
        initialsLabel.text = initials
        initialsLabel.font = initialsFont
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newPhoto = UIImage()
        
        if let photo = info[.editedImage] as? UIImage {
            newPhoto = photo
        } else if let photo = info[.originalImage] as? UIImage {
            newPhoto = photo
        } else {
            return
        }
        
        initialsLabel.isHidden = true
        avatarImageView.image = newPhoto
        dismiss(animated: true, completion: nil)
    }
}

