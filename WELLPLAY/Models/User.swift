//
//  User.swift
//  WellPlay
//
//  Created by Nataliya Durdyeva on 8/14/22.
//

import Foundation
import SwiftUI
import Foundation
import FirebaseFirestoreSwift
import Firebase

struct User: Identifiable, Hashable, Decodable {
    
    
    @DocumentID var id: String?
    
    let userName: String
    var age: String
    var location: String
    var sports: String
    var bio: String
    var profilePictureUrl: String

    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == id }
    
    
}
