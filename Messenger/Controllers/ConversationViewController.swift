//
//  ConversationViewController.swift
//  Messenger
//
//  Created by Татьяна Мальчик on 30.03.2022.
//

import UIKit

class ConversationViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    let isLoggedIn = UserDefaults.standard.value(forKey: "logged_in")
    if isLoggedIn == nil {
      let vc = LoginViewController()
      let nav = UINavigationController(rootViewController: vc)
      nav.modalPresentationStyle = .fullScreen
      setNavController()
      present(nav, animated: false)
      
      //      let appearance = UITabBarAppearance()
      //      appearance.configureWithOpaqueBackground()
      //      tabBar.standardAppearance = appearance
      //      tabBar.scrollEdgeAppearance = tabBar.standardAppearance
      //      tabBar.tintColor = .systemGray6
    }
  }
  func setNavController() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .systemGray6
    UIWindow.appearance().overrideUserInterfaceStyle = .light
    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
  }
}
