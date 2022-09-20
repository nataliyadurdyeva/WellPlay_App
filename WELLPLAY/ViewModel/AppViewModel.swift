//
//  AppViewModel.swift
//  WellPlay
//
//  Created by Nataliya Durdyeva on 8/14/22.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import Firebase
import FirebaseFirestoreSwift
import CoreMedia

class AppViewModel: NSObject, ObservableObject {
    
    static let shared = AppViewModel()
    
    @Published var errorMessage = ""
    @Published var messageToSetVisible: String?
    @Published var count = 0
    @Published var userSession: FirebaseAuth.User?
    @Published var didAuthenticateUser = false
    @Published var currentUser: User?
    @Published var didRegister = false
    @Published var users = [User]()
    @Published var reciever: User?
    @Published var message: Message?
    @State private var fromId = ""
    
    @Published var messages = [Message]()
    
    @State var isShowingNewMessageView = false
    @State var showChatView = false
    @State var text = ""
    private var tempCurrentUser: FirebaseAuth.User?
    
    override init() {
        super.init()
        tempCurrentUser = nil
        userSession = Auth.auth().currentUser
        fetchUser()
        //        fetchMessages(message: message, reciever: reciever)
        //     fetchRecentMessage()
    }
    
    func sendMessage(text: String, reciever: User?) {
        
        
        guard let fromID = self.currentUser?.id else { return }
        guard let toID = reciever?.id else { return }
        
        let currentUserRef = Firestore.firestore()
            .collection("messages")
            .document(fromID)
            .collection(toID)
            .document()
        
        let receivingUserRef = Firestore.firestore()
            .collection("messages")
            .document(toID)
            .collection(fromID)
        
        let recentUserRef =
        Firestore.firestore()
            .collection("messages")
            .document(fromID)
            .collection("recent-messages")
            .document(toID)
        
        let recentRecievingRef =
        Firestore.firestore()
            .collection("messages")
            .document(toID)
            .collection("recent-messages")
            .document(fromID)
        
        let messageID = currentUserRef.documentID
        
        let data: [String: Any] = ["text": text,
                                   "uid": messageID,
                                   "fromId": fromID,
                                   "toId": toID,
                                   "timestamp": Timestamp(date: Date()),
                                   "recieverProfilePictureUrl": reciever?.profilePictureUrl ?? "",
                                   "senderProfilePictureUrl": currentUser?.profilePictureUrl ?? "",
                                   "recieverUserName": reciever?.userName ?? "",
                                   "senderUserName": currentUser?.userName ?? ""
        ]
        
        currentUserRef.setData(data)
        self.text = ""
        self.count += 1
        
        receivingUserRef.document(messageID).setData(data)
        
        recentUserRef.setData(data)
        recentRecievingRef.setData(data)
        
    }
    
    func fetchMessages(message: Message?, reciever: User?)  {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let uid = reciever?.id else { return }
        
        let query = Firestore.firestore().collection("messages")
            .document(currentUid)
            .collection(uid)
        
            .order(by: "timestamp", descending: false)
        
        query.addSnapshotListener { querySnapshot, error in
            guard let changes = querySnapshot?.documents else { return }
            
            
            self.messages = changes.map { (QueryDocumentSnapshot) -> Message in
                
                let data = QueryDocumentSnapshot.data()
                return Message(data: data)
                
            }
            DispatchQueue.main.async {
                self.count += 1
            }
        }
        
    }
    
    func fetchRecentMessage() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        
        let query = Firestore.firestore().collection("messages")
            .document(currentUid)
            .collection("recent-messages")
        
            .order(by: "timestamp", descending: true)
        
