
//  SearchView.swift
//  WellPlay
//
//  Created by Nataliya Durdyeva on 8/14/22.

import Foundation
import SwiftUI
import Firebase
import Kingfisher
import UIKit

struct SearchView: View {
    
    @EnvironmentObject private var viewModel: AppViewModel
    
    init() {
        
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.green]
        
    }
    
    private var email = SupportEmail(toAddress: "natalyadu@gmail.com", subject: "Support Email", messageHeader: "Please describe your issue below")
    @State private var userName = ""
    @State private var age = ""
    @State private var location = ""
    @State private var sports = ""
    @State var searchText = ""
    @State var shouldShowLogOutOptions = false
    @Environment(\.openURL) var openURL
    let searchRectangleColor = Color(red: 0.68, green: 0.81, blue: 0.92)

    var filteredUsers: [User] {
        if searchText.isEmpty {
            return viewModel.users
        } else {
            return viewModel.users.filter { $0.sports.localizedCaseInsensitiveContains(searchText)}
        }
    }
    
    var body: some View {
        
        NavigationView {
            
//MARK: Navigation bar
            
            VStack {
                HStack (alignment: .bottom) {
                    Text("FIND SPORT BUDDIES NEAR YOU!")
                        .font(.headline)
                        .foregroundColor(.white)
                    Button(role: .none) {shouldShowLogOutOptions = true
                    } label: {
                        Image(systemName: "gear")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Color(.white))
                    }
                    .alert("What do you want to do?", isPresented: $shouldShowLogOutOptions) {
                        Button("Sign Out", action: {viewModel.signout()})
                        Link("Donate WellPlay creator", destination: URL(string: "https://www.paypal.me/NataliyaDurdyeva")!)
                        Button("Email Support", action: {email.send(openURL: openURL)})
                        Button("Delete Account", role: .destructive, action: {viewModel.deleteUser()})
                        Button("Cancel", role: .cancel, action: {})
                    }
                } .background(Color("DarkBlue"))
                
  //MARK: SEARCH BAR
                
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
                
 //MARK: LIST OF USERS
                
                VStack {
                    
                    List {
                        
                        ForEach(filteredUsers, id: \.self)
                        { user in
                            
                            SearchCell(user: user)
                            
                        }
                        .listRowBackground(Color("DarkBlue"))
                    }
                    .listStyle(.plain)
                    
                    
                }
            }
            .onAppear() {
                self.viewModel.fetchUsers()
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .background(Color("DarkBlue"))
            
        }
    }
    
 //MARK: CUSTOM CELL
    
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
                        .background(Color("DarkBlue"))
                    
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
        }
    }
    
    
//MARK: FORMATTING EMAIL
    struct SupportEmail {
        let toAddress: String
        let subject: String
        let messageHeader: String
        var body: String {"""
If you are reporting user please tell us their username and the reason you are reporting them. Thank you!
\(messageHeader)
------------------------------------------------------------
"""}
        
        
        func send(openURL: OpenURLAction) {
            let urlString = "mailto:\(toAddress)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "" )"
            guard let url = URL(string: urlString) else {return}
            openURL(url) { accepted in
                if !accepted {
                    print("""
                    This device does not support email
                    \(body)
                    """)
                }
            }
        }
    }
}
