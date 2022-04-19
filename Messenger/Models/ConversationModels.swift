//
//  ConversationModels.swift
//  Messenger
//
//  Created by Татьяна Мальчик on 19.04.2022.
//

import Foundation

struct Conversation {
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date: String
    let text: String
    let isRead: Bool
}
