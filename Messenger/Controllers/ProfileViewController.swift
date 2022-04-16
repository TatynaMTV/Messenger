//
//  ProfileViewController.swift
//  Messenger
//
//  Created by Татьяна Мальчик on 30.03.2022.
//

import UIKit
import FirebaseAuth
import SDWebImage

enum ProfileViewModelType {
    case info, logout
}
struct ProfileViewModel {
    let viewModelType: ProfileViewModelType
    let title: String
    let handler: (() -> Void)?
}

class ProfileViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var data = [ProfileViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data.append(ProfileViewModel(viewModelType: .info,
                                     title: "Name: \(UserDefaults.standard.value(forKey: "name") as? String ?? "No Name")",
                                     handler: nil))
        data.append(ProfileViewModel(viewModelType: .info,
                                     title: "Email: \(UserDefaults.standard.value(forKey: "email") as? String ?? "No Email")",
                                     handler: nil))
        data.append(ProfileViewModel(viewModelType: .logout, title: "Log Out", handler: { [weak self] in
            guard let strongSelf = self else { return }
            let actionSheet = UIAlertController(title: "One question:",
                                                message: "Do you really whant to Log Out?",
                                                preferredStyle: .alert)
            actionSheet.addAction(UIAlertAction(title: "YES", style: .destructive, handler: { [weak self] _ in
                guard let strongSelf = self else { return }
                do {
                    try Auth.auth().signOut()
                    
                    let vc = LoginViewController()
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    strongSelf.present(nav, animated: true)
                }
                catch {
                    print("Faild to Log Out")
                }
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            strongSelf.present(actionSheet, animated: true)
        }))
        
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifire)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = createTableHeader()
        tableView.separatorStyle = .none
    }
    
    func createTableHeader() -> UIView? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else { return nil }
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        let fileName = safeEmail + "_profile_picture.png"
        let path = "images/" + fileName
        
        let header = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 300))
        header.backgroundColor = .link
        let imageView = UIImageView(frame: CGRect(x: (header.width - 150) / 2, y: header.height / 4, width: 150, height: 150))
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemBackground
        imageView.layer.cornerRadius = imageView.width / 2
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.masksToBounds = true
        header.addSubview(imageView)
        
        StorageManager.shared.downloadURL(for: path) { result in
            switch result {
            case .success(let url):
                imageView.sd_setImage(with: url)
            case .failure(let error):
                print("Failed to get download url: \(error)")
            }
        }
        return header
    }
}

// MARK: - TableView Delegate & DataSource

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifire, for: indexPath) as! ProfileTableViewCell
        cell.setUp(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        data[indexPath.row].handler?()
    }
}
