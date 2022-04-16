//
//  ProfileTableViewCell.swift
//  Messenger
//
//  Created by Татьяна Мальчик on 16.04.2022.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    static let identifire = "ProfileTableViewCell"
    
    public func setUp(with viewModel: ProfileViewModel) {
        self.textLabel?.text = viewModel.title
        switch viewModel.viewModelType {
        case .info:
            self.textLabel?.textAlignment = .left
            self.selectionStyle = .none
        case .logout:
            self.textLabel?.textColor = .red
            self.textLabel?.textAlignment = .center
        }
    }
}
