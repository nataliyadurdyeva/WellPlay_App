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
    
    //MARK: Error messages:
    
    @Published var errorMessage: String? = ""
    @Published var signInErrorMessage: String? = ""
    
    //MARK: User variables
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var users = [User]()
    
    //MARK: Message variables
    
    @Published var messages = [Message]()
    @Published var reciever: User?
    @Published var message: Message?
    @State private var fromId = ""
    @Published var count = 0
    @State var isShowingNewMessageView = false
    @State var showChatView = false
    @State var text = ""
    
    //MARK: Authentication variables
    
    @Published var didRegister = false
    @Published var didAuthenticateUser = false
    @State var email = ""
    @State private var password = ""
    private var tempCurrentUser: FirebaseAuth.User?
    let db = Firestore.firestore()
    
    //MARK: Initializers
    
    override init() {
    
        super.init()
        tempCurrentUser = nil
        userSession = Auth.auth().currentUser
        fetchUser()
    }
    
    //MARK: *************************************************************************************************//
    
    //MARK: Message functions
    
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
    
    //MARK: Authorization functions
    
    func signIn(email: String, password: String) {
        
        
        let auth = Auth.auth()
        
        if email != "" && password != ""{
            
            auth.signIn(withEmail: email, password: password) {result, error in
                if let error = error {
                    self.signInErrorMessage = "\(error.localizedDescription)"
                    print(error)
                    return
                }
                guard let user = result?.user else { return }
                self.userSession = user
                self.fetchUser()
            }
        } else {
            print ("Sign in is possible only when email and password are entered correctly")
            return
        }
    }
    
    func resetPassword(email: String, resetCompletion: @escaping (Result<Bool, Error>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
            if let error = error {
                resetCompletion(.failure(error))
            } else {
                resetCompletion(.success(true))
            }
        })
    }
    
    func signUp(email: String, password: String, userName: String, age: String, location: String, sports: String, bio: String) {
        
        let auth = Auth.auth()
        
        auth.createUser(withEmail: email, password: password) {
            result, error in
            if let error = error {
                self.errorMessage = "\(error.localizedDescription)"
                print(error)
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
    
    //MARK: User functions
    
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
    
    func updateUser(userName: String, age: String){
        
        guard let userId = Auth.auth().currentUser?.uid else {return}
        
        let docUpdate = Firestore.firestore().collection("users").document(userId)
        let data: [String: Any] = [
            "userName": userName,
            "age": age
        ]
        
        docUpdate.updateData(data)
        
    }
    func updateName(userName: String){
        
        guard let userId = Auth.auth().currentUser?.uid else {return}
        
        let docUpdate = db.collection("users").document(userId)
        
        
        let data: [String: Any] = [
            "userName": userName
        ]
        
        docUpdate.updateData(data)
        
    }
    
    func updateAge(age:String){
        
        guard let userId = Auth.auth().currentUser?.uid else {return}
        
        let docUpdate = db.collection("users").document(userId)
        
        
        let data: [String: Any] = [
            "age": age
        ]
        
        docUpdate.updateData(data)
        
    }
    
    func updateLocation(location: String){
        
        guard let userId = Auth.auth().currentUser?.uid else {return}
        
        let docUpdate = db.collection("users").document(userId)
        
        
        let data: [String: Any] = [
            "location": location
        ]
        
        docUpdate.updateData(data)
        
    }
    
    func updateSports(sports: String){
        
        guard let userId = Auth.auth().currentUser?.uid else {return}
        
        let docUpdate = db.collection("users").document(userId)
        
        
        let data: [String: Any] = [
            "sports": sports
        ]
        
        docUpdate.updateData(data)
        
    }
    
    func updateBio(bio: String){
        
        guard let userId = Auth.auth().currentUser?.uid else {return}
        
        let docUpdate = db.collection("users").document(userId)
        
        
        let data: [String: Any] = [
            "bio": bio
        ]
        
        docUpdate.updateData(data)
        
    }
    
    func deleteUser() {
        let userId = Auth.auth().currentUser!.uid
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(userId)
            .delete() { error in
                if let error = error {
                    print("Error deleting user: \(error)")
                } else {
                    print("User deleted")
                }
            }
        let user = Auth.auth().currentUser
        user?.delete()
        self.signout()
        
        
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
}
