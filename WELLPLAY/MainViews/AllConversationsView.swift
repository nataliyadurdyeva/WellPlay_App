import Foundation
import UIKit
import SwiftUI
import Kingfisher
import FirebaseAuth
import UIKit
import Kingfisher

struct AllConversationsView: View {
    
    @EnvironmentObject private var viewModel: AppViewModel
    
    @State var ChatViewIsActive: Bool = false
    @State var messages: Message?
    @State private var senderProfilePictureUrl = ""
    @State private var profilePictureUrl = ""
    @State private var userName = ""
    @State private var recieverUserName = ""
    @State private var senderUserName = ""
    @State var shouldShowLogOutOptions = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("DarkBlue")

                    .edgesIgnoringSafeArea(.all)
                
                VStack (alignment: .leading) {
//                    ZStack {
//                        Color("search_bg_greenesh_teal_gray")

                    customNavBar
   
//                    }
                    messagesView
                    
                  Spacer()
                    Spacer()
                    Spacer()
                }.navigationBarTitleDisplayMode(.inline)
               
                
            }
        }
//        .offset(y: -200)
    }
    private var messagesView: some View {
        
        VStack (alignment: .leading) {
            
           
            HStack {
                
            Text("Recent Chats")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(.lightGray))
                
            } .offset(x: 10)
            
            ForEach(viewModel.messages, id: \.self)
            { message in
                let selectedUser: User? = {
                    return viewModel.users.first(where: {
                        $0.id == message.toId
                    })
                }()
                Divider()
                    .padding(.vertical, 8)

                
                HStack(alignment: .top, spacing: 10) {
                    
                    
                    if viewModel.currentUser?.id == message.fromId {
                        KFImage(URL(string: message.recieverProfilePictureUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 35, height: 35)
                            .clipShape(Circle())
                            .cornerRadius(20)
                    
                    } else {
                        KFImage(URL(string: message.senderProfilePictureUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 35, height: 35)
                            .clipShape(Circle())
                            .cornerRadius(20)
                    }
                    VStack(alignment: .leading, spacing: 4)  {
                        if viewModel.currentUser?.id == message.fromId {
                            Text(message.recieverUserName.capitalizingFirstLetter())
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color(.lightGray))
                        } else {
                            Text(message.senderUserName.capitalizingFirstLetter())
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color(.lightGray))
                        }
                        
                        NavigationLink(destination: ChatLogView(reciever: selectedUser)){
                            Text(message.text)
                         
                                .font(.system(size: 16))
                                .foregroundColor(Color(.lightGray))
                        }
                    }
                } .offset(x: 30)
          
            }
            
            
            
        }.onAppear() {
            self.viewModel.fetchRecentMessage(message: messages)
         
        }
//        .navigationBarTitleDisplayMode(.inline)
//        .background(Color("DarkBlue"))
        
    }
    
    
    private var customNavBar: some View {

            
        VStack (alignment: .leading) {

          
            HStack  (alignment: .top, spacing: 10){
                
                KFImage(URL(string: viewModel.currentUser?.profilePictureUrl ?? self.profilePictureUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .cornerRadius(20)
                    .font(.system(size: 34, weight: .heavy))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(viewModel.currentUser?.userName.capitalizingFirstLetter() ?? self.userName)")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(.lightGray))
                    
                    HStack {
                        Circle()
                            .foregroundColor(.green)
                            .frame(width: 14, height: 14)
                        Text("online")
                            .font(.system(size: 12))
                            .foregroundColor(Color(.lightGray))
                    }
                    
                }
                
                Spacer(minLength: 20)
                
                Button {
                    shouldShowLogOutOptions.toggle()
                } label: {
                    Image(systemName: "gear")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(.white))
                }
            }
            .padding()
            .actionSheet(isPresented: $shouldShowLogOutOptions)
            {
                .init(title: Text("Settings"), message: Text("Do you want to sign out?"), buttons: [
                    .destructive(Text("Sign Out"), action: {
                        viewModel.signout()
                    }),
                    .cancel()
                ])
            }
        
        }
    
    }
}
