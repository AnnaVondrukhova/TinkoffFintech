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

class ProfileViewController: UIViewController, AlertPresentableProtocol {

    @IBOutlet var backgroundView: ProfileView!
    @IBOutlet var editBarButton: UIBarButtonItem!
    @IBOutlet var closeBarButton: UIBarButtonItem!
    
    var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            indicator.style = .large
        } else {
            indicator.style = .gray
        }
        return indicator
    }()
    var imagePicker: UIImagePickerController!
    
    var currentTheme: Theme
    private let themeService: ThemeServiceProtocol
    private let gcdFileService: SaveDataToFileServiceProtocol
    private let operationFileService: SaveDataToFileServiceProtocol
    
    var user = User()
    var delegate: ConversationListViewController!
    
    var isEditingProfile = false
    var photoIsSame = true
    
    init(themeService: ThemeServiceProtocol,
         gcdFileService: SaveDataToFileServiceProtocol,
         operationFileService: SaveDataToFileServiceProtocol) {
        self.themeService = themeService
        self.gcdFileService = gcdFileService
        self.operationFileService = operationFileService
        self.currentTheme = themeService.currentTheme
        
        super.init(nibName: "Profile", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        navigationController?.isNavigationBarHidden = false
        
        setUpSelectors()
        setColors()
        setUpActivityIndicator()
        
        //загрузка данных через GCD
        let loadService = gcdFileService
        
        //загрузка данных через Operation
//        let loadService = operationFileService
        
        activityIndicator.startAnimating()
        loadService.loadData { (name, description, photo) in
            self.user.name = name ?? "No name"
            self.user.description = description ?? "No description"
            self.user.photo = photo
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                
                self.backgroundView.nameTextField.text = self.user.name
                self.backgroundView.descriptionTextView.text = self.user.description
                
                self.backgroundView.configureAvatarView(with: self.user)
            }
        }
    }
    
    func setUpSelectors() {
        backgroundView.avatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (avatarTapped(_:))))
        backgroundView.saveWithGCDButton.addTarget(self, action: #selector(saveButtonPressed(_:)), for: .touchUpInside)
        backgroundView.saveWithOperationButton.addTarget(self, action: #selector(saveButtonPressed(_:)), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    func setColors() {
        self.backgroundView.backgroundColor = currentTheme.colors.backgroundColor
        editBarButton.tintColor = .systemBlue
        closeBarButton.tintColor = .systemBlue
        
        backgroundView.nameTextField.textColor = currentTheme.colors.baseFontColor
        backgroundView.descriptionTextView.textColor = currentTheme.colors.baseFontColor
        backgroundView.descriptionTextView.backgroundColor = currentTheme.colors.backgroundColor
        
        backgroundView.saveWithGCDButton.backgroundColor = currentTheme.colors.UIElementColor
        backgroundView.saveWithGCDButton.setTitleColor(currentTheme.colors.secondaryFontColor, for: .normal)
        
        backgroundView.saveWithOperationButton.backgroundColor = currentTheme.colors.UIElementColor
        backgroundView.saveWithOperationButton.setTitleColor(currentTheme.colors.secondaryFontColor, for: .normal)
    }
    
    func setUpActivityIndicator() {
        self.view.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        
        activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }

    // MARK: Keyboard functions
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        
        isEditingProfile.toggle()
        
        editBarButton.title = "Edit"
        backgroundView.nameTextField.isEnabled = false
        backgroundView.nameTextField.borderStyle = .none
        
        backgroundView.descriptionTextView.isEditable = false
        backgroundView.descriptionTextView.layer.borderWidth = 0.0
        
        compareFields()
    }
    
    @objc func avatarTapped(_ sender: Any) {
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
        
        let message = "Please choose one of the ways"
        self.showAlert(title: "Edit photo", message: message, preferredStyle: .actionSheet, actions: [choosePhotoAction, takePhotoAction, cancelAction], completion: nil)
    }
    
    @IBAction func editBarButtonPressed(_ sender: Any) {
        isEditingProfile.toggle()
        
        if isEditingProfile {
            editBarButton.title = "Done"
            
            backgroundView.nameTextField.isEnabled = true
            backgroundView.nameTextField.borderStyle = .line
            backgroundView.nameTextField.layer.borderColor = currentTheme.colors.secondaryFontColor.cgColor
            
            backgroundView.descriptionTextView.isEditable = true
            backgroundView.descriptionTextView.layer.borderWidth = 1.0
            backgroundView.descriptionTextView.layer.borderColor = currentTheme.colors.secondaryFontColor.cgColor
        } else {
            editBarButton.title = "Edit"
            backgroundView.nameTextField.isEnabled = false
            backgroundView.nameTextField.borderStyle = .none
            
            backgroundView.descriptionTextView.isEditable = false
            backgroundView.descriptionTextView.layer.borderWidth = 0.0
            
            compareFields()
        }
    }
    
    @IBAction func closeBarButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func compareFields() {
        let name = backgroundView.nameTextField.text
        let description = backgroundView.descriptionTextView.text
        
        if (name != self.user.name) || (description != self.user.description) || (!photoIsSame) {
            self.backgroundView.saveWithGCDButton.setTitleColor(.systemBlue, for: .normal)
            self.backgroundView.saveWithGCDButton.isEnabled = true
            self.backgroundView.saveWithOperationButton.setTitleColor(.systemBlue, for: .normal)
            self.backgroundView.saveWithOperationButton.isEnabled = true
        } else {
            self.backgroundView.saveWithGCDButton.setTitleColor(self.currentTheme.colors.secondaryFontColor, for: .normal)
            self.backgroundView.saveWithGCDButton.isEnabled = false
            self.backgroundView.saveWithOperationButton.setTitleColor(self.currentTheme.colors.secondaryFontColor, for: .normal)
            self.backgroundView.saveWithOperationButton.isEnabled = false
        }
    }

    // MARK: Saving data
    @objc func saveButtonPressed(_ sender: Any) {
        let tag = (sender as? UIButton)?.tag ?? 0
        saveToFile(tag: tag)
    }
    
    func saveToFile(tag: Int) {
        activityIndicator.startAnimating()
        
        self.backgroundView.isUserInteractionEnabled = false
        self.backgroundView.saveWithGCDButton.setTitleColor(self.currentTheme.colors.secondaryFontColor, for: .normal)
        self.backgroundView.saveWithGCDButton.isEnabled = false
        self.backgroundView.saveWithOperationButton.setTitleColor(self.currentTheme.colors.secondaryFontColor, for: .normal)
        self.backgroundView.saveWithOperationButton.isEnabled = false
        
        let name = (backgroundView.nameTextField.text == user.name) ? nil : backgroundView.nameTextField.text
        let description = (backgroundView.descriptionTextView.text == user.description) ? nil : backgroundView.descriptionTextView.text
        let photo = photoIsSame ? nil : backgroundView.avatarView.imageView.image
        
        if tag == 0 {
            gcdFileService.saveData(name: name, description: description, photo: photo) { (savedFields, fails) in
                self.savingCompletionBlock(savedFields: savedFields, fails: fails, tag: tag)
            }
        } else if tag == 1 {
            operationFileService.saveData(name: name, description: description, photo: photo) { (savedFields, fails) in
                self.savingCompletionBlock(savedFields: savedFields, fails: fails, tag: tag)
            }
        }
    }
    
    func savingCompletionBlock(savedFields: [String: Bool], fails: [String], tag: Int) {
        self.activityIndicator.stopAnimating()
        
        if savedFields["name"]! {
            self.user.name = backgroundView.nameTextField.text
        }
        if savedFields["description"]! {
            self.user.description = backgroundView.descriptionTextView.text
        }
        if savedFields["photo"]! {
            self.user.photo = backgroundView.avatarView.imageView.image
            photoIsSame = true
        }
        
        if fails.isEmpty {
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            self.showAlert(title: "Data saved", message: nil, preferredStyle: .alert, actions: [okAction], completion: nil)
        } else {
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.backgroundView.saveWithGCDButton.setTitleColor(.systemBlue, for: .normal)
                self.backgroundView.saveWithGCDButton.isEnabled = true
                self.backgroundView.saveWithOperationButton.setTitleColor(.systemBlue, for: .normal)
                self.backgroundView.saveWithOperationButton.isEnabled = true
            }
            let repeatAction = UIAlertAction(title: "Try again", style: .default) { _ in
                self.saveToFile(tag: tag)
            }
            
            let message = fails.joined(separator: ", ")
            self.showAlert(title: "Error", message: "Failed to save \(message)", preferredStyle: .alert, actions: [okAction, repeatAction], completion: nil)
        }
        self.backgroundView.isUserInteractionEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate.user = user
        delegate.configureNavigationElements()
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        var newPhoto = UIImage()
        
        if let photo = info[.editedImage] as? UIImage {
            newPhoto = photo
        } else if let photo = info[.originalImage] as? UIImage {
            newPhoto = photo
        } else {
            return
        }
        
        dismiss(animated: true, completion: nil)
        backgroundView.configureAvatarView(with: newPhoto)
        
        let queue = DispatchQueue.global()
        queue.async {
            if newPhoto.pngData() == self.user.photo?.pngData() {
                self.photoIsSame = true
            } else {
                self.photoIsSame = false
            }
            
            DispatchQueue.main.async {
                self.compareFields()
            }
        }
    }
}
