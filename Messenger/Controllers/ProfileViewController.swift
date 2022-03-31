//
//  ProfileViewController.swift
//  Messenger
//
//  Created by Татьяна Мальчик on 30.03.2022.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
  
  @IBOutlet var tableView: UITableView!
  
  let data = ["Log Out"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.delegate = self
    tableView.dataSource = self
    
  }
}

// MARK: - TableView Delegate & DataSource

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = data[indexPath.row]
    cell.textLabel?.textAlignment = .center
    cell.textLabel?.textColor = .red
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
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
    
    present(actionSheet, animated: true)
  }
}
