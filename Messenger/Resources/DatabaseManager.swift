//
//  DatabaseManager.swift
//  Messenger
//
//  Created by Татьяна Мальчик on 31.03.2022.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
  
  static let shared = DatabaseManager()
  private let database = Database.database().reference()
}

// MARK: - Account Management

extension DatabaseManager {
  
  public func userExists(with email: String, completion: @escaping ((Bool) -> Void)) {
    var safeEmail = email.replacingOccurrences(of: ".", with: "-")
    safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
    
    database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
      guard snapshot.value as? String != nil else {
        completion(false)
        return
      }
      completion(true)
    }
  }
  
  /// Inserts new user to database
  public func insertUser(with user: ChatAppUser, completion: @escaping (Bool) -> Void) {
    database.child(user.safeEmail).setValue(["first_name": user.firstName, "last_name": user.lastName]) { error, _ in
      guard error == nil else {
        print("faild to wright to database")
        completion(false)
        return
      }
      
      self.database.child("users").observeSingleEvent(of: .value) { snapshot in
        if var usersCollection = snapshot.value as? [[String: String]] {
          // append to user dictionary
          let newEelement = [
            "name": user.firstName + " " + user.lastName,
            "email": user.safeEmail
          ]
          usersCollection.append(newEelement)
          self.database.child("users").setValue(usersCollection) { error, _ in
            guard error == nil else {
              completion(false)
              return
            }
          }
          completion(true)
        } else {
          // create that array
          let newCollection: [[String: String]] = [
            [
              "name": user.firstName + " " + user.lastName,
              "email": user.safeEmail
            ]
          ]
          self.database.child("users").setValue(newCollection) { error, _ in
            guard error == nil else {
              completion(false)
              return
            }
            completion(true)
          }
        }
      }
    }
  }
}

struct ChatAppUser {
  let firstName: String
  let lastName: String
  let emailAddress: String
  var profilePictureFileName: String {
    return "\(safeEmail)_profile_picture.png"
  }
  
  var safeEmail: String {
    var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
    safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
    return safeEmail
  }
}
