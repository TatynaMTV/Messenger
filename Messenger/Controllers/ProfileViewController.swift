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
    tableView.tableHeaderView = createTableHeader()
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
    
    StorageManager.shared.downloadURL(for: path) { [weak self] result in
      switch result {
      case .success(let url):
        self?.downloadImage(imageView: imageView, url: url)
      case .failure(let error):
        print("Failed to get download url: \(error)")
      }
    }
    return header
  }
  
  func downloadImage(imageView: UIImageView, url: URL) {
    URLSession.shared.dataTask(with: url) { data, _, error in
      guard let data = data, error == nil else { return }
      
      DispatchQueue.main.async {
        let image = UIImage(data: data)
        imageView.image = image
      }
    }.resume()
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
