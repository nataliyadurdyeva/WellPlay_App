//
//  Message.swift
//  WellPlay
//
//  Created by Nataliya Durdyeva on 8/14/22.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

struct Message: Identifiable, Hashable, Decodable {
  
    @DocumentID var id: String?

//    var documentID: String
    var fromId: String
    var toId: String
    var timestamp = Date()
    var text: String
    var user: User?
    var senderUserName: String
    var recieverUserName: String
    var profilePictureUrl: String
    var senderProfilePictureUrl: String
    var recieverProfilePictureUrl: String
  

    init(data: [String: Any]) {
//        self.documentID = documentID
        self.user = data[FirebaseConstants.user] as? User
        self.fromId = data[FirebaseConstants.fromId] as? String ?? ""
        self.toId = data[FirebaseConstants.toId] as? String ?? ""
        self.text = data[FirebaseConstants.text] as? String ?? ""
        self.senderUserName = data[FirebaseConstants.senderUserName] as? String ?? ""
        self.recieverUserName = data[FirebaseConstants.recieverUserName] as? String ?? ""
        self.timestamp = data[FirebaseConstants.timestamp] as? Date ?? Date()
        self.profilePictureUrl = data[FirebaseConstants.profilePictureUrl] as? String ?? ""
        self.senderProfilePictureUrl = data[FirebaseConstants.senderProfilePictureUrl] as? String ?? ""
        self.recieverProfilePictureUrl = data[FirebaseConstants.recieverProfilePictureUrl] as? String ?? ""
    }

    struct FirebaseConstants {
        static let user = "user"
        static let fromId = "fromId"
        static let toId = "toId"
        static let timestamp = "timestamp"
        static let text = "text"
        static let senderUserName = "senderUserName"
        static let recieverUserName = "recieverUserName"
        static let profilePictureUrl = "profilePictureUrl"
        static let senderProfilePictureUrl = "senderProfilePictureUrl"
        static let recieverProfilePictureUrl = "recieverProfilePictureUrl"
    }
}
