//
//  ProfileViewModel.swift
//  Messenger
//
//  Created by Татьяна Мальчик on 19.04.2022.
//

import Foundation

enum ProfileViewModelType {
    case info, logout
}
struct ProfileViewModel {
    let viewModelType: ProfileViewModelType
    let title: String
    let handler: (() -> Void)?
}
