
//  SearchView.swift
//  WellPlay
//
//  Created by Nataliya Durdyeva on 8/14/22.

import Foundation
import SwiftUI
import Firebase
import Kingfisher

struct SearchView: View {
    @EnvironmentObject private var viewModel: AppViewModel
    
    init() {
        
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    @State private var userName = ""
    @State private var age = ""
    @State private var location = ""
    @State private var sports = ""
    @State var searchText = ""
    let searchRectangleColor = Color(red: 0.68, green: 0.81, blue: 0.92)
//    var user: User?
    
    var filteredUsers: [User] {
        if searchText.isEmpty {
            return viewModel.users
        } else {
            return viewModel.users.filter { $0.sports.localizedCaseInsensitiveContains(searchText)}
        }
    }
    
    var body: some View {
        
        NavigationView {
            
            //            if viewModel.currentUser?.location == user?.location ?? "" {
            
            VStack {
                
                Text("FIND SPORT BUDDIES NEAR YOU!")
                    .font(.headline)
                    .foregroundColor(.white)
                
                ZStack {
                    Rectangle()
                        .foregroundColor(searchRectangleColor)
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("Search by sport...", text: $searchText)
                            .autocapitalization(.none)
                    } .foregroundColor(.gray)
                        .padding(.leading, 13)
                    
                } .frame(height: 40)
                    .cornerRadius(13)
                    .padding()
                
                VStack {
                    
                    List {
                        
                        ForEach(filteredUsers, id: \.self)
                        { user in
                            
                            SearchCell(user: user)
                            
                        }
                        .listRowBackground(Color(.white).opacity(0.1))
                    }.listStyle(.plain)
                    
                    
                }
            }.onAppear() {
                self.viewModel.fetchUsers()
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .background(Color("DarkBlue"))
            
            
            //            } else {
            //
            //                NoFriendsFound()
            //            }
        }.navigationBarHidden(true)
        
    }
}

struct SearchCell: View {
    
    let user: User
    @EnvironmentObject private var viewModel: AppViewModel
    
    var body: some View {
        
        if user.id ?? "" !=  Auth.auth().currentUser?.uid  {
            HStack  {
                
                VStack (alignment: .leading) {
                    
                    KFImage(URL(string: user.profilePictureUrl))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                        .scaledToFill()
                        .clipShape(Rectangle())
                        .cornerRadius(20)
                        .shadow(radius: 5)
                    
                    Spacer()
                    
                    VStack (alignment: .leading, spacing: 4)  {
                        
                        Text("\(user.userName.capitalizingFirstLetter()), \(user.age)")
                        
                            .font(.system(size:15)).bold()
                            .foregroundColor(.white)
                        
                        Text(user.location)
                            .font(.system(size:15))
                            .foregroundColor(.white)
                        
                    }
                }.padding(25)
                
                VStack (alignment: .leading) {
                    HStack {
                        Text(user.sports.lowercased())
                            .padding(.leading, 2)
                            .font(.system(size:15))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                    }
                    .foregroundColor(.white)
                    .font(.caption2)
                    .padding(4)
                    .background(Color.blue.opacity(0.3)
                        .cornerRadius(10))
                    .padding(4)
                    Spacer()
                    
                    Text(user.bio)
                    
                        .font(.system(size:15)).fontWeight(Font.Weight.medium)
                        .lineSpacing(5)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    
                    NavigationLink(destination: ChatLogView(reciever: user)){
                        Text("Start Chat") .bold()
                            .frame(maxWidth: 400, maxHeight: 40)
                            .background(Color("FancyGreen"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
  
                }
                
            }
        }
        //        } else {
        //            ProfileView()
        ////            Image("lookingForAFriend")
        ////                .resizable()
        ////                .aspectRatio(contentMode: .fill)
        ////                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        ////                .edgesIgnoringSafeArea(.all)
        //        }
        
    }
}
