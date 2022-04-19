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
            textLabel?.textAlignment = .left
            selectionStyle = .none
        case .logout:
            textLabel?.textColor = .red
            textLabel?.textAlignment = .center
        }
    }
}
