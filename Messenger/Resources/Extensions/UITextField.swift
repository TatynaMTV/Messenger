//
//  UITextField.swift
//  Messenger
//
//  Created by Татьяна Мальчик on 31.03.2022.
//

import UIKit

extension UITextField {
  convenience init(placeholder: String?, isSecureTextEntry: Bool) {
    self.init()
    self.placeholder = placeholder
    self.isSecureTextEntry = isSecureTextEntry
    self.autocapitalizationType = .none
    self.autocapitalizationType = .none
    self.autocorrectionType = .no
    self.returnKeyType = .continue
    self.layer.cornerRadius = 12
    self.layer.borderWidth = 1
    self.layer.borderColor = UIColor.lightGray.cgColor
    self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
    self.leftViewMode = .always
    self.backgroundColor = .secondarySystemBackground
  }
}
