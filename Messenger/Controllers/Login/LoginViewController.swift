//
//  LoginViewController.swift
//  Messenger
//
//  Created by Татьяна Мальчик on 30.03.2022.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class LoginViewController: UIViewController {
  
  private let spinner = JGProgressHUD(style: .dark)
  
  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.clipsToBounds = true
    
    return scrollView
  }()
  
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "logo")
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private let emailField = UITextField(placeholder: "Email Address...", isSecureTextEntry: false)
  private let passwordField = UITextField(placeholder: "Password...", isSecureTextEntry: true)
  
  private let loginButton: UIButton = {
    let button = UIButton()
    button.setTitle("Log In", for: .normal)
    button.backgroundColor = .link
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 12
    button.layer.masksToBounds = true
    button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Log In"
    view.backgroundColor = .white
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                        style: .done,
                                                        target: self,
                                                        action: #selector(didTapRegister))
    loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    
    emailField.delegate = self
    passwordField.delegate = self
    
    // Add subviews
    view.addSubview(scrollView)
    scrollView.addSubview(imageView)
    scrollView.addSubview(emailField)
    scrollView.addSubview(passwordField)
    scrollView.addSubview(loginButton)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    scrollView.frame = view.bounds
    
    let size = scrollView.width / 3
    imageView.frame = CGRect(x: (view.width - size) / 2,
                             y: 20,
                             width: size,
                             height: size)
    emailField.frame = CGRect(x: 30,
                              y: imageView.bottom + 10,
                              width: scrollView.width - 60,
                              height: 52)
    
    passwordField.frame = CGRect(x: 30,
                                 y: emailField.bottom + 10,
                                 width: scrollView.width - 60,
                                 height: 52)
    
    loginButton.frame = CGRect(x: 30,
                               y: passwordField.bottom + 10,
                               width: scrollView.width - 60,
                               height: 52)
  }
  
  @objc private func loginButtonTapped() {
    emailField.resignFirstResponder()
    passwordField.resignFirstResponder()
    
    guard let email = emailField.text,
          let password = passwordField.text,
          !email.isEmpty,
          !password.isEmpty,
          password.count >= 6 else {
      alertUserLoginError()
      return
    }
    
    spinner.show(in: view)
    
    // Firebase Log In
    Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
      guard let strongSelf = self else { return }

      DispatchQueue.main.async {
        strongSelf.spinner.dismiss()
      }
      
      guard let result = authResult, error == nil else {
        print("Faild to log in user with email: \(email)")
        return
      }
      
      let user = result.user
      print("Logged in User: \(user)")
      strongSelf.navigationController?.dismiss(animated: true)
    }
  }
  
  func alertUserLoginError() {
    let alert = UIAlertController(title: "Woops",
                                  message: "Please enter all information to log in.",
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

extension LoginViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == emailField {
      passwordField.becomeFirstResponder()
    } else if textField == passwordField {
      loginButtonTapped()
    }
    return true
  }
}
