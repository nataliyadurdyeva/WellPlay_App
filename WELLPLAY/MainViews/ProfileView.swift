//
//  ProfileView.swift
//  WellPlay
//
//  Created by Nataliya Durdyeva on 8/14/22.
//

import Foundation
import UIKit
import SwiftUI
import Kingfisher

struct ProfileView: View {
    
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
                        
                        Text("\(viewModel.currentUser?.userName.capitalizingFirstLetter() ?? self.userName), \(viewModel.currentUser?.age ?? self.age)")
                            .font(.system(size:25)).fontWeight(Font.Weight.medium)
                            .foregroundColor(.white)
                        
                        Text(viewModel.currentUser?.location ?? self.location)
                            .font(.system(size:15)).fontWeight(Font.Weight.medium)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("Your current sports:")
                            .font(.system(size:20)).fontWeight(Font.Weight.medium)
                            .foregroundColor(.white)
                        Text(viewModel.currentUser?.sports ?? self.sports)
                            .foregroundColor(.white)
                            .font(.system(size:18)).fontWeight(Font.Weight.light)
                    }
                    
                    
                    VStack {
                        
                        Text(viewModel.currentUser?.bio ?? self.bio)
                            .font(.system(size:18)).fontWeight(Font.Weight.light)
                            .foregroundColor(.white)
                            .frame(width: 280, height: 100)
                        //                        .background(Color("DarkBlue"))
                            .cornerRadius(20)
                            .multilineTextAlignment(.leading)
                        
                    }
                    
                    .padding()
                    
                    Spacer()
                    
                    VStack{
                        
                        
                        Button(action: {
                            
                            viewModel.signout()
                        }) {
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 280, height: 45)
                                    .foregroundColor(Color(.lightGray))
                                
                                Text("Sign Out")
                                    .font((.system(size: 15, weight: .semibold, design: .default))
                                    )
                            }
                        }
                        .padding(30)
                        Button(action: {
                            
                            viewModel.deleteUser()
                            viewModel.signout()
                        }) {
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 280, height: 45)
                                    .foregroundColor(Color(.lightGray))
                                
                                Text("Delete Account")
                                    .font((.system(size: 15, weight: .semibold, design: .default))
                                    )
                            }
                        }
                        
                    }
                }.onAppear() {
                    self.viewModel.fetchUsers()
                }
                .navigationBarHidden(false)
                
            }
        }
    }
}


extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
