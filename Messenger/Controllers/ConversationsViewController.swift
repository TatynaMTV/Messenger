//
//  ConversationViewController.swift
//  Messenger
//
//  Created by Татьяна Мальчик on 30.03.2022.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class ConversationsViewController: UIViewController {
  
  private let spinner = JGProgressHUD(style: .dark)
  
  private let tableView: UITableView = {
    let table = UITableView()
    table.isHidden = true
    table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    return table
  }()
  
  private let noConversationsLabel: UILabel = {
    let label = UILabel()
    label.text = "No Conversations!"
    label.textAlignment = .center
    label.textColor = .gray
    label.font = .systemFont(ofSize: 21, weight: .medium)
    label.isHidden = true
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                                        target: self,
                                                        action: #selector(didTapComposeButton))
    tableView.delegate = self
    tableView.dataSource  = self
    
    view.addSubview(tableView)
    view.addSubview(noConversationsLabel)
    fetchConversation()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    tableView.frame = view.bounds
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    validateAuth()
  }
  
  @objc private func didTapComposeButton() {
    let vc = NewConversationViewController()
    vc.completion = { [weak self] result in
      self?.createNewConversation(result: result)
    }
    let navVC = UINavigationController(rootViewController: vc)
    present(navVC, animated: true)
  }
  
  private func createNewConversation(result: [String: String]) {
    guard let name = result["name"], let email = result["email"] else { return }
    let vc = ChatViewController(with: email)
    vc.isNewConversation = true
    vc.title = name
    vc.navigationItem.largeTitleDisplayMode = .never
    navigationController?.pushViewController(vc, animated: true)
  }
  
  private func validateAuth() {
    if Auth.auth().currentUser == nil {
      let vc = LoginViewController()
      let nav = UINavigationController(rootViewController: vc)
      nav.modalPresentationStyle = .fullScreen
      setNavController()
      present(nav, animated: false)
    }
  }
  
  private func setNavController() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
//    appearance.backgroundColor = .systemGray6
    UIWindow.appearance().overrideUserInterfaceStyle = .light
    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
  }
  
  private func fetchConversation() {
    tableView.isHidden = false
  }
}

// MARK: - TableView Delegae & DataSource

extension ConversationsViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = "\(indexPath.row)"
    cell.accessoryType = .disclosureIndicator
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let vc = ChatViewController(with: "sasdada@gmail.com")
    vc.title = "Jeny Smith"
    vc.navigationItem.largeTitleDisplayMode = .never
    navigationController?.pushViewController(vc, animated: true)
  }
}