        query.addSnapshotListener { querySnapshot, error in
            guard let changes = querySnapshot?.documents else { return }
            
            self.messages = changes.map { (QueryDocumentSnapshot) -> Message in
                
                let data = QueryDocumentSnapshot.data()
                return Message(data: data)
                
            }
        }
        
        
    }
    
    
    func signIn(email: String, password: String) {
        
        let auth = Auth.auth()
        
        auth.signIn(withEmail: email, password: password) {[weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            guard let user = result?.user else { return }
            self?.userSession = user
            self?.fetchUser()
        }
    }
    
    func signUp(email: String, password: String, userName: String, age: String, location: String, sports: String, bio: String) {
        
        let auth = Auth.auth()
        
        auth.createUser(withEmail: email, password: password) {
            result, error in
            if let error = error {
                print("Failed to create user:", error)
                return
            }
            
            guard let user = result?.user else {return}
            self.tempCurrentUser = user
            
            
            let data: [String: Any] = ["email": email,
                                       "userName": userName.lowercased(),
                                       "age":age,
                                       "location": location,
                                       "sports":sports,
                                       "bio": bio,
                                       "uid": user.uid]
            
            Firestore.firestore().collection("users").document(user.uid)
                .setData(data) { _ in
                    
                    self.didAuthenticateUser = true
                    self.didRegister = true
                }
        }
        
    }
    
    
    func signout() {
        self.userSession = nil
        try? Auth.auth().signOut()
    }
    
    
    func fetchUsers() {
        let db = Firestore.firestore()
        db.collection("users").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.users = documents.map { (queryDocumentSnapshot) -> User in
                
                let data = queryDocumentSnapshot.data()
                let id = data["uid"] as? String ?? ""
                let userName = data["userName"] as? String ?? ""
                let age = data["age"] as? String ?? ""
                let location = data["location"] as? String ?? ""
                let sports = data["sports"] as? String ?? ""
                let profilePictureUrl = data["profilePictureUrl"] as? String ?? ""
                let bio = data["bio"] as? String ?? ""
                return User(id: id, userName: userName, age: age, location: location, sports: sports, bio: bio, profilePictureUrl: profilePictureUrl)
            }
        }
    }
    
    
    func uploadProfilePhoto(_ profilePicture: UIImage) {
        
        
        guard let uid = tempCurrentUser?.uid else {return}
        
        PhotoUploader.uploadPhoto(image: profilePicture) { profilePictureUrl in
            Firestore.firestore().collection("users")
                .document(uid)
                .updateData(["profilePictureUrl": profilePictureUrl]) { _ in
                    self.userSession = self.tempCurrentUser
                    self.fetchUser()
                }
        }
    }
    
    func fetchUser() {
        guard let uid = self.userSession?.uid else {return}
        
        UserService.fetchUser(withUid: uid) {user in
            
            self.currentUser = user
        }
    }
    
    func fetchRecentUser() {
        guard let uid = message?.fromId else {return}
        
        UserService.fetchUser(withUid: uid) {user in
            
            self.reciever = user
        }
    }
    
    struct UserService {
        
        static func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
            Firestore.firestore().collection("users")
                .document(uid)
                .getDocument { snapshot, _ in
                    guard let user = try? snapshot?.data(as: User.self) else {
                        print("Failed to Fetch user....")
                        
                        return
                        
                    }
                    completion(user)
                }
        }
    }
    
    //    func fetchUserRecentMessage(reciever: User?) {
    //
    //        guard let fromID = self.currentUser?.id else { return }
    ////        guard let toID = reciever?.id else { return }
    //
    //        let query = Firestore.firestore().collection("messages")
    //            .document(fromID)
    //            .collection("recent-messages")
    //
    //            query.addSnapshotListener { querySnapshot, error in
    //            guard let documents = querySnapshot?.documents else {
    //            print("No documents")
    //            return
    //        }
    //
    //                self.users = documents.map { (QueryDocumentSnapshot) -> User in
    //
    //                    let data = QueryDocumentSnapshot.data()
    //                    let id = data["uid"] as? String ?? ""
    //                    let userName = data["userName"] as? String ?? ""
    //                    let age = data["age"] as? String ?? ""
    //                    let location = data["location"] as? String ?? ""
    //                    let sports = data["sports"] as? String ?? ""
    //                    let profilePictureUrl = data["profilePictureUrl"] as? String ?? ""
    //                    let bio = data["bio"] as? String ?? ""
    //
    //
    //                    return User(id: id, userName: userName, age: age, location: location, sports: sports, bio: bio, profilePictureUrl: profilePictureUrl)
    //
    //        }
    //    }
    //    }
    
    func fetchUserRecentMessage(receiver: User) {
        
        
        guard let uid = message?.fromId else { return }
        let query = Firestore.firestore().collection("users")
            .document(uid)
        query.getDocument { snapshot, _ in
            self.message?.user = try? snapshot?.data(as: User.self)
        }
    }
}
