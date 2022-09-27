//
//  EditProfile.swift
//  WELLPLAY
//
//  Created by Nataliya Durdyeva on 9/26/22.
//

import Foundation
import UIKit
import SwiftUI
import Kingfisher

struct EditProfileView: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    
    init() {

        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Georgia-Bold", size: 50)!]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }

    @State private var userName = ""
    @State private var age = ""
    @State private var location = ""
    @State private var sports = ""
    @State private var bio = ""
    @State private var profilePictureUrl = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        NavigationView {
            ZStack{
                Color("DarkBlue")
                    .ignoresSafeArea(.all)
                VStack {
                    
                    VStack{
                        Text("MY PROFILE")
                            .foregroundColor(.white)
                            .font(.system(size:25))
                            .bold()
                        Spacer()
                        
                        KFImage(URL(string: viewModel.currentUser?.profilePictureUrl ?? self.profilePictureUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .cornerRadius(20)
                        
                        TextField("\(viewModel.currentUser?.userName.capitalizingFirstLetter() ?? self.userName), \(viewModel.currentUser?.age ?? self.age)", text: $userName)
                            
                        
                        TextField(viewModel.currentUser?.location ?? self.location, text: $location)
                           
                        
                        Spacer()
                        
                        Text("Your current sports:")
                            .font(.system(size:20)).fontWeight(Font.Weight.medium)
                            .foregroundColor(.white)
                        TextField(viewModel.currentUser?.sports ?? self.sports, text: $sports)
                            
                    }
                    
                    
                    VStack {
                        
                        TextField(viewModel.currentUser?.bio ?? self.bio, text: $bio)
                            
                            .frame(width: 280, height: 100)
                        //                        .background(Color("DarkBlue"))
                            .cornerRadius(20)
                            .multilineTextAlignment(.leading)
                        
                    }
                    
                    .padding()
                    
                    Spacer()
                    
                    VStack{
                        
                        
                        Button(action: {
                            
                            viewModel.updateUser(userName: userName, age: age)
                            dismiss()
                        }) {
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 280, height: 45)
                                    .foregroundColor(Color(.lightGray))
                                
                                Text("Update")
                                    .font((.system(size: 15, weight: .semibold, design: .default))
                                    )
                            }
                        }
                        .padding(30)
                     
                        
                    }
                }.onAppear() {
                    self.viewModel.fetchUsers()
                }
                .navigationBarHidden(false)
                
            }
        }
    }
}



