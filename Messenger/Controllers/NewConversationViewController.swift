//
//  NewConversationViewController.swift
//  Messenger
//
//  Created by Татьяна Мальчик on 31.03.2022.
//

import UIKit
import JGProgressHUD

class NewConversationViewController: UIViewController {
  
  private let spinner = JGProgressHUD(style: .dark)
  
  private let searchBar: UISearchBar = {
    let search = UISearchBar()
    search.placeholder = "Search for Users..."
    return search
  }()
  
  private let tableView: UITableView = {
    let table = UITableView()
    table.isHidden = true
    table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    return table
  }()
  
  private let noResultsLabel: UILabel = {
    let label = UILabel()
    label.isHidden = true
    label.text = "No Results"
    label.textAlignment = .center
    label.textColor = .green
    label.font = .systemFont(ofSize: 21, weight: .medium)
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    searchBar.delegate = self
    navigationController?.navigationBar.topItem?.titleView = searchBar
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                        style: .done, target: self,
                                                        action: #selector(dismissSelf))
    
    searchBar.becomeFirstResponder()
    
    tableView.delegate = self
    tableView.dataSource = self

    view.addSubview(tableView)
    view.addSubview(noResultsLabel)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    tableView.frame = view.bounds
    noResultsLabel.frame = CGRect(x: view.width / 4, y: (view.height - 200) / 2, width: view.width / 2, height: 200)
  }
  
  @objc private func dismissSelf() {
    dismiss(animated: true)
  }
}

// MARK: - SearchBar Delegate

extension NewConversationViewController: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

  }
}

// MARK: - TableView Delegate & DataSource

extension NewConversationViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = "\(indexPath.row)"
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
