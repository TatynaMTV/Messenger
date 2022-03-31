//
//  RegisterViewController.swift
//  Messenger
//
//  Created by Татьяна Мальчик on 30.03.2022.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
  
  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.clipsToBounds = true
    
    return scrollView
  }()
  
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(systemName: "person.crop.circle")
    imageView.tintColor = .systemGreen
    imageView.contentMode = .scaleAspectFit
    imageView.layer.masksToBounds = true
    imageView.layer.borderWidth = 2
    imageView.layer.borderColor = UIColor.lightGray.cgColor
    return imageView
  }()
  
  private let firstNameField = UITextField(placeholder: "First Name...", isSecureTextEntry: false)
  private let lastNameField = UITextField(placeholder: "Last Name...", isSecureTextEntry: false)
  private let emailField = UITextField(placeholder: "Email Address...", isSecureTextEntry: false)
  private let passwordField = UITextField(placeholder: "Password...", isSecureTextEntry: true)
  
  private let registerButton: UIButton = {
    let button = UIButton()
    button.setTitle("Register", for: .normal)
    button.backgroundColor = .systemGreen
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 12
    button.layer.masksToBounds = true
    button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Register"
    view.backgroundColor = .white
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                        style: .done,
                                                        target: self,
                                                        action: #selector(didTapRegister))
    registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    
    emailField.delegate = self
    passwordField.delegate = self
    
    // Add subviews
    view.addSubview(scrollView)
    scrollView.addSubview(imageView)
    scrollView.addSubview(firstNameField)
    scrollView.addSubview(lastNameField)
    scrollView.addSubview(emailField)
    scrollView.addSubview(passwordField)
    scrollView.addSubview(registerButton)
    
    imageView.isUserInteractionEnabled = true
    scrollView.isUserInteractionEnabled = true
    
    let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
    gesture.numberOfTapsRequired = 1
    gesture.numberOfTouchesRequired = 1
    imageView.addGestureRecognizer(gesture)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    scrollView.frame = view.bounds
    
    let size = scrollView.width / 3
    imageView.frame = CGRect(x: (view.width - size) / 2,
                             y: 20,
                             width: size,
                             height: size)
    imageView.layer.cornerRadius = imageView.width / 2.0
    
    firstNameField.frame = CGRect(x: 30,
                                  y: imageView.bottom + 10,
                                  width: scrollView.width - 60,
                                  height: 52)
    
    lastNameField.frame = CGRect(x: 30,
                                 y: firstNameField.bottom + 10,
                                 width: scrollView.width - 60,
                                 height: 52)
    emailField.frame = CGRect(x: 30,
                              y: lastNameField.bottom + 10,
                              width: scrollView.width - 60,
                              height: 52)
    
    passwordField.frame = CGRect(x: 30,
                                 y: emailField.bottom + 10,
                                 width: scrollView.width - 60,
                                 height: 52)
    
    registerButton.frame = CGRect(x: 30,
                               y: passwordField.bottom + 10,
                               width: scrollView.width - 60,
                               height: 52)
  }
  
  @objc private func didTapChangeProfilePic() {
    
  }
  
  @objc private func registerButtonTapped() {
    firstNameField.resignFirstResponder()
    lastNameField.resignFirstResponder()
    emailField.resignFirstResponder()
    passwordField.resignFirstResponder()
    
    guard let firstName = firstNameField.text,
          let lastName = lastNameField.text,
          let email = emailField.text,
          let password = passwordField.text,
          !firstName.isEmpty,
          !lastName.isEmpty,
          !email.isEmpty,
          !password.isEmpty,
          password.count >= 6 else {
            alertUserLoginError()
            return
    }
    
    // Firebase Log In
    
    DatabaseManager.shared.userExists(with: email) { [weak self] exists in
      guard let strongSelf = self else { return }
      guard !exists else {
        // users already exists
        strongSelf.alertUserLoginError(message: "Looks like a user account for that email address already exixsts")
        return
      }
      
      Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
        guard let strongSelf = self else { return }
        guard authResult != nil, error == nil else {
          print("Error creating user")
          return
        }
        
        DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstName, lastName: lastName, emailAddress: email))
        strongSelf.navigationController?.dismiss(animated: true)
      }
    }
  }
  
  func alertUserLoginError(message: String = "Please enter all information to create a new account.") {
    let alert = UIAlertController(title: "Woops",
                                  message: message,
                                  preferredStyle: .alert)
    let cancel = UIAlertAction(title: "Dismiss", style: .cancel)
    alert.addAction(cancel)
    present(alert, animated: true)
  }
  
  @objc private func didTapRegister() {
    let vc = RegisterViewController()
    vc.title = "Create Account"
    navigationController?.pushViewController(vc, animated: true)
  }
}

// MARK: - TextFiewldDelegate

extension RegisterViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == emailField {
      passwordField.becomeFirstResponder()
    } else if textField == passwordField {
      registerButtonTapped()
    }
    return true
  }
}

// MARK: - ImagePickerControllerDelegate

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func presentPhotoActionSheet() {
    let actionSheet = UIAlertController(title: "Profile Picture",
                                        message: "How would you like to select a picture?",
                                        preferredStyle: .actionSheet)
    actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
      self?.presentCamera()
    }))
    actionSheet.addAction(UIAlertAction(title: "Chose Photo", style: .default, handler: { [weak self] _ in
      self?.presentPhotoPicer()
    }))
    present(actionSheet, animated: true)
  }
  
  func presentCamera() {
    let vc = UIImagePickerController()
    vc.sourceType = .camera
    vc.delegate = self
    vc.allowsEditing = true
    present(vc, animated: true)
  }
  
  func presentPhotoPicer() {
    let vc = UIImagePickerController()
    vc.sourceType = .photoLibrary
    vc.delegate = self
    vc.allowsEditing = true
    present(vc, animated: true)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    picker.dismiss(animated: true)
    guard let selectedImage = info[.editedImage] as? UIImage else { return }
    self.imageView.image = selectedImage
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true)
  }
}
