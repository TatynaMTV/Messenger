//
//  ChatViewController.swift
//  Messenger
//
//  Created by Татьяна Мальчик on 30.03.2022.
//

import UIKit
import MessageKit

struct Message: MessageType {
  public var sender: SenderType
  public var messageId: String
  public var sentDate: Date
  public var kind: MessageKind
}

extension MessageKind {
  var messageKindString: String {
    switch self {
    case .text(_):
      return "text"
    case .attributedText(_):
      return "ttributed_text"
    case .photo(_):
      return "photo"
    case .video(_):
      return "video"
    case .location(_):
      return "location"
    case .emoji(_):
      return "emoji"
    case .audio(_):
      return "audio"
    case .contact(_):
      return "contact"
    case .linkPreview(_):
      return "linkPreview"
    case .custom(_):
      return "custom"
    }
  }
}

struct Sender: SenderType {
  public var photoURL: String
  public var senderId: String
  public var displayName: String
}

class ChatViewController: MessagesViewController {
  
  private var messages = [Message]()
  private var selfSender = Sender(photoURL: "", senderId: "1", displayName: "Joe Smith")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("Hello world message")))
    messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("Hello world messageHello world messageHello world messageHello world messageHello world messageHello world messageHello world message")))
    
    messagesCollectionView.messagesDataSource = self
    messagesCollectionView.messagesLayoutDelegate = self
    messagesCollectionView.messagesDisplayDelegate = self
  }
}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
  func currentSender() -> SenderType {
    return selfSender
//    fatalError("Self Sender is nil, email should be cached")
  }
  
  func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
    return messages[indexPath.section]
  }
  
  func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
    return messages.count
  }
}
