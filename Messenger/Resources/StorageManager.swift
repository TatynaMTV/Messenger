//
//  StorageManager.swift
//  Messenger
//
//  Created by Татьяна Мальчик on 31.03.2022.
//

import Foundation
import FirebaseStorage

final class StorageManager {
  
  static let shared = StorageManager()
  private let storage = Storage.storage().reference()
  
  public typealias UploadPictureComletion = (Result<String, Error>) -> Void
  /// Upload picture to Firebase storage and return complition with url string to download
  public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping UploadPictureComletion) {
    storage.child("images/\(fileName)").putData(data, metadata: nil) { metadate, error in
      guard error == nil else {
        // failed
        print("Faild to upload data to firebase for picture")
        completion(.failure(StorageErrors.failedToUpload))
        return
      }
      
      self.storage.child("images/\(fileName)").downloadURL { url, error in
        guard let url = url else {
          print("Faild to get download url")
          completion(.failure(StorageErrors.faildToDownloadURL))
          return
        }
        
        let urlString = url.absoluteString
        print("download url returned: \(urlString)")
        completion(.success(urlString))
      }
    }
  }
  
  public enum StorageErrors: Error {
    case failedToUpload
    case faildToDownloadURL
  }
}
