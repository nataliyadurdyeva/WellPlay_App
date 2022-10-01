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
    
    @ObservedObject var viewModel: AppViewModel
    
    init() {
        
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Georgia-Bold", size: 50)!]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        
        
        self.viewModel = AppViewModel()
//        viewModel.fetchUsers()
        
        
        
        
    }
    @State private var isShowingEditName: Bool = false
    @State private var isShowingEditAge: Bool = false
    @State private var isShowingEditLocation: Bool = false
    @State private var isShowingEditSports: Bool = false
    @State private var isShowingEditBio: Bool = false
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
                        
                        KFImage(URL(string: viewModel.currentUser?.profilePictureUrl ?? self.profilePictureUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 250, height: 250)
                            .clipShape(Circle())
                            .cornerRadius(20)
                        HStack {
                            Text(viewModel.currentUser?.userName.capitalizingFirstLetter() ?? self.userName)
                                .font(.system(size:25)).fontWeight(Font.Weight.medium)
                                .foregroundColor(.white)
                            Button(action: { isShowingEditName.toggle() }, label: {
                                Image(systemName: "pencil.circle")
                                    .font(.system(size: 10))
                                    .foregroundColor(.gray)
                                
                            })
                            .sheet(isPresented: $isShowingEditName, content: { EditNameView()
                                
                            })
                            
                        }
                        HStack {
                            Text(viewModel.currentUser?.age ?? self.age)
                                .font(.system(size:15)).fontWeight(Font.Weight.medium)
                                .foregroundColor(.white)
                            Button(action: { isShowingEditAge.toggle() }, label: {
                                Image(systemName: "pencil.circle")
                                    .font(.system(size: 10))
                                    .foregroundColor(.gray)
                                
                            })
                            .sheet(isPresented: $isShowingEditAge, content: { EditAgeView()
                                
                            })
                            
                        }
                        HStack {
                            Text(viewModel.currentUser?.location ?? self.location)
                                .font(.system(size:15)).fontWeight(Font.Weight.medium)
                                .foregroundColor(.white)
                            Button(action: { isShowingEditLocation.toggle() }, label: {
                                Image(systemName: "pencil.circle")
                                    .font(.system(size: 10))
                                    .foregroundColor(.gray)
                                
                            })
                            .sheet(isPresented: $isShowingEditLocation, content: { EditLocationView()
                                
                            })
                            
                        }
                        Spacer()
                        VStack {
                            HStack{
                            Text("Your current sports:")
                                .font(.system(size:25)).fontWeight(Font.Weight.medium)
                                .foregroundColor(.white)
                            Button(action: { isShowingEditSports.toggle() }, label: {
                                Image(systemName: "pencil.circle")
                                    .font(.system(size: 10))
                                    .foregroundColor(.gray)
                                
                            })
                            .sheet(isPresented: $isShowingEditSports, content: { EditSportsView()
                                
                            })
                        }
                            HStack {
                                Text(viewModel.currentUser?.sports ?? self.sports)
                                    .foregroundColor(.white)
                                    .font(.system(size:18)).fontWeight(Font.Weight.light)
                               
                            }.padding(8)
                            
                            HStack {
                            Text("Your bio:")
                                .font(.system(size:25)).fontWeight(Font.Weight.medium)
                                .foregroundColor(.white)
                                .padding(10)
                            
                            Button(action: { isShowingEditBio.toggle() }, label: {
                                Image(systemName: "pencil.circle")
                                    .font(.system(size: 10))
                                    .foregroundColor(.gray)
                                
                            })
                            .sheet(isPresented: $isShowingEditBio, content: { EditBioView()
                                
                            })
                        }
                            VStack (alignment: .leading){
                                Text(viewModel.currentUser?.bio ?? self.bio)
                                    .font(.system(size:18)).fontWeight(Font.Weight.light)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading)
                               
                                
                            }.padding(20)
                            
                        }
                        Spacer()
                        
                    }.onAppear() {
                        self.viewModel.fetchUsers()
                    }
                    
                
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
